# Security Best Practices for New Technology Platforms

> A comprehensive security guideline for building and operating a new technology platform (e.g., social media, marketplace, SaaS).

---

## Table of Contents

1. [Secure Architecture & Design](#1-secure-architecture--design)
2. [Authentication & Identity Management](#2-authentication--identity-management)
3. [Authorization & Access Control](#3-authorization--access-control)
4. [Data Protection & Privacy](#4-data-protection--privacy)
5. [API Security](#5-api-security)
6. [Input Validation & Output Encoding](#6-input-validation--output-encoding)
7. [Session Management](#7-session-management)
8. [Cryptography](#8-cryptography)
9. [Logging, Monitoring & Incident Response](#9-logging-monitoring--incident-response)
10. [Infrastructure & Network Security](#10-infrastructure--network-security)
11. [Secure Software Development Lifecycle (SSDLC)](#11-secure-software-development-lifecycle-ssdlc)
12. [Third-Party & Supply Chain Security](#12-third-party--supply-chain-security)
13. [Content Security & Abuse Prevention](#13-content-security--abuse-prevention)
14. [Compliance & Regulatory](#14-compliance--regulatory)
15. [Security Checklist Summary](#15-security-checklist-summary)

---

## 1. Secure Architecture & Design

### 1.1 Threat Modeling
- Perform threat modeling (STRIDE, DREAD, PASTA) **before** writing code.
- Identify trust boundaries, entry points, data flows, and assets.
- Revisit the threat model with every major feature release.

### 1.2 Defense in Depth
- Layer multiple security controls — never rely on a single mechanism.
- Assume every layer can be breached; design the next layer accordingly.

### 1.3 Zero Trust Architecture
- Verify explicitly: authenticate and authorize every request regardless of network origin.
- Apply least-privilege access at every tier (frontend, backend, database, infrastructure).
- Assume breach: segment networks and limit blast radius.

### 1.4 Microservices & Service Mesh
- Enforce mutual TLS (mTLS) between services.
- Use a service mesh (Istio, Linkerd) for traffic encryption, observability, and policy enforcement.
- Isolate sensitive services (payments, auth) into separate security zones.

### 1.5 Fail Secure
- Default to denying access when a security component fails.
- Never expose stack traces, internal paths, or debug info in production error responses.

---

## 2. Authentication & Identity Management

### 2.1 Password Policy
- Enforce a **minimum of 12 characters**; encourage passphrases.
- Do **not** impose arbitrary complexity rules (e.g., must contain special char) — they reduce usability without significantly improving security.
- Check passwords against breached-password databases (e.g., HaveIBeenPwned API, k-anonymity model).
- Implement account lockout or exponential backoff after repeated failed attempts.

### 2.2 Password Storage
- Use **Argon2id** (preferred), bcrypt, or scrypt — never MD5, SHA-1, or plain SHA-256.
- Use a unique, random salt per user (handled automatically by Argon2id/bcrypt).
- Tune cost parameters so hashing takes ≥ 250ms on your target hardware.

### 2.3 Multi-Factor Authentication (MFA)
- Offer MFA to all users; **enforce** it for admin, moderator, and privileged accounts.
- Support TOTP (Google Authenticator, Authy), WebAuthn/FIDO2 hardware keys, and passkeys.
- Avoid SMS-based OTP as a primary factor (SIM-swap vulnerability); offer it only as a fallback.

### 2.4 Passwordless & Passkeys
- Implement WebAuthn/FIDO2 passkeys as a modern, phishing-resistant login method.
- Store public key credentials server-side; private keys never leave the user's device.

### 2.5 OAuth 2.0 / OpenID Connect (Social Login)
- Use **Authorization Code Flow with PKCE** — never Implicit Flow.
- Validate `state` parameter to prevent CSRF.
- Validate ID token `iss`, `aud`, `exp`, and `nonce` claims.
- Request only the minimum scopes needed.

### 2.6 Account Recovery
- Use time-limited, single-use, cryptographically random recovery tokens.
- Do not reveal whether an email/username exists during recovery ("If an account exists, we sent a link").
- Require re-authentication or MFA before changing email, phone, or password.

---

## 3. Authorization & Access Control

### 3.1 Principle of Least Privilege
- Grant users and services the **minimum permissions** needed for their function.
- Review permissions quarterly; revoke stale access.

### 3.2 Role-Based Access Control (RBAC)
- Define clear roles: User, Moderator, Admin, Super Admin.
- Separate read/write/delete permissions per resource type.
- Never hardcode role checks — use a centralized policy engine.

### 3.3 Attribute-Based Access Control (ABAC)
- For complex scenarios, evaluate attributes (user department, resource owner, time of day, IP geo).
- Use a policy engine (Open Policy Agent, Casbin, AWS Cedar) for fine-grained decisions.

### 3.4 Broken Access Control Prevention
- Enforce authorization **server-side** on every request — never trust client-side checks alone.
- Validate that the authenticated user owns or has access to the requested resource (IDOR prevention).
- Use indirect references (UUIDs) instead of sequential IDs where possible.
- Deny by default: if no policy explicitly grants access, deny.

### 3.5 Admin Panel Security
- Host admin interfaces on a separate subdomain or internal network.
- Require MFA + VPN/IP allowlist for admin access.
- Log every admin action with full audit trail.

---

## 4. Data Protection & Privacy

### 4.1 Data Classification
| Level | Examples | Handling |
|-------|----------|----------|
| **Public** | Marketing content, public profiles | No restrictions |
| **Internal** | Internal docs, analytics | Access-controlled |
| **Confidential** | PII, emails, phone numbers | Encrypted, audited |
| **Restricted** | Passwords, payment data, health data | Encrypted at rest + in transit, strict access, tokenized |

### 4.2 Encryption at Rest
- Encrypt all databases, file stores, and backups using AES-256 or ChaCha20-Poly1305.
- Use envelope encryption with a KMS (AWS KMS, GCP KMS, Azure Key Vault, HashiCorp Vault).
- Rotate encryption keys annually (or per your policy); support key versioning.

### 4.3 Encryption in Transit
- Enforce **TLS 1.3** (minimum TLS 1.2) on all endpoints — public and internal.
- Use HSTS headers with `max-age=31536000; includeSubDomains; preload`.
- Disable legacy protocols (SSLv3, TLS 1.0, TLS 1.1) and weak cipher suites.

### 4.4 Data Minimization
- Collect only the data you need. If you don't need a date of birth, don't ask for it.
- Anonymize or pseudonymize data used for analytics.
- Implement automatic data retention and deletion policies.

### 4.5 PII Handling
- Mask PII in logs (email: `h***@example.com`, IP: `192.168.x.x`).
- Tokenize sensitive fields where possible (payment card numbers, SSNs).
- Provide users with data export (portability) and deletion capabilities.

### 4.6 Backup Security
- Encrypt all backups.
- Store backups in a geographically separate, access-controlled location.
- Test backup restoration quarterly.
- Apply the same access controls to backups as to production data.

---

## 5. API Security

### 5.1 Authentication & Authorization
- Require authentication on every API endpoint (except intentionally public ones).
- Use short-lived JWTs (15 min access token + longer-lived refresh token).
- Validate JWT signature, `iss`, `aud`, `exp`, and `nbf` claims on every request.
- Never store secrets in JWTs; they are base64-encoded, not encrypted.

### 5.2 Rate Limiting & Throttling
- Implement rate limiting per user, per IP, and per endpoint.
- Use sliding window or token bucket algorithms.
- Apply stricter limits to auth endpoints (login, signup, password reset).
- Return `429 Too Many Requests` with `Retry-After` header.

### 5.3 Input Validation
- Validate all inputs: type, length, range, format, allowed characters.
- Use allowlists over denylists.
- Reject unexpected fields (strict schema validation).
- Use schema validation libraries (JSON Schema, Zod, Joi, Pydantic).

### 5.4 API Versioning & Deprecation
- Version your APIs (`/v1/`, `/v2/`) to avoid breaking changes.
- Deprecate old versions with clear timelines and sunset headers.
- Remove deprecated endpoints to reduce attack surface.

### 5.5 GraphQL-Specific
- Disable introspection in production.
- Implement query depth limiting and query cost analysis.
- Use persisted/allowlisted queries to prevent injection attacks.

### 5.6 File Upload Security
- Validate file type by magic bytes (not just extension or MIME type).
- Enforce maximum file size limits.
- Store uploaded files outside the web root; serve via a separate CDN domain.
- Scan uploads for malware (ClamAV or cloud-based scanning).
- Re-encode images to strip EXIF data and embedded payloads.
- Generate random filenames; never use user-supplied names directly.

---

## 6. Input Validation & Output Encoding

### 6.1 Cross-Site Scripting (XSS) Prevention
- Use context-aware output encoding (HTML entity, JavaScript, URL, CSS encoding).
- Use auto-escaping template engines (React JSX, Jinja2 with autoescape, Razor).
- Implement a strict Content Security Policy (CSP):
  ```
  Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; object-src 'none'; base-uri 'self'; frame-ancestors 'none';
  ```
- Sanitize user-generated HTML with a proven library (DOMPurify, Bleach).
- Set `HttpOnly`, `Secure`, and `SameSite=Strict` on cookies.

### 6.2 SQL Injection Prevention
- Use **parameterized queries / prepared statements** — always.
- Use ORM frameworks (Sequelize, Prisma, SQLAlchemy, Entity Framework) with care — raw query modes bypass protection.
- Never concatenate user input into SQL strings.
- Apply least-privilege database accounts per service.

### 6.3 NoSQL Injection Prevention
- Don't pass raw user objects to MongoDB queries; explicitly extract and validate fields.
- Use `$eq` operator explicitly; don't allow query operator injection (`$gt`, `$ne`, etc.).

### 6.4 Command Injection Prevention
- Avoid calling OS commands from application code.
- If unavoidable, use parameterized APIs (not shell interpolation) and strict allowlists.
- Never pass user input to `exec()`, `eval()`, `system()`, or equivalent.

### 6.5 Server-Side Request Forgery (SSRF) Prevention
- Validate and allowlist outbound URLs (scheme, host, port).
- Block requests to internal/private IP ranges (127.0.0.0/8, 10.0.0.0/8, 169.254.169.254, etc.).
- Use a dedicated egress proxy for external HTTP requests.
- Disable unnecessary URL schemes (`file://`, `gopher://`, `dict://`).

### 6.6 Security Headers
```
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Resource-Policy: same-origin
```

---

## 7. Session Management

### 7.1 Session Token Generation
- Use cryptographically secure random generators (≥ 128 bits of entropy).
- Never expose session tokens in URLs, logs, or error messages.

### 7.2 Cookie Security
| Attribute | Value | Purpose |
|-----------|-------|---------|
| `Secure` | Always | Transmit only over HTTPS |
| `HttpOnly` | Always | Prevent JavaScript access |
| `SameSite` | `Strict` or `Lax` | CSRF mitigation |
| `Path` | `/` or restricted | Limit scope |
| `Domain` | Explicit | Prevent subdomain leaks |
| `Max-Age` | Short-lived | Limit window of exposure |

### 7.3 Session Lifecycle
- Invalidate sessions server-side on logout (don't just clear the cookie).
- Regenerate session ID after authentication (prevent session fixation).
- Set absolute session timeout (e.g., 24 hours) and idle timeout (e.g., 30 minutes).
- Allow users to view and revoke active sessions.

### 7.4 CSRF Protection
- Use synchronizer token pattern (anti-CSRF tokens) or double-submit cookie.
- Set `SameSite=Strict` or `Lax` on session cookies.
- Verify `Origin` and `Referer` headers on state-changing requests.

---

## 8. Cryptography

### 8.1 General Principles
- **Never roll your own crypto.** Use vetted libraries (libsodium, OpenSSL, BoringSSL, Web Crypto API).
- Use authenticated encryption (AES-256-GCM, ChaCha20-Poly1305).
- Use unique nonces/IVs for every encryption operation.

### 8.2 Recommended Algorithms (2025+)
| Use Case | Recommended | Avoid |
|----------|-------------|-------|
| Symmetric encryption | AES-256-GCM, ChaCha20-Poly1305 | DES, 3DES, AES-ECB, RC4 |
| Hashing (general) | SHA-256, SHA-3, BLAKE3 | MD5, SHA-1 |
| Password hashing | Argon2id, bcrypt, scrypt | MD5, SHA-*, plain HMAC |
| Asymmetric encryption | RSA-OAEP (4096-bit), ECIES (P-256/P-384) | RSA-1024, RSA-PKCS1v1.5 |
| Digital signatures | Ed25519, ECDSA (P-256), RSA-PSS (4096-bit) | RSA-1024, DSA |
| Key exchange | X25519, ECDH (P-256) | DH-1024 |
| TLS | TLS 1.3 (min 1.2) | SSL, TLS 1.0, TLS 1.1 |

### 8.3 Key Management
- Store keys in a Hardware Security Module (HSM) or managed KMS — never in source code, config files, or environment variables in plaintext.
- Rotate keys regularly; support key versioning for seamless rotation.
- Use separate keys for separate purposes (encryption vs. signing vs. MAC).
- Destroy keys securely when they are retired.

### 8.4 Secrets Management
- Use a secrets manager (HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, GCP Secret Manager).
- Inject secrets at runtime; never bake them into container images or config files.
- Scan repositories for leaked secrets (git-secrets, truffleHog, Gitleaks) in CI/CD.

---

## 9. Logging, Monitoring & Incident Response

### 9.1 Security Logging
**What to log:**
- Authentication events (login, logout, failed attempts, MFA triggers)
- Authorization failures (access denied)
- Input validation failures
- Admin actions (user ban, role change, config change)
- Account changes (email, password, MFA enrollment)
- API errors (5xx, 4xx spikes)
- Rate limiting triggers

**What NOT to log:**
- Passwords, tokens, session IDs, credit card numbers
- Full PII (mask or hash)
- Health data or other regulated content in plaintext

### 9.2 Log Format & Storage
- Use structured logging (JSON) with consistent fields: `timestamp`, `event_type`, `user_id`, `ip`, `resource`, `action`, `result`.
- Centralize logs (ELK Stack, Splunk, Datadog, AWS CloudWatch).
- Set retention policies (min 1 year for security logs; align with compliance).
- Make logs tamper-evident (append-only, integrity checksums, or WORM storage).

### 9.3 Alerting & Monitoring
- Alert on: brute-force attempts, privilege escalation, unusual data access patterns, mass data export, admin login from new geo/IP.
- Use SIEM rules and anomaly detection.
- Monitor application performance for signs of DoS.

### 9.4 Incident Response Plan
1. **Preparation** — Document procedures, designate roles, set up communication channels.
2. **Detection & Analysis** — Correlate alerts, classify severity (P1–P4).
3. **Containment** — Isolate affected systems, revoke compromised credentials.
4. **Eradication** — Remove root cause, patch vulnerabilities.
5. **Recovery** — Restore from clean backups, re-enable services, verify integrity.
6. **Post-Incident** — Blameless postmortem, update runbooks, file compliance notifications.

- Conduct tabletop exercises at least twice a year.
- Maintain a contact list: legal, PR, law enforcement, affected vendors.

---

## 10. Infrastructure & Network Security

### 10.1 Cloud Security
- Enable cloud security posture management (CSPM) tooling.
- Use IAM roles (not long-lived access keys) for service-to-service auth.
- Enable VPC Flow Logs, AWS CloudTrail (or equivalent) — and send to centralized logging.
- Enable MFA on all cloud console accounts; enforce SSO.

### 10.2 Container Security
- Use minimal base images (distroless, Alpine).
- Scan images for vulnerabilities in CI/CD (Trivy, Snyk Container, Grype).
- Run containers as non-root with read-only filesystem where possible.
- Sign and verify container images (cosign, Docker Content Trust).
- Use pod security standards (Kubernetes: `restricted` profile).

### 10.3 Network Segmentation
- Isolate tiers: public-facing → application → database → management.
- Use security groups/NACLs with deny-by-default rules.
- Restrict database access to application subnets only — never expose to the internet.

### 10.4 DDoS Protection
- Use a CDN/WAF (Cloudflare, AWS Shield + WAF, Akamai) in front of public endpoints.
- Implement connection rate limiting at the load balancer.
- Use auto-scaling to absorb traffic spikes.
- Have a DDoS response playbook.

### 10.5 DNS Security
- Enable DNSSEC on your domains.
- Use CAA records to restrict certificate issuance.
- Monitor for domain hijacking and unauthorized DNS changes.

---

## 11. Secure Software Development Lifecycle (SSDLC)

### 11.1 Secure by Design
- Security requirements alongside functional requirements in every user story.
- Threat model every new feature before implementation.

### 11.2 Code Review
- Require peer review for all changes; include security-focused review for sensitive code.
- Use a security review checklist (auth, input validation, access control, crypto usage).
- No self-approvals on code that touches auth, payments, or PII.

### 11.3 Static Analysis (SAST)
- Run SAST tools in CI/CD (Semgrep, SonarQube, CodeQL, Checkmarx).
- Block merges on high/critical findings.
- Tune rules to reduce false positives — unreviewed noise causes alert fatigue.

### 11.4 Dynamic Analysis (DAST)
- Run DAST scans against staging environments (OWASP ZAP, Burp Suite, Nuclei).
- Include authenticated scanning to test post-login flows.

### 11.5 Software Composition Analysis (SCA)
- Scan dependencies for known vulnerabilities (Dependabot, Snyk, Renovate).
- Enforce a policy: no critical/high CVEs in production dependencies.
- Pin dependency versions; use lock files.
- Review new dependencies before adoption (maintenance status, known issues, license).

### 11.6 Secrets in Code
- Pre-commit hooks to block secrets (git-secrets, pre-commit-hooks).
- CI pipeline scanning with truffleHog or Gitleaks.
- If a secret is committed: **rotate immediately** — git history is not a safe remediation.

### 11.7 Penetration Testing
- Conduct annual third-party penetration tests (at minimum).
- Run continuous bug bounty program (HackerOne, Bugcrowd).
- Retest all critical/high findings within 30 days.

---

## 12. Third-Party & Supply Chain Security

### 12.1 Vendor Assessment
- Evaluate vendors for SOC 2 Type II, ISO 27001, or equivalent certifications.
- Review their incident history and breach notification practices.
- Include security clauses in contracts (data handling, breach notification SLAs, right to audit).

### 12.2 Dependency Management
- Prefer well-maintained, widely-used libraries.
- Audit transitive dependencies — vulnerabilities hide deep in the tree.
- Use lockfiles and verify package integrity (checksums, signatures).
- Consider vendoring critical dependencies.

### 12.3 SDK & Plugin Security
- If your platform offers SDKs or plugins, sandbox third-party code.
- Apply permission models (what data/APIs can a plugin access?).
- Review and approve plugins before publishing to your marketplace.

### 12.4 Software Bill of Materials (SBOM)
- Generate SBOMs (SPDX, CycloneDX) for every release.
- Use SBOMs for vulnerability tracking and license compliance.

---

## 13. Content Security & Abuse Prevention

### 13.1 User-Generated Content (UGC)
- Sanitize all UGC before rendering (XSS prevention).
- Implement content moderation (automated + human review).
- Use AI/ML-based content classification for harmful content (hate speech, CSAM, spam).

### 13.2 Spam & Bot Prevention
- Use CAPTCHA (hCaptcha, reCAPTCHA v3, Turnstile) on signup, login, and posting.
- Implement behavioral analysis (mouse movement, typing cadence, request timing).
- Rate-limit account creation per IP/device fingerprint.
- Detect and block coordinated inauthentic behavior.

### 13.3 Account Takeover Prevention
- Detect credential stuffing by monitoring login failure rates and source diversity.
- Notify users on login from new device/location.
- Allow users to review and terminate sessions.
- Implement device fingerprinting and risk-based authentication.

### 13.4 Reporting & Transparency
- Provide easy-to-use reporting mechanisms for abuse.
- Publish transparency reports on content moderation and law enforcement requests.
- Comply with legal take-down obligations (DMCA, EU DSA, etc.).

---

## 14. Compliance & Regulatory

### 14.1 Know Your Regulatory Landscape
| Regulation | Scope | Key Requirements |
|------------|-------|------------------|
| **GDPR** | EU users | Consent, data minimization, right to erasure, DPO, breach notification (72 hrs) |
| **CCPA/CPRA** | California users | Opt-out of sale, right to know/delete, data protection assessments |
| **COPPA** | Users under 13 (US) | Parental consent, data minimization |
| **HIPAA** | Health data (US) | PHI encryption, access controls, BAAs with vendors |
| **PCI DSS** | Payment card data | Tokenize card data, SAQ/ROC, quarterly vulnerability scans |
| **SOC 2** | SaaS providers | Security, availability, confidentiality, processing integrity, privacy |
| **EU DSA** | Digital services (EU) | Content moderation transparency, illegal content reporting |

### 14.2 Privacy by Design
- Build privacy into the architecture — not as an afterthought.
- Conduct Data Protection Impact Assessments (DPIAs) for high-risk processing.
- Implement consent management (granular, revocable, recorded).
- Support right to access, rectification, erasure, and portability.

### 14.3 Age Verification
- If targeting all ages, implement age-gating and parental controls.
- Restrict data collection for minors.
- Comply with COPPA, UK Age Appropriate Design Code, and EU DSA age verification provisions.

---

## 15. Security Checklist Summary

### Pre-Launch
- [ ] Threat model completed for all major features
- [ ] All OWASP Top 10 risks addressed
- [ ] MFA available and enforced for privileged accounts
- [ ] Passwords hashed with Argon2id/bcrypt
- [ ] All data encrypted at rest and in transit (TLS 1.2+)
- [ ] API rate limiting implemented
- [ ] Input validation on all endpoints
- [ ] CSP, HSTS, and security headers deployed
- [ ] SAST/DAST/SCA integrated into CI/CD
- [ ] No secrets in source code (verified by scanning)
- [ ] Penetration test completed; critical/high findings remediated
- [ ] Incident response plan documented and tested
- [ ] Logging and alerting operational
- [ ] Backup and recovery procedures tested
- [ ] Privacy policy and terms of service reviewed by legal
- [ ] Regulatory compliance verified (GDPR, CCPA, etc.)
- [ ] Bug bounty or responsible disclosure program published

### Ongoing
- [ ] Weekly: review security alerts and dependency updates
- [ ] Monthly: review access controls and user privilege reports
- [ ] Quarterly: rotate secrets and review key management
- [ ] Quarterly: restore backups and verify integrity
- [ ] Biannually: tabletop incident response exercises
- [ ] Annually: third-party penetration test
- [ ] Annually: renew compliance certifications
- [ ] Continuously: monitor for new CVEs in your stack

---

## References & Resources

- [OWASP Top 10 (2021)](https://owasp.org/www-project-top-ten/)
- [OWASP Application Security Verification Standard (ASVS)](https://owasp.org/www-project-application-security-verification-standard/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [NIST Cybersecurity Framework (CSF 2.0)](https://www.nist.gov/cyberframework)
- [NIST SP 800-63B: Digital Identity Guidelines](https://pages.nist.gov/800-63-3/sp800-63b.html)
- [CIS Controls v8](https://www.cisecurity.org/controls)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Cloud Security Alliance (CSA) Guidance](https://cloudsecurityalliance.org/)

---

*Document Version: 1.0 | Created: March 2026 | Review Cycle: Every 6 months*
