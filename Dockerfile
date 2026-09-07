FROM python:3.10-slim

# Instal FFmpeg dan dependensi sistem
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Upgrade pip agar proses instalasi lebih stabil
RUN pip install --no-cache-dir --upgrade pip

# Salin requirements.txt dan instal semua dependensi Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Salin sisa file aplikasi ke dalam container
COPY . .

# Jalankan aplikasi dengan port dinamis dari Render
CMD gunicorn --bind 0.0.0.0:$PORT converter:app --workers 1 --threads 2 --timeout 120