# Project 5: S3 Enterprise Storage, Security and Data Analytics

## 🎯 Objective

The first step establishes the storage foundation for the project by creating multiple Amazon S3 buckets, each designed for a specific enterprise use case such as website hosting, secure data storage, disaster recovery, encryption, compliance, and logging.
 
 Here is the plan What we're building:

Static Website
↓
S3 + CloudFront (CDN + HTTPS)
↓
S3 Security Layer
(Bucket Policies, ACLs, Public Access Block)
↓
S3 Lifecycle Management
(Standard → IA → Glacier)
↓
Cross-Region Replication (CRR)
(Mumbai → Singapore)
↓
S3 Event Notifications
(S3 → Lambda → Processing)
↓
Advanced Encryption
(SSE-S3, SSE-KMS, SSE-C, Client-Side)
↓
Object Lock (WORM Compliance)
↓
S3 Batch Operations
↓
S3 Analytics
(Select, Storage Lens, Intelligent-Tiering)
---
> Insert screenshot showing all created buckets.

```text
images/architecture/architecture diagram.png
```

---

## 🛠️ Implementation

Steps we will follow:
●​ Step 1 — Create S3 Buckets
●​ Step 2 — Static Website Hosting with CloudFront
●​ Step 3 — Bucket Policies and Access Control
●​ Step 4 — Lifecycle Management and Storage Classes
●​ Step 5 — Cross-Region Replication (CRR)
●​ Step 6 — S3 Event Notifications with Lambda
●​ Step 7 — Advanced Encryption (SSE-S3, SSE-KMS, SSE-C)
●​ Step 8 — Object Lock (WORM)
●​ Step 9 — S3 Batch Operations
●​ Step 10 — S3 Analytics (Select, Storage Lens, Intelligent-Tiering)

---

## 📸 Screenshots

## steps 1: Create S3 Buckets
We need multiple S3 buckets for different purposes — each with different configurations. Each bucket serves a different purpose with different security, replication, and lifecycle requirements. Mixing everything in one bucket makes management complex.

1. project5-website-258927109117 - Static website hosting
2. project5-data-258927109117 - Main data storage
3. project5-replication-258927109117 - CRR destination (Singapore)
4. project5-encrypted-258927109117 - Advanced encryption practice
5. project5-compliance-258927109117 - Object Lock WORM storage
6. project5-logs-258927109117 - S3 access log

## Step 2: Static Website Hosting with CloudFront
S3 can serve HTML, CSS, JavaScript files directly as a website without any web server. Perfect for portfolios, landing pages, documentation sites.

### Without CloudFront
1. All requests hit S3 in us-east-1
2. Slow for users in India, Europe, Asia
3. S3 URL only (http)
4. Pay for every S3 request
5. No DDoS protection

### With CloudFront
1. Requests served from nearest edge location
2. Fast everywhere in the world
3. Custom domain + HTTPS
4. CloudFront caches fewer S3 requests
5. AWS Shield Standard built-in

> Insert screenshot showing all created buckets.

```text
images/website/cloudFront webpage.png
```

---

## Step 3 — Bucket Policies and Access Control
JSON documents attached to S3 bucket defining who can do what with the bucket and its objects. Resource-based policy — attached to the resource, not the user.

What is Public Access Block: 4 settings that override bucket policies and ACLs to
prevent any public access. Acts as an extra safety net.

Why Public Access Block exists: Many S3 data breaches happened because
developers accidentally made buckets public. AWS added this as an account-level
and bucket-level override.
---

## ✅ Verification

Successfully verified:

- Six Amazon S3 buckets created.
- Versioning enabled where required.
- Encryption configured successfully.
- Object Lock enabled for compliance bucket.
- Server Access Logging enabled.
- Replication destination bucket created in a different AWS Region.

---

## 💡 Key Learning

This step demonstrates how enterprise environments separate workloads into dedicated Amazon S3 buckets rather than storing everything in a single bucket. Proper bucket design improves security, simplifies management, enables compliance, and supports disaster recovery strategies.

---