# Deploying Wren MCP Server to Render

This guide explains how to deploy the Wren MCP Server to Render.

## Prerequisites

1. A Render account
2. A GitHub repository with your code
3. Access to the Wren Engine instance

## Deployment Steps

### 1. Push Code to GitHub

Make sure your code is pushed to a GitHub repository.

### 2. Connect to Render

1. Go to [render.com](https://render.com) and sign in
2. Click "New +" and select "Web Service"
3. Connect your GitHub repository

### 3. Configure the Service

- **Name**: `wren-mcp-server` (or your preferred name)
- **Environment**: `Docker`
- **Region**: Choose the region closest to your users
- **Branch**: `main` (or your default branch)
- **Build Command**: `docker build -t wren-mcp-server .`
- **Start Command**: Leave empty (Dockerfile handles it)

### 4. Environment Variables

Set these environment variables in Render:

- `WREN_URL`: Your Wren Engine URL
- `CONNECTION_INFO_FILE`: `connection_info.json`
- `MDL_PATH`: `mdl_file.json`
- `RENDER_DEPLOYMENT`: `true`
- `PYTHONPATH`: `/app`
- `PYTHONUNBUFFERED`: `1`

### 5. Deploy

Click "Create Web Service" and wait for the build to complete.

## Configuration Files

- `render.yaml`: Render infrastructure configuration
- `Dockerfile`: Container configuration (in root directory)
- `pyproject.toml`: Python dependencies (in mcp-server/)
- `.dockerignore`: Docker build optimization

## Health Check

The service includes a health check endpoint at `/health` that Render will use to monitor the service.

## Access

Once deployed, your service will be available at:
`https://your-service-name.onrender.com`

## Troubleshooting

1. **Build Failures**: Check the build logs for dependency issues
2. **Runtime Errors**: Check the service logs for application errors
3. **Health Check Failures**: Verify the Wren Engine connection

## Local Testing

To test locally before deploying:

```bash
cd mcp-server
export RENDER_DEPLOYMENT=true
export PORT=8000
uv run app/wren.py
```

Then visit `http://localhost:8000/health` to test the health endpoint.
