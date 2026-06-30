FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    nginx \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install Python dependencies
COPY pyproject.toml uv.lock ./
# uv sync creates a virtual environment at .venv by default
RUN uv sync --frozen --no-install-project
# Explicitly install gunicorn as it's required for the CMD but missing from pyproject.toml
RUN uv pip install gunicorn

# Copy project files
COPY . .

# Set environment variable for production
ENV ENVIRONMENT=production
# Add virtual environment to PATH
ENV PATH="/app/.venv/bin:$PATH"

# Copy Nginx configuration
COPY nginx/nginx.conf /etc/nginx/sites-available/app
COPY nginx/proxy_params /etc/nginx/proxy_params

# Create symlink to enable the site
RUN ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/

# Remove default Nginx configuration
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default

# Start Nginx and Gunicorn
CMD ["sh", "-c", "service nginx start && gunicorn core.wsgi:application --bind 0.0.0.0:8000"]