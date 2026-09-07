FROM python:3.10-slim

# Instal FFmpeg dan dependensi sistem
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Menggunakan port dinamis dari Render ($PORT) alih-alih hardcode 5000
CMD gunicorn --bind 0.0.0.0:$PORT converter:app --workers 1 --threads 2 --timeout 120