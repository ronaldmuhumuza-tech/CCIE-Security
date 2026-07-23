# 01 – PKI Fundamentals

## Objective

Understand the core principles behind Public Key Infrastructure (PKI) before configuring Certificate Authorities (CAs), certificates, or OpenSSL. The goal is to understand *why* PKI exists and how it establishes trust in enterprise networks.

## What is PKI?

Public Key Infrastructure (PKI) is the framework used to establish trust between users, devices and applications. It combines cryptographic algorithms, digital certificates, Certificate Authorities (CAs) and operational processes to verify identity and protect communications.

PKI is used extensively across enterprise environments, including:

- HTTPS websites
- SSL/TLS VPNs
- 802.1X network authentication
- Secure Shell (SSH)
- Wi-Fi authentication
- Email signing and encryption
- Code signing

PKI does not encrypt traffic by itself. Its primary purpose is to establish trusted identities and securely exchange cryptographic keys.


## Symmetric vs Asymmetric Cryptography

Cryptography falls into two broad categories.

| Symmetric Cryptography | Asymmetric Cryptography |
|------------------------|-------------------------|
| Uses a single shared key | Uses a public/private key pair |
| Fast | Computationally more expensive |
| Best suited for encrypting data | Best suited for identity, authentication and key exchange |

In production networks, both are used together. Asymmetric cryptography establishes trust and exchanges keys, while symmetric cryptography performs the bulk of the encryption because it is significantly faster.


## Public and Private Keys

A key pair consists of:

- A **private key**, which must remain secret.
- A **public key**, which can be shared freely.

The two keys are mathematically related, but it is computationally infeasible to derive the private key from the public key.

The private key is the most valuable asset in a PKI. If it is compromised, the identity associated with that key is also compromised.


## Digital Signatures

A digital signature provides:

- Authentication - confirms who signed the data.
- Integrity - confirms the data has not been tampered with or modified in transmission.
- Non-repudiation (verifiable proof of origin) - the signer cannot credibly dny creating the signature.

Rather than signing the entire document, a hash of the document is signed using the private key. Anyone with the corresponding public key can verify the signature and confirm that the data has not been altered.


## Hash Functions

A cryptographic hash function converts data of any size into a fixed-length digest.

Common examples include:

- SHA-256
- SHA-384
- SHA-512

A secure hash function exhibits the avalanche effect (a small change in the input produces a completely different hash output).

Hashing provides integrity, not confidentiality.


## PKI and the CIA Triad

PKI supports two of the three core security principles defined by the CIA Triad:

- **Confidentiality** – achieved by enabling secure key exchange and encryption, ensuring that only authorised parties can access sensitive information.
- **Integrity** – achieved through cryptographic hash functions and digital signatures, allowing recipients to detect unauthorised changes to data.

**Availability** is not a direct function of PKI. It is achieved through resilient system design, redundancy, backups, high availability (HA), and disaster recovery (DR). However, a poorly designed or unavailable PKI can prevent users and systems from authenticating, indirectly affecting service availability.


## Key Takeaways

- PKI establishes trust, not encryption.
- Private keys must always remain protected.
- Public keys are intended to be distributed.
- Digital signatures provide authentication, integrity and non-repudiation.
- Modern enterprise security combines asymmetric cryptography for identity and key exchange with symmetric cryptography for efficient data encryption.
- PKI primarily supports **Confidentiality** and **Integrity** within the CIA Triad. **Availability** depends on resilient PKI design and infrastructure rather than cryptography itself.