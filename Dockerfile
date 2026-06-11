FROM python:3.10-slim

WORKDIR /app

# Install system C-libraries needed by spatial and image processing Python packages
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Ensure we have the latest pip
RUN pip install --upgrade pip

# Copy ONLY the requirements file first (this helps with caching)
COPY requirements.txt .

# Force a clean install of everything in the text file
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code
COPY . .

# Start the application 
CMD uvicorn api:app --host 0.0.0.0 --port ${PORT:-8080}
