# Landerox Cloud Infra

[![Terraform](https://github.com/landerox/cloud-landerox-infra/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/landerox/cloud-landerox-infra/actions/workflows/terraform.yml) [![Terraform Version](https://img.shields.io/badge/terraform-v1.10.x-623ce4.svg?logo=terraform)](https://www.terraform.io/) [![GCP](https://img.shields.io/badge/GCP-Ready-4285F4?logo=google-cloud&logoColor=white)](https://cloud.google.com/)

**Landerox Cloud Infra** is a modular, multi-purpose Infrastructure as Code (IaC) framework designed to orchestrate high-performance experiments in **Data Engineering, Generative AI (RAG), and Real-time Analytics** on Google Cloud Platform.

## Overview

This repository acts as a Cloud Innovation Lab, providing a production-grade foundation for deploying and testing diverse technical initiatives. It leverages a strictly modular architecture to ensure that new PoCs (Proof of Concepts) can be integrated, scaled, or decommissioned with minimal friction.

### Current Capabilities

* **Real-time Ingestion:** High-frequency data pipelines for stochastic event analysis.
* **Lakehouse Architecture:** Fully automated Medallion (Raw/Silver/Gold) structure in BigQuery.
* **Serverless Orchestration:** Event-driven execution using Cloud Functions and Cloud Run.
* **Ready for AI:** Infrastructure prepared for RAG (Retrieval-Augmented Generation) and Vector Search deployments.

## Documentation

* **[Getting Started](docs/development.md#getting-started):** Local setup and prerequisites.
* **[Architecture](docs/architecture.md):** Project structure and module design.
* **[CI/CD](docs/cicd.md):** Deployment pipelines and authentication.
* **[Governance](docs/governance.md):** Labels and security standards.

## Quick Start (Local)

All standard operations are encapsulated via `just`. Run these from the `terraform/` directory:

```bash
cd terraform

# Format and Validate
just fmt
just validate

# Plan changes
just plan
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

See [LICENSE](LICENSE) in the root directory.
