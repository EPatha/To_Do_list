/**
 * Voice Recognition untuk Laravel To-Do List
 * Versi yang diperbaiki dengan error handling yang lebih baik
 */

class VoiceRecognition {
    constructor() {
        // Cek browser support
        if (!('SpeechRecognition' in window || 'webkitSpeechRecognition' in window)) {
            this.showMessage('Browser tidak mendukung voice recognition. Gunakan Chrome atau Edge terbaru.', 'error');
            return;
        }
        
        try {
            this.recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)();
            this.isListening = false;
            this.shouldRestart = false;
            this.restartCount = 0;
            this.maxRestartAttempts = 3;
            this.lastCommand = '';
            this.hasError = false; // Flag untuk track error
            this.setupRecognition();
            this.showMessage('Voice recognition siap digunakan', 'success');
        } catch (e) {
            console.error('Error initializing speech recognition:', e);
            this.showMessage('Gagal menginisialisasi voice recognition: ' + e.message, 'error');
        }
    }

    setupRecognition() {
        // Konfigurasi dengan timeout yang lebih panjang
        this.recognition.continuous = true;  // TRUE = continuous mode untuk tidak mati cepat
        this.recognition.interimResults = true; // TRUE = lihat hasil sementara
        this.recognition.lang = 'id-ID';
        this.recognition.maxAlternatives = 1;

        this.recognition.onstart = () => {
            console.log('Voice recognition started (continuous mode)');
            const button = document.getElementById('voiceButton');
            const status = document.getElementById('voiceStatus');
            if (button) {
                button.classList.add('listening');
                button.disabled = false;
                button.textContent = '🛑 Stop Listening';
            }
            if (status) status.textContent = 'Mendengarkan... Silakan bicara (akan mendengar hingga Anda klik stop)';
        };

        this.recognition.onend = () => {
            console.log('Voice recognition ended');
            
            // JANGAN update UI di sini jika masih ingin listening
            // Biarkan onstart yang handle UI update
            
            // HANYA restart jika user masih ingin listening dan tidak ada error
            if (this.isListening && !this.hasError) {
                console.log('Auto-restarting voice recognition to keep listening...');
                setTimeout(() => {
                    if (this.isListening && !this.hasError) {
                        try {
                            this.recognition.start();
                        } catch (e) {
                            console.error('Failed to restart:', e);
                            this.stopListening();
                        }
                    }
                }, 100);
            } else {
                // Hanya update UI jika benar-benar berhenti
                console.log('Voice recognition stopped - updating UI');
                const button = document.getElementById('voiceButton');
                const status = document.getElementById('voiceStatus');
                
                if (button) {
                    button.classList.remove('listening');
                    button.disabled = false;
                    button.textContent = '🎤 Voice Control';
                }
                if (status) {
                    status.style.color = '#6b7280';
                    status.textContent = 'Klik untuk berbicara';
                }
                
                this.isListening = false;
                this.shouldRestart = false;
            }
        };

        this.recognition.onresult = (event) => {
            try {
                // Ambil hasil terbaru
                for (let i = event.resultIndex; i < event.results.length; i++) {
                    const result = event.results[i];
                    const transcript = result[0].transcript.trim();
                    const confidence = result[0].confidence;
                    
                    if (result.isFinal) {
                        console.log('Final result:', transcript, 'Confidence:', confidence || 'unknown');
                        
                        // Proses command final
                        if (transcript.length > 0) {
                            this.processCommand(transcript.toLowerCase());
                            // TIDAK stop otomatis - biarkan user yang stop manual
                        }
                    } else {
                        // Tampilkan hasil sementara
                        const status = document.getElementById('voiceStatus');
                        if (status && transcript.length > 0) {
                            status.textContent = `Mendengar: "${transcript}"... (lanjutkan bicara atau klik stop)`;
                        }
                    }
                }
                
            } catch (e) {
                console.error('Error processing voice result:', e);
                this.showMessage('Error memproses perintah suara', 'error');
            }
        };

        this.recognition.onerror = (event) => {
            console.error('Speech recognition error:', event.error);
            this.handleError(event.error, 'Error: ' + event.error);
        };
    }

    handleError(errorType, message) {
        console.log('Handling error:', errorType, message);
        this.hasError = true; // Set error flag
        
        const errorMessages = {
            'network': 'Koneksi internet bermasalah. Cek koneksi Anda.',
            'not-allowed': 'Akses mikrofon ditolak. Izinkan akses mikrofon di browser.',
            'no-speech': 'Tidak ada suara terdeteksi. Masih mendengarkan...',
            'audio-capture': 'Mikrofon tidak dapat diakses. Cek perangkat audio.',
            'service-not-allowed': 'Layanan voice recognition tidak tersedia.',
            'language-not-supported': 'Bahasa tidak didukung.',
            'aborted': 'Voice recognition dibatalkan.',
            'restart-failed': 'Gagal restart voice recognition.'
        };

        const userMessage = errorMessages[errorType] || message || 'Terjadi kesalahan voice recognition';
        
        // Untuk error 'no-speech', JANGAN stop listening - biarkan tetap jalan
        if (errorType === 'no-speech') {
            this.showMessage('Tidak mendengar suara. Masih mendengarkan...', 'warning');
            this.hasError = false; // Reset error flag untuk no-speech
            return; // JANGAN panggil stopListening()
        } else {
            this.showMessage(userMessage, 'error');
            // Hanya stop untuk error serius
            const criticalErrors = ['not-allowed', 'audio-capture', 'service-not-allowed'];
            if (criticalErrors.includes(errorType)) {
                this.stopListening();
            }
        }
    }

    processCommand(transcript) {
        console.log('Processing transcript:', transcript);
        
        // Menambah task baru
        if (transcript.includes('tambah') || transcript.includes('add')) {
            const taskTitle = transcript.replace(/tambah|add/gi, '').trim();
            if (taskTitle) {
                this.addTask(taskTitle);
            } else {
                this.showMessage('Silakan sebutkan nama task yang ingin ditambah', 'warning');
            }
        }
        // Menandai task selesai
        else if (transcript.includes('selesai') || transcript.includes('complete')) {
            const taskTitle = transcript.replace(/selesai|complete/gi, '').trim();
            if (taskTitle) {
                this.markTaskAsComplete(taskTitle);
            } else {
                this.showMessage('Silakan sebutkan nama task yang ingin diselesaikan', 'warning');
            }
        }
        // Menghapus task
        else if (transcript.includes('hapus') || transcript.includes('delete')) {
            const taskTitle = transcript.replace(/hapus|delete/gi, '').trim();
            if (taskTitle) {
                this.deleteTask(taskTitle);
            } else {
                this.showMessage('Silakan sebutkan nama task yang ingin dihapus', 'warning');
            }
        }
        // Bersihkan semua task
        else if (transcript.includes('bersihkan semua') || transcript.includes('clear all')) {
            this.clearAllTasks();
        }
        // Show help
        else if (transcript.includes('bantuan') || transcript.includes('help')) {
            this.showHelp();
        }
        // Unknown command
        else {
            this.showMessage(`Perintah "${transcript}" tidak dikenali. Katakan "bantuan" untuk melihat perintah yang tersedia.`, 'warning');
        }
    }

    addTask(taskTitle) {
        try {
            const input = document.getElementById('todoInput');
            const form = document.getElementById('addTodoForm');
            
            if (input && form) {
                input.value = taskTitle;
                form.submit();
                this.showMessage(`Task "${taskTitle}" sedang ditambahkan...`, 'success');
            } else {
                this.showMessage('Form tidak ditemukan', 'error');
            }
        } catch (e) {
            console.error('Error adding task:', e);
            this.showMessage('Gagal menambah task', 'error');
        }
    }

    markTaskAsComplete(taskTitle) {
        try {
            const tasks = document.querySelectorAll('.todo-item');
            let found = false;
            
            tasks.forEach(task => {
                const titleElement = task.querySelector('.todo-title');
                if (titleElement && titleElement.textContent.toLowerCase().includes(taskTitle)) {
                    const checkbox = task.querySelector('input[type="checkbox"]');
                    if (checkbox && !checkbox.checked) {
                        checkbox.click();
                        found = true;
                        this.showMessage(`Task "${titleElement.textContent}" ditandai selesai`, 'success');
                    }
                }
            });
            
            if (!found) {
                this.showMessage(`Task "${taskTitle}" tidak ditemukan atau sudah selesai`, 'warning');
            }
        } catch (e) {
            console.error('Error marking task complete:', e);
            this.showMessage('Gagal menandai task selesai', 'error');
        }
    }

    deleteTask(taskTitle) {
        try {
            const tasks = document.querySelectorAll('.todo-item');
            let found = false;
            
            tasks.forEach(task => {
                const titleElement = task.querySelector('.todo-title');
                if (titleElement && titleElement.textContent.toLowerCase().includes(taskTitle)) {
                    const deleteButton = task.querySelector('.delete-button');
                    if (deleteButton) {
                        deleteButton.click();
                        found = true;
                        this.showMessage(`Task "${titleElement.textContent}" dihapus`, 'success');
                    }
                }
            });
            
            if (!found) {
                this.showMessage(`Task "${taskTitle}" tidak ditemukan`, 'warning');
            }
        } catch (e) {
            console.error('Error deleting task:', e);
            this.showMessage('Gagal menghapus task', 'error');
        }
    }

    clearAllTasks() {
        try {
            const deleteButtons = document.querySelectorAll('.delete-button');
            if (deleteButtons.length > 0) {
                if (confirm('Hapus semua task?')) {
                    deleteButtons.forEach(button => button.click());
                    this.showMessage('Semua task dihapus', 'success');
                }
            } else {
                this.showMessage('Tidak ada task untuk dihapus', 'warning');
            }
        } catch (e) {
            console.error('Error clearing all tasks:', e);
            this.showMessage('Gagal menghapus semua task', 'error');
        }
    }

    showHelp() {
        const helpText = `
Perintah Voice Recognition:

📝 MENAMBAH TASK:
- "Tambah [nama task]"
- "Add [task name]"

✅ MENYELESAIKAN TASK:
- "Selesai [nama task]"
- "Complete [task name]"

🗑️ MENGHAPUS TASK:
- "Hapus [nama task]"
- "Delete [task name]"

🧹 MENGHAPUS SEMUA:
- "Bersihkan semua"
- "Clear all"

❓ BANTUAN:
- "Bantuan"
- "Help"

CONTOH PENGGUNAAN:
- "Tambah belajar JavaScript"
- "Selesai belajar"
- "Hapus JavaScript"

TIPS:
- Bicara dengan jelas
- Tunggu hingga tombol berubah sebelum berbicara
- Gunakan mikrofon yang baik
        `;
        alert(helpText);
    }

    showMessage(message, type = 'info') {
        const status = document.getElementById('voiceStatus');
        if (status) {
            const originalText = status.textContent;
            
            // Apply styling based on message type
            status.className = 'voice-status';
            switch (type) {
                case 'error':
                    status.style.color = '#ef4444';
                    break;
                case 'success':
                    status.style.color = '#10b981';
                    break;
                case 'warning':
                    status.style.color = '#f59e0b';
                    break;
                default:
                    status.style.color = '#6b7280';
            }
            
            status.textContent = message;
            
            // Reset after timeout
            setTimeout(() => {
                status.style.color = '#6b7280';
                status.textContent = this.isListening ? 'Mendengarkan...' : 'Klik untuk berbicara';
            }, 4000);
        }
        
        // Also log to console
        console.log(`[Voice Recognition ${type.toUpperCase()}]:`, message);
    }

    stopListening() {
        this.isListening = false;
        this.shouldRestart = false;
        this.restartCount = 0;
        this.lastCommand = '';
        this.hasError = false; // Reset error flag
        
        try {
            if (this.recognition) {
                this.recognition.stop();
            }
        } catch (e) {
            console.log('Recognition already stopped');
        }
        
        const button = document.getElementById('voiceButton');
        const status = document.getElementById('voiceStatus');
        
        if (button) {
            button.classList.remove('listening');
            button.disabled = false;
            button.textContent = '🎤 Voice Control';
        }
        if (status) {
            status.style.color = '#6b7280';
            status.textContent = 'Klik untuk berbicara';
        }
        
        console.log('Voice recognition stopped completely');
    }

    toggle() {
        if (this.isListening) {
            // Stop listening - user clicked stop
            console.log('User manually stopping voice recognition');
            this.hasError = true; // Prevent auto-restart
            this.isListening = false; // Set to false immediately
            
            try {
                this.recognition.stop();
            } catch (e) {
                console.log('Recognition already stopped');
            }
            
            // Force UI update immediately
            this.stopListening();
        } else {
            // Start listening - continuous mode
            console.log('Starting voice recognition...');
            try {
                // Set state immediately
                this.isListening = true;
                this.shouldRestart = true;
                this.hasError = false;
                
                const button = document.getElementById('voiceButton');
                const status = document.getElementById('voiceStatus');
                
                // Update UI immediately to show starting
                if (button) {
                    button.disabled = true;
                    button.textContent = '⏳ Starting...';
                }
                if (status) {
                    status.textContent = 'Memulai voice recognition...';
                }
                
                // Start recognition immediately without delay
                this.recognition.start();
                
            } catch (e) {
                console.error('Error starting recognition:', e);
                this.handleError('start-failed', 'Gagal memulai voice recognition');
                this.stopListening();
            }
        }
    }
}

// Initialize voice recognition when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    const voiceRecognition = new VoiceRecognition();
    
    const voiceButton = document.getElementById('voiceButton');
    if (voiceButton) {
        voiceButton.addEventListener('click', () => {
            voiceRecognition.toggle();
        });
    }
});
