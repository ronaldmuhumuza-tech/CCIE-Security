# 03 – Building the Intermediate Certificate Authority (Intermediate CA)

## Objective

Build an enterprise-style Intermediate Certificate Authority (CA) using OpenSSL. The Intermediate CA will be signed by the Offline Root CA and will become the operational CA responsible for issuing certificates to enterprise devices and services.

---

## Background

Enterprise PKI deployments rarely issue certificates directly from the Root CA. Instead, one or more Intermediate CAs are used to perform day-to-day certificate issuance.

This design provides several advantages:

- The Root CA remains offline, reducing the risk of compromise.
- Operational certificates can be renewed or revoked without exposing the Root private key.
- Multiple Intermediate CAs can be deployed for different business functions or security domains.

<p align="center">
  <img src="../diagrams/pki-hierarchy-design.png" width="850">
</p>

<p align="center">
<i>Figure 1 – Enterprise PKI hierarchy showing the Intermediate CA signed by the Offline Root CA.</i>
</p>

---

# Implementation

## 1. Create the Intermediate CA Directory Structure

Create a dedicated directory structure for the Intermediate CA.

```bash
mkdir -p ~/PKI/intermediate/{private,certs,csr,newcerts,crl}

touch ~/PKI/intermediate/index.txt

echo 2000 > ~/PKI/intermediate/serial
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

## 2. Generate the Intermediate Private Key

Generate an encrypted 4096-bit RSA private key.

```bash
openssl genpkey \
    -algorithm RSA \
    -pkeyopt rsa_keygen_bits:4096 \
    -out ~/PKI/intermediate/private/intermediate.key.pem
```

Restrict access to the owner.

```bash
chmod 600 ~/PKI/intermediate/private/intermediate.key.pem
```

---

## 3. Create the Certificate Signing Request (CSR)

Generate a CSR for the Intermediate CA.

```bash
openssl req \
    -new \
    -config configs/openssl-intermediate.cnf \
    -key ~/PKI/intermediate/private/intermediate.key.pem \
    -out ~/PKI/intermediate/csr/intermediate.csr.pem
```

The CSR contains the Intermediate CA's identity and public key but is not yet trusted.

---

## 4. Sign the Intermediate CA Certificate

Use the Offline Root CA to sign the CSR.

```bash
openssl ca \
    -config configs/openssl-root.cnf \
    -extensions v3_intermediate_ca \
    -days 3650 \
    -in ~/PKI/intermediate/csr/intermediate.csr.pem \
    -out ~/PKI/intermediate/certs/intermediate.crt
```

This establishes the trust relationship between the Root CA and the Intermediate CA.

---

## 5. Verify the Intermediate Certificate

Inspect the issued certificate.

```bash
openssl x509 \
    -in ~/PKI/intermediate/certs/intermediate.crt \
    -text \
    -noout
```

Verify:

- Version 3 certificate
- SHA-256 signature
- Issuer = Root CA
- Subject = Intermediate CA
- CA:TRUE
- pathlen:0
- KeyCertSign
- CRLSign

---

## 6. Build the Certificate Chain

Create the certificate chain by combining the Intermediate and Root certificates.

```bash
cat \
~/PKI/intermediate/certs/intermediate.crt \
~/PKI/certs/rootca01.crt \
> ~/PKI/intermediate/certs/chain.pem
```

The certificate chain will be distributed to clients and servers during certificate deployment.

---

## 7. Verify the Certificate Chain

Verify that the Intermediate CA chains correctly to the trusted Root CA.

```bash
openssl verify \
-CAfile ~/PKI/certs/rootca01.crt \
~/PKI/intermediate/certs/intermediate.crt
```

Expected result:

```
intermediate.crt: OK
```

---

# Validation

✓ Intermediate CA directory structure created

✓ RSA 4096 private key generated

✓ CSR successfully created

✓ Intermediate certificate signed by the Root CA

✓ Certificate chain created

✓ Certificate chain successfully verified

---

# Enterprise Considerations

- Keep the Root CA offline after signing the Intermediate CA.
- Perform all routine certificate issuance from the Intermediate CA.
- Protect the Intermediate private key with encryption and regular backups.
- Publish Intermediate CRLs regularly.
- Consider deploying multiple Intermediate CAs for different security domains (e.g. User, Server and Network Device certificates).

---

# Key Takeaways

- The Intermediate CA separates operational certificate issuance from the Root CA.
- The Root CA signs only subordinate CAs, preserving the security of the trust anchor.
- End-entity certificates should always be issued by an Intermediate CA.
- Certificate chains allow clients to validate trust back to the Root CA.

---

# Next Step

Issue X.509 certificates for enterprise devices and services, including web servers, Cisco ASA, Cisco FMC, Cisco ISE and other infrastructure components using the Intermediate CA.