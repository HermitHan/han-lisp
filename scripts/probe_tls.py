"""Temporary loopback HTTPS service for Han's optional boundary probes."""

from contextlib import contextmanager
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import secrets
import shutil
import ssl
import subprocess
import tempfile
import threading

from probe_dns import nxdomain_response


class _TLSServer(ThreadingHTTPServer):
    daemon_threads = False

    def __init__(self, context):
        super().__init__(("127.0.0.1", 0), _ProbeHandler)
        self.context = context
        self.response_body = secrets.token_hex(16).encode("ascii")
        self.nxdomain_count = 0
        self.count_lock = threading.Lock()

    def completed_nxdomains(self):
        with self.count_lock:
            return self.nxdomain_count

    def get_request(self):
        client, address = super().get_request()
        client.settimeout(5)
        try:
            return self.context.wrap_socket(client, server_side=True), address
        except OSError:
            client.close()
            raise


class _ProbeHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/han-probe":
            self.send_error(404)
            return
        body = self.server.response_body
        self.send_response(200)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_POST(self):
        if self.path != "/dns-query":
            self.send_error(404)
            return
        if self.headers.get_content_type() != "application/dns-message":
            self.send_error(415)
            return
        try:
            length = int(self.headers.get("Content-Length", ""))
        except ValueError:
            self.send_error(400, "Expected Content-Length")
            return
        if not 12 <= length <= 65535:
            self.send_error(400, "Invalid DNS message length")
            return
        query = self.rfile.read(length)
        if len(query) != length:
            self.send_error(400, "Incomplete DNS message")
            return
        try:
            response = nxdomain_response(query)
        except ValueError:
            self.send_error(400, "Invalid DNS question")
            return
        self.send_response(200)
        self.send_header("Content-Type", "application/dns-message")
        self.send_header("Content-Length", str(len(response)))
        self.end_headers()
        with self.server.count_lock:
            self.wfile.write(response)
            self.wfile.flush()
            self.server.nxdomain_count += 1

    def log_message(self, format, *args):
        pass


@contextmanager
def tls_fixture(curl):
    """Yield the HTTPS URL, DoH URL, and a reader for completed NXDOMAIN replies."""
    openssl = shutil.which("openssl")
    if not openssl:
        raise RuntimeError("The TLS probe requires openssl on PATH.")
    with tempfile.TemporaryDirectory(prefix="han-probe-tls-") as directory:
        root = Path(directory)
        key = root / "key.pem"
        cert = root / "cert.pem"
        config = root / "openssl.cnf"
        config.write_text(
            "[req]\ndistinguished_name=dn\nx509_extensions=server\nprompt=no\n"
            "[dn]\nCN=127.0.0.1\n"
            "[server]\nsubjectAltName=IP:127.0.0.1\n"
            "basicConstraints=critical,CA:FALSE\n"
            "keyUsage=critical,digitalSignature,keyEncipherment\n"
            "extendedKeyUsage=serverAuth\n",
            encoding="ascii",
        )
        generate = subprocess.run(
            [openssl, "req", "-x509", "-newkey", "rsa:2048", "-nodes", "-sha256",
             "-days", "1", "-config", str(config), "-out", str(cert), "-keyout", str(key)],
            capture_output=True, timeout=30,
        )
        if generate.returncode:
            raise RuntimeError(f"Could not generate TLS certificate: {generate.stderr!r}")
        context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        context.load_cert_chain(cert, key)
        with _TLSServer(context) as server:
            origin = f"https://127.0.0.1:{server.server_port}"
            url = origin + "/han-probe"
            thread = threading.Thread(target=server.serve_forever, args=(0.1,))
            thread.start()
            try:
                command = [curl, "--disable", "--silent", "--show-error", "--noproxy", "*",
                           "--http1.1", "--max-time", "5"]
                untrusted = subprocess.run([*command, url], capture_output=True, timeout=10)
                if untrusted.returncode != 60 or untrusted.stdout or not untrusted.stderr:
                    raise RuntimeError(f"Untrusted TLS request exited {untrusted.returncode}: "
                                       f"{untrusted.stderr!r}")
                trusted = subprocess.run([*command, "--cacert", str(cert), url],
                                         capture_output=True, timeout=10)
                if trusted.returncode or trusted.stdout != server.response_body:
                    raise RuntimeError(f"Trusted TLS control exited {trusted.returncode}, "
                                       f"body={trusted.stdout!r}, stderr={trusted.stderr!r}")
                print("CONTROL TLS untrusted certificate exit=60; trusted request verified "
                      "the loopback server response", flush=True)
                yield url, origin + "/dns-query", server.completed_nxdomains
            finally:
                server.shutdown()
                thread.join()
