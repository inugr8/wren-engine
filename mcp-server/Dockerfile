FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install uv and dependencies
RUN pip install uv
RUN uv sync --frozen

# Copy application code
COPY app/ ./app/
COPY mdl_file.json .
COPY mdl.schema.json .
COPY connection_info.json .

# Create a startup script
RUN echo '#!/bin/bash\nuv run app/wren.py' > start.sh && chmod +x start.sh

# Expose port
EXPOSE 8000

# Set environment variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV RENDER_DEPLOYMENT=true

# Run the application
CMD ["./start.sh"]
