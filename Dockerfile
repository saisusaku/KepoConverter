FROM python:3.10-slim

# Instal FFmpeg dan dependensi sistem yang dibutuhkan
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Tentukan direktori kerja di dalam container
WORKDIR /app

# Salin file requirements dan instal pustaka Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Salin seluruh file proyek ke dalam container
COPY . .

# Port default yang dibaca Render
ENV PORT=5000

# Jalankan aplikasi menggunakan Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "converter:app", "--timeout", "120"]