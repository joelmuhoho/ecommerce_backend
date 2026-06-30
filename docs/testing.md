# Testing Guide

This project maintains a robust testing suite using `pytest`. Testing is divided into unit/integration tests for the backend logic and End-to-End (E2E) browser tests for user-facing documentation and views.

## Running Tests

You can run the tests using `pytest`. Ensure you are in your activated virtual environment.

```bash
# Run all backend tests (excluding E2E)
pytest

# Run tests with coverage reporting
pytest --cov=apps --cov=core

# Run a specific test file
pytest apps/users/tests/test_user_auth.py

# Run with verbose output
pytest -v

# Run tests in parallel (faster)
pytest -n auto
```

## Backend Test Configuration

The project uses `pytest` with comprehensive configuration in `pytest.ini`:

- **Coverage**: Automatically tracks code coverage for `apps/` and `core/`
- **Django Integration**: Full Django test database and settings support via `pytest-django`
- **Fixtures**: Shared fixtures in `conftest.py` for users, products, categories
- **Environment**: Tests run with the `ENVIRONMENT=testing` setting to ensure a clean, isolated database.

### Available Test Fixtures
These are defined in `conftest.py` and can be injected into any test:
- `api_client`: Unauthenticated test client
- `default_user`: Regular user instance
- `admin_user`: Admin user instance
- `authenticated_client_and_user`: Client + user tuple
- `category_factory`: Factory for creating categories
- `product_factory`: Factory for creating products

## End-to-End Browser Tests (Playwright)

This project uses Playwright + pytest for resilient, accessibility-aware end-to-end (E2E) tests that exercise the rendered HTML (landing page, Swagger UI, ReDoc).

> [!NOTE]
> Tests live in `tests/e2e/` and are marked with `@pytest.mark.e2e`. By default, they are excluded from standard `pytest` runs via `pytest.ini`.

### Installation (Once)

Before running E2E tests for the first time, install the required browser engines:
```bash
uv run playwright install  # installs Chromium by default
```

### Running E2E Tests

```bash
# Only run E2E tests (headless)
uv run pytest -m e2e

# Run in headed mode (opens a visible browser window for debugging)
uv run pytest -m e2e --headed

# Run a specific E2E test
uv run pytest -m e2e tests/e2e/test_landing_page.py::test_swagger_ui_loads
```

### E2E Testing Best Practices

1.  **Locators**: Use role/text/label-based locators (`get_by_role`, `get_by_text`) instead of brittle CSS/xpaths. This improves test resilience to UI changes.
2.  **Waits**: Avoid arbitrary `sleep()`. Rely on Playwright's auto-waits + `wait_for_load_state("networkidle")` for dynamic pages like Swagger/ReDoc.
3.  **Assertions**: Prefer semantic assertions (`to_have_title`, `to_have_url`, `to_have_text`).
