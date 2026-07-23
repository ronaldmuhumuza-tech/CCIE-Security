# ISP-R1 – Base Configuration

## Objective

Configure the ISP router to provide Layer 3 connectivity between Site A and Site B.

---

## Hostname

```cisco
hostname ISP-R1
```

---

## Interfaces

| Interface | Address | Description |
|-----------|----------|-------------|
| Gi0/0 | 172.16.12.1/30 | FW-A Outside |
| Gi0/1 | 172.16.23.1/30 | FW-B Outside |
| Gi0/2 | Reserved | PNET NAT (future) |

---

## Static Routes

```cisco
ip route 192.168.10.0 255.255.255.0 172.16.12.2
ip route 192.168.20.0 255.255.255.0 172.16.23.2
```

---

## Management

- SSH
- Local user
- NTP
- DNS lookup
- Interface descriptions

---

## Validation

- Ping FW-A
- Ping FW-B
- Ping Site A LAN
- Ping Site B LAN