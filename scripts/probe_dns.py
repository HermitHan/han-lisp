"""DNS wire replies for the local han-probe.invalid. DoH fixture."""

import struct


_HEADER = struct.Struct("!6H")
_RECORD = struct.Struct("!HHIH")
_ZONE = b"\x07invalid\x00"
_QNAME = b"\x09han-probe" + _ZONE


def _edns_reply(record: bytes) -> bytes:
    """Validate the request's OPT record and return an empty EDNS(0) OPT."""
    if len(record) < 11 or record[0] != 0:
        raise ValueError("expected an OPT record with the root owner name")
    rr_type, _, ttl, length = _RECORD.unpack_from(record, 1)
    if rr_type != 41 or ttl >> 16 or len(record) != 11 + length:
        raise ValueError("invalid OPT type, extended RCODE, version, or length")
    offset = 11
    while offset < len(record):
        if len(record) - offset < 4:
            raise ValueError("truncated EDNS option header")
        _, size = struct.unpack_from("!HH", record, offset)
        offset += 4 + size
        if offset > len(record):
            raise ValueError("truncated EDNS option data")
    return b"\x00" + _RECORD.pack(41, 512, ttl & 0x8000, 0)


def nxdomain_response(query: bytes) -> bytes:
    """Answer one IN A/AAAA query for han-probe.invalid.; reject others."""
    name_end = _HEADER.size + len(_QNAME)
    question_end = name_end + 4
    if not isinstance(query, bytes) or not question_end <= len(query) <= 65535:
        raise ValueError("invalid DNS query size")
    query_id, flags, questions, answers, authorities, additionals = _HEADER.unpack_from(query)
    # A standard question may request recursion, authenticated data, or disabled checking.
    if flags & ~0x0130 or (questions, answers, authorities) != (1, 0, 0) or additionals > 1:
        raise ValueError("expected a standard DNS query with one question")
    if query[_HEADER.size:name_end].lower() != _QNAME:
        raise ValueError("only han-probe.invalid. may be queried")
    qtype, qclass = struct.unpack_from("!HH", query, name_end)
    if qtype not in (1, 28) or qclass != 1:
        raise ValueError("only IN A and AAAA questions are supported")
    opt = b""
    if additionals:
        opt = _edns_reply(query[question_end:])
    elif len(query) != question_end:
        raise ValueError("unexpected data after the DNS question")

    # An authoritative negative answer carries the zone SOA (RFC 2308).
    # Both TTL and MINIMUM are zero so each independent probe can ask again.
    soa_data = (b"\x02ns" + _ZONE + b"\x0ahostmaster" + _ZONE
                + struct.pack("!5I", 1, 60, 60, 86400, 0))
    authority = _ZONE + _RECORD.pack(6, 1, 0, len(soa_data)) + soa_data
    reply_flags = 0x8403 | (flags & 0x0110)  # QR, AA, NXDOMAIN, and the client's RD/CD
    header = _HEADER.pack(query_id, reply_flags, 1, 0, 1, additionals)
    return header + query[_HEADER.size:question_end] + authority + opt
