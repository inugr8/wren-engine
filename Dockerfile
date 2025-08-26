FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files from mcp-server directory
COPY mcp-server/pyproject.toml mcp-server/uv.lock ./

# Install uv and dependencies
RUN pip install uv
RUN uv sync --frozen

# Copy application code from mcp-server directory
COPY mcp-server/app/ ./app/
COPY mcp-server/mdl_file.json .
COPY mcp-server/mdl.schema.json .
COPY mcp-server/connection_info.json .

# Create a simple test endpoint that doesn't require external files
RUN echo 'from fastapi import FastAPI\napp = FastAPI()\n@app.get("/test")\nasync def test():\n    return {"message": "Docker build successful"}' > test_app.py

# Create a startup script
RUN echo '#!/bin/bash\nuv run app/wren.py' > start.sh && chmod +x start.sh

# Expose port
EXPOSE 8000

# Set environment variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV RENDER_DEPLOYMENT=true
ENV PORT=8000

# Run the application
CMD ["./start.sh"]
