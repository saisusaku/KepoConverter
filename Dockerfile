FROM python:3.10-slim

# Instal FFmpeg dan dependensi sistem yang dibutuhkan
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Tentukan direktori kerja
WORKDIR /app

# Salin file requirements.txt
COPY requirements.txt .

# Instal semua dependensi Python secara global langsung ke sistem
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Salin seluruh sisa file proyek ke dalam container
COPY . .

# Jalankan server menggunakan Gunicorn dengan port dinamis Render
CMD gunicorn --bind 0.0.0.0:$PORT converter:app --workers 1 --threads 2 --timeout 120