# Hosting and CI/CD

## Hosting Platform: AWS (Amazon Web Services)

This application is designed to be deployed on AWS for a highly scalable, production-ready environment.

### Target Architecture

As detailed in the [AWS Infrastructure Diagram](architecture/aws_infrastructure.md), the target deployment utilizes:
-   **Amazon ECS (Elastic Container Service) with AWS Fargate**: Serverless compute for our Docker containers. This removes the need to manage EC2 instances directly.
-   **Amazon RDS (Relational Database Service)**: A managed PostgreSQL instance for our database needs, providing automated backups and Multi-AZ high availability.
-   **Application Load Balancer (ALB)**: Routes incoming HTTP/HTTPS traffic to the Fargate containers.
-   **Amazon S3 & CloudFront**: Used for storing and globally distributing static files (CSS, JS) and user-uploaded media.

### Deployment Process (Docker)

The application is containerized. For initial setups or smaller scale deployments, you can use the provided `docker-compose.yml` on a single EC2 instance. However, for true production scale on AWS, the Docker images should be pushed to Amazon ECR (Elastic Container Registry) or GitHub Container Registry, and then deployed to ECS.

---

## Continuous Integration / Continuous Deployment (CI/CD)

The project leverages **GitHub Actions** for automated CI/CD pipelines, ensuring code quality and streamlining deployments. The workflow definitions are located in the `.github/workflows/` directory.

### Continuous Integration (`ci.yml`)

Triggered on every Pull Request to `main` or `develop`, and on pushes to `main`.
*   **Linting & Formatting**: Checks code style using standard Python linters (e.g., flake8, black).
*   **Testing**: Spins up a PostgreSQL service container and runs the entire `pytest` suite.
*   **Coverage**: Ensures test coverage meets minimum requirements before allowing a merge.

### Continuous Deployment (`cd.yml`)

Triggered upon successful merges to the `main` branch.
*   **Build**: Builds the production Docker image using the `Dockerfile`.
*   **Publish**: Pushes the new Docker image to the GitHub Container Registry (`ghcr.io`).
*   **Deploy**: (Future configuration) This step will trigger a rollout in AWS ECS, pulling the latest image from the registry and gracefully restarting the Fargate tasks.

### PR Enforcement (`enforce-pr-source.yml`)

A security and workflow policy workflow that ensures code is only merged into protected branches via approved Pull Requests, preventing direct pushes to `main`.
