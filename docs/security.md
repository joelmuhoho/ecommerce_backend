# Security Considerations

Security is a primary concern for the E-Commerce Backend. The application leverages Django's robust built-in security features along with industry best practices for API security.

> [!CAUTION]
> Never commit `.env` files or hardcode secrets (like `SECRET_KEY`, database passwords, or third-party API keys) in the source code.

## 1. Authentication & Authorization

*   **JSON Web Tokens (JWT)**: We use JWTs for stateless authentication.
    *   **Access Tokens**: Short-lived tokens (e.g., 15 minutes) used to access protected endpoints.
    *   **Refresh Tokens**: Longer-lived tokens (e.g., 7 days) used to obtain new access tokens. Refresh tokens are strictly rotated and can be blacklisted upon user logout to prevent reuse.
*   **Password Hashing**: Passwords are never stored in plain text. Django's default PBKDF2 algorithm with a SHA256 hash is used.
*   **Role-Based Access Control (RBAC)**: Endpoints that modify data (POST, PATCH, DELETE) generally require Admin (`is_staff=True`) privileges. Read-only endpoints may be public or require a standard user login depending on the resource.

## 2. Network & Transport Security

*   **HTTPS/TLS**: In production, all traffic must be encrypted over HTTPS. This is enforced at the Nginx/Load Balancer level.
*   **SECURE_SSL_REDIRECT**: Django is configured to redirect all HTTP traffic to HTTPS in the production settings.
*   **CORS (Cross-Origin Resource Sharing)**: `django-cors-headers` should be strictly configured in production to only allow requests from approved frontend domains (e.g., `https://www.yourdomain.com`). Avoid using `CORS_ALLOW_ALL_ORIGINS = True` outside of development.

## 3. Data Protection & Application Security

*   **SQL Injection**: Using Django's ORM inherently protects against most SQL injection attacks by parameterizing queries. Avoid executing raw SQL queries (`Model.objects.raw()`) unless absolutely necessary and heavily sanitized.
*   **Cross-Site Scripting (XSS)**: While primarily an API backend, Django's template engine (used for admin panels and swagger) automatically escapes HTML.
*   **Cross-Site Request Forgery (CSRF)**: For API endpoints accessed via JWT, CSRF is less of a concern since the browser doesn't automatically attach tokens like it does with session cookies. However, session-based views (like the Django Admin) rely on Django's built-in CSRF protection tokens.
*   **Rate Limiting**: (Planned for Phase 4) To prevent brute-force attacks and API abuse, endpoints (especially authentication and search) should be rate-limited using tools like `django-ratelimit` or at the AWS WAF/Load Balancer level.
