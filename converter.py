from flask import Flask, render_template, request, send_file, jsonify
import os
from moviepy.editor import VideoFileClip

# Mengatur template_folder ke direktori saat ini (root)
app = Flask(__name__, template_folder='.')

UPLOAD_FOLDER = 'uploads'
OUTPUT_FOLDER = 'outputs'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

@app.route('/')
def index():
    return render_template('converter.html')

@app.route('/convert', methods=['POST'])
def convert_media():
    if 'file' not in request.files:
        return jsonify({'status': 'error', 'message': 'Tidak ada file yang diunggah.'})
    
    file = request.files['file']
    target_format = request.form.get('format', 'mp3')
    
    if file.filename == '':
        return jsonify({'status': 'error', 'message': 'Nama file kosong.'})

    try:
        input_path = os.path.join(UPLOAD_FOLDER, file.filename)
        file.save(input_path)
        
        output_filename = os.path.splitext(file.filename)[0] + f'.{target_format}'
        output_path = os.path.join(OUTPUT_FOLDER, output_filename)
        
        # Proses ekstraksi/konversi menggunakan MoviePy (membutuhkan FFmpeg di sistem)
        video_clip = VideoFileClip(input_path)
        audio_clip = video_clip.audio
        
        if target_format in ['mp3', 'wav']:
            audio_clip.write_audiofile(output_path)
            
        audio_clip.close()
        video_clip.close()
        
        return jsonify({'status': 'success', 'download_url': f'/download/{output_filename}', 'filename': output_filename})

    except Exception as e:
        return jsonify({'status': 'error', 'message': f'Gagal mengonversi: {str(e)}'})

@app.route('/download/<filename>')
def download_file(filename):
    return send_file(os.path.join(OUTPUT_FOLDER, filename), as_attachment=True)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)