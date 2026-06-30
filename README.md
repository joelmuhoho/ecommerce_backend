# E-Commerce Backend (Django + DRF)

A modern, scalable backend service for an e-commerce platform built with Django and Django REST Framework.

[![Python](https://img.shields.io/badge/python-3.10+-blue.svg)](https://python.org)
[![Django](https://img.shields.io/badge/django-5.2+-green.svg)](https://djangoproject.com)
[![DRF](https://img.shields.io/badge/DRF-3.16+-orange.svg)](https://django-rest-framework.org)
[![PostgreSQL](https://img.shields.io/badge/postgresql-15+-blue.svg)](https://postgresql.org)

---

## Problem Statement

Building an e-commerce platform requires a backend that can handle complex user management, a dynamic product catalog, secure transactions, and high traffic volumes. Monolithic or poorly structured backends quickly become difficult to maintain, struggle to scale, and suffer from performance bottlenecks when searching large catalogs or processing concurrent requests.

## Solution

This project provides a comprehensive, production-ready backend foundation. It solves the e-commerce infrastructure problem by implementing a clean, modular architecture separating `users` and `catalog` domains. It utilizes robust technologies like PostgreSQL for reliable data storage, Django REST Framework for rapid API development, and secure JWT authentication. The entire stack is containerized with Docker to ensure parity across development, staging, and production environments, making it ready for scalable cloud deployment.

---

## Key Features

- **Modular Architecture**: Clean separation with `apps/users` and `apps/catalog` domains.
- **JWT Authentication**: Secure token-based authentication with refresh/blacklist capabilities.
- **Advanced API Features**: Filtering, sorting, pagination, and search functionality built-in.
- **Comprehensive Testing**: Pytest suite with coverage reporting and Playwright E2E tests.
- **API Documentation**: Auto-generated Swagger/OpenAPI interactive documentation.
- **Production Ready**: Multi-stage Docker deployment optimized for scalable hosting.

---

## Technologies Used

- **Core**: Python 3.10+, Django 5.2+, Django REST Framework 3.16+
- **Database**: PostgreSQL 15+ (Production), SQLite (Development)
- **Authentication**: `djangorestframework-simplejwt`
- **Testing**: `pytest`, `pytest-django`, `playwright`
- **Deployment & DevOps**: Docker, Docker Compose, Nginx, Gunicorn, GitHub Actions

---

## Architecture Overview

The system is designed as a stateless API serving JSON responses to clients, backed by a relational database.

- **[Application Flow](docs/architecture/application_flow.md)**: Details the request lifecycle from Client to Database.
- **[Database Relationships](docs/architecture/database_relationships.md)**: Visual ERD of the core data models.
- **[AWS Infrastructure](docs/architecture/aws_infrastructure.md)**: Proposed cloud architecture for high availability.
- **[Deployment Architecture](docs/architecture/deployment.md)**: Current Docker Compose setup.

---

## Setup Instructions

### Option 1: Docker Compose (Recommended)

1. **Clone the repository**
   ```bash
   git clone git@github.com:joekariuki3/ecommerce_backend.git
   cd ecommerce_backend
   ```
2. **Set up environment**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration if necessary
   ```
3. **Launch the stack**
   ```bash
   docker-compose up -d
   ```
4. **Access the application**
   - API: `http://localhost`
   - Swagger Documentation: `http://localhost/swagger/`

### Option 2: Local Development (Using uv - Recommended)

[uv](https://github.com/astral-sh/uv) is an extremely fast Python project manager. It automatically handles virtual environments and resolves all dependencies from the `pyproject.toml` file.

1. **Clone the repository**
   ```bash
   git clone https://github.com/joelmuhoho/ecommerce_backend.git
   cd ecommerce_backend
   ```
2. **Install dependencies and create environment**
   ```bash
   uv sync
   ```
3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
4. **Run migrations and (optional) seed DB**
   ```bash
   uv run python manage.py migrate
   uv run python manage.py seed_users_db
   uv run python manage.py seed_category_product_db
   ```
5. **Start the server**
   ```bash
   uv run python manage.py runserver
   ```

### Option 3: Local Development (Standard Python Virtual Env)

If you prefer standard Python tools, you can use `venv` and `pip` with the generated `requirements.txt`.

1. **Clone the repository**
   ```bash
   git clone https://github.com/joelmuhoho/ecommerce_backend.git
   cd ecommerce_backend
   ```
2. **Create and activate virtual environment**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```
3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```
4. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
5. **Run migrations and (optional) seed DB**
   ```bash
   python manage.py migrate
   python manage.py seed_users_db
   python manage.py seed_category_product_db
   ```
6. **Start the server**
   ```bash
   python manage.py runserver
   ```

---

## Lessons Learned

During the development of this robust backend architecture, several key technical insights were gained:

1. **Explicit is better than implicit for settings**: Managing multiple environments (`development.py`, `production.py`) inheriting from a `base.py` is significantly cleaner and less error-prone than using massive `if/else` blocks in a single settings file based on environment variables.
2. **Stateless Auth unlocks scaling**: Implementing JWTs early prevents the headache of sticky sessions or shared session databases (like Redis) when scaling web containers horizontally. However, it requires careful handling of token blacklisting on logout.
3. **E2E Testing for Docs ensures reliability**: Adding Playwright to test the auto-generated Swagger UI proved invaluable. Code changes can sometimes silently break the OpenAPI schema generation, and these tests catch those visual breaks before deployment.
4. **Fat Models, Thin Views**: Pushing business logic into model methods or dedicated service layers, rather than cluttering DRF Views/ViewSets, makes testing significantly easier and keeps the API layer focused strictly on HTTP concerns.

---

## Detailed Documentation

For deep dives into specific areas of the project, please refer to the `docs/` directory:

### Architecture & Operations
*   [Hosting and CI/CD Pipeline](docs/hosting_and_cicd.md)
*   [Security Considerations](docs/security.md)
*   [Scalability Strategy](docs/scalability.md)

### Developer Guides
*   [API Reference & Endpoints](docs/api_reference.md)
*   [Testing Guide (Unit & E2E)](docs/testing.md)
*   [Technical Reference](docs/ref_doc.md)
*   [Development Wiki](docs/wiki_doc.md)

---

## License & Support

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
For support or issues, please use [GitHub Issues](https://github.com/joekariuki3/ecommerce_backend/issues).
