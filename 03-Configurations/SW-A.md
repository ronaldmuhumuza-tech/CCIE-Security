# SW-A – Base Configuration

## Objective

Provide Layer 2 connectivity for Site A and management access.

---

## Hostname

```cisco
hostname SW-A
```

---

## Management

Management VLAN:

192.168.10.2/24

Default gateway:

192.168.10.1

---

## Connected Devices

- FW-A
- ROOTCA01
- ICA01
- WIN11

---

## Enable

- SSH
- Local login
- NTP
- DNS
- Interface descriptions

---

## Validation

- Ping FW-A
- Ping ROOTCA01
- Ping ICA01
- Ping WIN11