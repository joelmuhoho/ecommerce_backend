# API Reference

This document provides a detailed reference for the REST APIs available in the E-Commerce Backend.

## Interactive Documentation

The project automatically generates OpenAPI/Swagger documentation. Once the server is running, you can access the interactive API explorers:

*   **Swagger UI**: `http://localhost:8000/swagger/` (development) or `http://localhost/swagger/` (production)
*   **ReDoc**: `http://localhost:8000/redoc/` (development) or `http://localhost/redoc/` (production)

> [!TIP]
> Use the Swagger UI for testing endpoints directly from your browser. Use ReDoc for sharing clean, read-only documentation with frontend teams.

## Authentication

The API uses JSON Web Tokens (JWT) for authentication. Most endpoints (except registration and login) require a valid access token in the `Authorization` header:

```http
Authorization: Bearer <your_access_token>
```

### Authentication & User Management Endpoints

| Endpoint                   | Method           | Purpose                          | Authentication |
| -------------------------- | ---------------- | -------------------------------- | -------------- |
| `/api/users/register/`     | POST             | Create new user account          | None           |
| `/api/auth/login/`         | POST             | Obtain JWT access/refresh tokens | None           |
| `/api/auth/logout/`        | POST             | Blacklist refresh token          | Bearer Token   |
| `/api/auth/token/refresh/` | POST             | Refresh access token             | None           |
| `/api/auth/token/verify/`  | POST             | Verify token validity            | None           |
| `/api/users/`              | GET              | List users (admin only)          | Bearer Token   |
| `/api/users/{id}/`         | GET/PATCH/DELETE | User profile management          | Bearer Token   |

## Product Catalog

### Catalog Endpoints

| Endpoint                        | Method       | Purpose                             | Authentication |
| ------------------------------- | ------------ | ----------------------------------- | -------------- |
| `/api/catalog/categories/`      | GET          | List all categories                 | None           |
| `/api/catalog/categories/`      | POST         | Create category (admin only)        | Bearer Token   |
| `/api/catalog/categories/{id}/` | GET          | Category details                    | None           |
| `/api/catalog/categories/{id}/` | PATCH/DELETE | Update/delete category (admin only) | Bearer Token   |
| `/api/catalog/products/`        | GET          | List products with filtering/search | None           |
| `/api/catalog/products/`        | POST         | Create product (admin only)         | Bearer Token   |
| `/api/catalog/products/{id}/`   | GET          | Product details                     | None           |
| `/api/catalog/products/{id}/`   | PATCH/DELETE | Update/delete product (admin only)  | Bearer Token   |

### Query Parameters for Product Listing

The `/api/catalog/products/` endpoint supports advanced querying:

| Parameter   | Description                             | Example           |
| ----------- | --------------------------------------- | ----------------- |
| `category`  | Filter by category ID                   | `?category__id=1` |
| `search`    | Search in product name/description      | `?search=laptop`  |
| `ordering`  | Sort by field (price, name, created_at) | `?ordering=price` |
| `page`      | Page number for pagination              | `?page=2`         |
| `page_size` | Items per page                          | `?page_size=20`   |

## Example API Calls

**1. Register a new user:**
```bash
curl -X POST http://localhost:8000/api/users/register/ \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "secure123", "first_name": "John", "last_name": "Doe"}'
```

**2. Login to get tokens:**
```bash
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "secure123"}'
```

**3. Search products (No auth required):**
```bash
curl "http://localhost:8000/api/catalog/products/?search=laptop&ordering=price"
```

**4. Create a product (Admin Auth Required):**
```bash
curl -X POST http://localhost:8000/api/catalog/products/ \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"name": "New Laptop", "price": 999.99, "category_id": "<category_uuid>"}'
```
