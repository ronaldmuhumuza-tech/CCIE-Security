# 02 – Building the Root Certificate Authority (Root CA)

## Objective

Build an enterprise-style Offline Root Certificate Authority (CA) using OpenSSL. The Root CA establishes the trust anchor for the CCIESEC-LAB Public Key Infrastructure (PKI) and will later be used to sign the Intermediate Certificate Authority.

---

## Background

The Root Certificate Authority is the highest level of trust within a PKI hierarchy. Unlike server certificates, the Root CA is self-signed because no higher authority exists to verify its identity.

In enterprise environments, the Root CA is typically kept offline and used only for security-critical operations such as signing Intermediate CAs, publishing Certificate Revocation Lists (CRLs) and renewing subordinate CAs. Routine certificate issuance is delegated to Intermediate CAs, reducing the exposure of the Root private key.

<p align="center">
  <img src="../diagrams/pki-hierarchy-design.png" width="850">
</p>

<p align="center">
<i>Figure 1 – Enterprise PKI hierarchy.</i>
</p>

---

# Implementation

## 1. Create the PKI Directory Structure

The OpenSSL Certificate Authority requires a standard directory structure for storing certificates, private keys and certificate metadata.

```bash
mkdir -p ~/PKI/{private,certs,csr,newcerts,crl}

touch ~/PKI/index.txt

echo 1000 > ~/PKI/serial
```

Directory structure created:

- private/
- certs/
- csr/
- newcerts/
- crl/
- index.txt
- serial

---

## 2. Generate the Root Private Key

Generate an encrypted 4096-bit RSA private key.

```bash
openssl genpkey \
    -algorithm RSA \
    -pkeyopt rsa_keygen_bits:4096 \
    -out ~/PKI/private/rootca01.key
```

Restrict access to the owner only.

```bash
chmod 600 ~/PKI/private/rootca01.key
```

---

## 3. Verify the Private Key

Verify that the private key has been generated successfully.

```bash
openssl pkey \
    -in ~/PKI/private/rootca01.key \
    -text \
    -noout
```

Verify:

- RSA 4096-bit key
- Key integrity
- PEM format

---

## 4. Configure the Root CA

Create a dedicated OpenSSL configuration file.

Configuration includes:

- Distinguished Name (DN)
- SHA-256
- Basic Constraints
- Key Usage
- Subject Key Identifier
- Authority Key Identifier

Configuration file:

```
configs/openssl-root.cnf
```

---

## 5. Generate the Root Certificate

Create a self-signed Root Certificate.

```bash
openssl req \
    -new \
    -x509 \
    -config ~/PKI/openssl-root.cnf \
    -key ~/PKI/private/rootca01.key \
    -sha256 \
    -days 7300 \
    -set_serial 0x1000 \
    -out ~/PKI/certs/rootca01.crt
```

---

## 6. Verify the Root Certificate

Inspect the certificate.

```bash
openssl x509 \
    -in ~/PKI/certs/rootca01.crt \
    -text \
    -noout
```

Verify:

- Version 3 certificate
- SHA-256 signature
- Subject = Issuer
- RSA 4096-bit key
- CA:TRUE
- KeyCertSign
- CRLSign

---

## 7. Verify Trust

Verify that the Root CA trusts itself.

```bash
openssl verify \
    -CAfile ~/PKI/certs/rootca01.crt \
    ~/PKI/certs/rootca01.crt
```

Expected result:

```
rootca01.crt: OK
```

---

# Validation

✓ PKI directory structure created

✓ RSA 4096 private key generated

✓ Private key permissions secured

✓ Root certificate successfully generated

✓ Certificate extensions verified

✓ Root certificate successfully validated

---

# Enterprise Considerations

- Keep the Root CA offline.
- Never issue end-device certificates directly from the Root CA.
- Protect the Root private key with strong encryption.
- Maintain secure offline backups.
- Use Intermediate CAs for routine certificate issuance.

---

# Key Takeaways

- The Root CA is the trust anchor of the PKI.
- Enterprise PKIs separate Root and Intermediate Certificate Authorities.
- The Root private key is the most valuable asset within the PKI.
- Verification confirms that the Root certificate is correctly configured before issuing subordinate certificates.

---

# Next Step

Build the Intermediate Certificate Authority, which will become the operational issuing CA for enterprise devices while allowing the Root CA to remain securely offline.