# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies needed for geospatial python libraries
RUN apt-get update && apt-get install -y \
    build-essential \
    libgdal-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Set default port for Cloud Run
ENV PORT=8080

# Command to run the application (matching what you used on Render)
CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port $PORT"]
