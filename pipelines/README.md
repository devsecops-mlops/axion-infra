# CI/CD Pipelines & Branch Protection Guide

This directory contains configuration files and guidelines for the CI/CD pipeline powering the **Axion Infrastructure** repository.

---

## 1. Pipeline Architecture

```
[ Developer Branch ]
         │
         ▼ (Create PR targeting main)
┌─────────────────────────────────────────────────────────────┐
│                 Feature / PR Pipeline                       │
│  .github/workflows/feature-pipeline.yml                     │
├─────────────────────────────────────────────────────────────┤
│  Stage 1: Lint & Quality (terraform fmt + tflint)           │
│  Stage 2: Security Scan (Checkov compliance audit)          │
│  Stage 3: Terraform Validate & Speculative Plan             │
│  Stage 4: Post Plan Summary comment to PR                   │
└─────────────────────────────────────────────────────────────┘
         │
         ▼ (PR Approved & Merged to Protected 'main')
┌─────────────────────────────────────────────────────────────┐
│                 Main Branch Deploy Pipeline                 │
│  .github/workflows/deploy-pipeline.yml                      │
├─────────────────────────────────────────────────────────────┤
│  Stage 1: Quality & Security Gate                           │
│  Stage 2: Terraform Plan Generation & Artifact Archival     │
│  Stage 3: Controlled Terraform Apply (Environment: dev)     │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Tools Configured

| Tool | Purpose | Configuration File |
|---|---|---|
| **terraform fmt** | Ensures consistent HCL syntax styling | Standard HashiCorp formatting rules |
| **tflint** | Static code analysis, naming conventions, and Azure rules | `.tflint.hcl` & `pipelines/.tflint.hcl` |
| **checkov** | Infrastructure-as-code (IaC) security and compliance scanner | `.checkov.yaml` & `pipelines/.checkov.yaml` |
| **Azure OIDC** | Passwordless authentication for GitHub Actions | `azure/login@v2` with Federated Identity |

---

## 3. GitHub Secrets Configuration

Add the following secrets under **Repository Settings > Secrets and variables > Actions**:

| Secret Name | Description | Example |
|---|---|---|
| `AZURE_CLIENT_ID` | Application (client) ID of Azure AD App Registration | `00000000-0000-0000-0000-000000000000` |
| `AZURE_TENANT_ID` | Directory (tenant) ID | `6ede57ae-c580-4902-8951-da3d4473b758` |
| `AZURE_SUBSCRIPTION_ID` | Azure Subscription ID | `1f196f8e-ab8f-4746-a1f5-1798c2228e8f` |

---

## 4. Azure OIDC Federated Credential Setup

To allow GitHub Actions to authenticate without static client secrets:

1. In the **Azure Portal**, go to **Microsoft Entra ID > App registrations > Your App**.
2. Navigate to **Certificates & secrets > Federated credentials > Add credential**.
3. Select **GitHub Actions deploying Azure resources**.
4. Configure two federated credentials:
   - **For Pull Requests**:
     - Entity type: `Pull request`
   - **For Main Branch**:
     - Entity type: `Branch`
     - Branch name: `main`

---

## 5. Main Branch Protection Configuration

To protect the `main` branch:

1. In GitHub, go to **Settings > Branches > Add branch protection rule**.
2. Set **Branch name pattern** to `main`.
3. Enable:
   - ✅ **Require a pull request before merging**
     - Require approvals (e.g. 1 reviewer)
     - Dismiss stale pull request approvals when new commits are pushed
   - ✅ **Require status checks to pass before merging**
     - Select the status checks:
       - `Stage 1: Lint & Code Quality`
       - `Stage 2: Security Scan (Checkov)`
       - `Stage 3: Terraform Validate & Plan`
   - ✅ **Require conversation resolution before merging**
   - ✅ **Do not allow bypassing the above settings**
