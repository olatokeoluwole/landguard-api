# 1. Use a standard, lightweight Python image
FROM python:3.10-slim

# 2. Install the necessary system dependencies for GeoPandas, Rasterio, and Folium
RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# 3. Set environment variables so Python knows where GDAL is
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# 4. Set the working directory
WORKDIR /app

# 5. Copy your requirements file first
COPY requirements.txt .

# 6. Upgrade pip and install your Python packages
# (Using --no-cache-dir keeps the image smaller and prevents memory crashes during build)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 7. Copy the rest of your application code
COPY . .

# 8. Start the FastAPI application using the port Google Cloud Run assigns
CMD exec uvicorn app:app --host 0.0.0.0 --port ${PORT:-8080}
