FROM python:3.10-slim

# Instal FFmpeg dan dependensi sistem dasar
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Salin requirements.txt lalu instal semua dependensi termasuk gunicorn
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn

# Salin sisa file proyek ke dalam container
COPY . .

# Jalankan server menggunakan Gunicorn dengan port dinamis dari Render
CMD gunicorn --bind 0.0.0.0:$PORT converter:app --workers 1 --threads 2 --timeout 120