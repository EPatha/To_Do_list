/**
 * Voice Recognition untuk Laravel To-Do List
 * Fitur untuk menambah, menyelesaikan, dan menghapus todo dengan suara
 */

class VoiceRecognition {
    constructor() {
        if (!('SpeechRecognition' in window || 'webkitSpeechRecognition' in window)) {
            alert('Maaf, browser Anda tidak mendukung fitur voice recognition. Gunakan Chrome atau Edge terbaru.');
            return;
        }
        
        try {
            this.recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)();
            this.isListening = false;
            this.shouldRestart = false;
            this.setupRecognition();
        } catch (e) {
            console.error('Error initializing speech recognition:', e);
            alert('Terjadi kesalahan saat menginisialisasi voice recognition.');
        }
    }

    setupRecognition() {
        this.recognition.continuous = false;  // Set continuous ke false untuk kontrol lebih baik
        this.recognition.interimResults = false;
        this.recognition.lang = 'id-ID'; // Set untuk Bahasa Indonesia

        this.recognition.onstart = () => {
            const button = document.getElementById('voiceButton');
            const status = document.getElementById('voiceStatus');
            if (button) button.classList.add('listening');
            if (status) status.textContent = 'Mendengarkan... (Klik untuk berhenti)';
        };

        this.recognition.onend = () => {
            if (this.isListening && this.shouldRestart) {
                setTimeout(() => {
                    try {
                        this.recognition.start();
                    } catch (e) {
                        console.error('Failed to restart recognition:', e);
                        this.stopListening();
                    }
                }, 100);
            } else {
                this.stopListening();
            }
        };

        this.recognition.onresult = (event) => {
            const transcript = event.results[0][0].transcript.toLowerCase();
            console.log('Voice command:', transcript);
            this.processCommand(transcript);
        };

        this.recognition.onerror = (event) => {
            console.error('Speech recognition error:', event.error);
            const status = document.getElementById('voiceStatus');
            if (status) {
                status.textContent = 'Error: ' + event.error;
                setTimeout(() => {
                    status.textContent = 'Klik untuk berbicara';
                }, 3000);
            }
        };
    }

    processCommand(transcript) {
        console.log('Processing transcript:', transcript);
        
        // Menambah task baru
        if (transcript.includes('tambah') || transcript.includes('add')) {
            const taskTitle = transcript.replace(/tambah|add/gi, '').trim();
            if (taskTitle) {
                this.addTask(taskTitle);
            }
        }
        // Menandai task selesai
        else if (transcript.includes('selesai') || transcript.includes('complete')) {
            const taskTitle = transcript.replace(/selesai|complete/gi, '').trim();
            this.markTaskAsComplete(taskTitle);
        }
        // Menghapus task
        else if (transcript.includes('hapus') || transcript.includes('delete')) {
            const taskTitle = transcript.replace(/hapus|delete/gi, '').trim();
            this.deleteTask(taskTitle);
        }
        // Bersihkan semua task
        else if (transcript.includes('bersihkan semua') || transcript.includes('clear all')) {
            this.clearAllTasks();
        }
        // Show help
        else if (transcript.includes('bantuan') || transcript.includes('help')) {
            this.showHelp();
        }
    }

    addTask(taskTitle) {
        const input = document.getElementById('todoInput');
        const form = document.getElementById('addTodoForm');
        
        if (input && form) {
            input.value = taskTitle;
            form.submit();
        }
    }

    markTaskAsComplete(taskTitle) {
        const tasks = document.querySelectorAll('.todo-item');
        let found = false;
        
        tasks.forEach(task => {
            const titleElement = task.querySelector('.todo-title');
            if (titleElement && titleElement.textContent.toLowerCase().includes(taskTitle)) {
                const checkbox = task.querySelector('input[type="checkbox"]');
                if (checkbox && !checkbox.checked) {
                    checkbox.click();
                    found = true;
                }
            }
        });
        
        if (!found) {
            this.showMessage(`Task "${taskTitle}" tidak ditemukan atau sudah selesai`);
        }
    }

    deleteTask(taskTitle) {
        const tasks = document.querySelectorAll('.todo-item');
        let found = false;
        
        tasks.forEach(task => {
            const titleElement = task.querySelector('.todo-title');
            if (titleElement && titleElement.textContent.toLowerCase().includes(taskTitle)) {
                const deleteButton = task.querySelector('.delete-button');
                if (deleteButton) {
                    if (confirm(`Hapus task "${titleElement.textContent}"?`)) {
                        deleteButton.click();
                    }
                    found = true;
                }
            }
        });
        
        if (!found) {
            this.showMessage(`Task "${taskTitle}" tidak ditemukan`);
        }
    }

    clearAllTasks() {
        const deleteButtons = document.querySelectorAll('.delete-button');
        if (deleteButtons.length > 0) {
            if (confirm('Hapus semua task?')) {
                deleteButtons.forEach(button => button.click());
            }
        } else {
            this.showMessage('Tidak ada task untuk dihapus');
        }
    }

    showHelp() {
        const helpText = `
Perintah Voice Recognition:
- "Tambah [nama task]" - Menambah task baru
- "Selesai [nama task]" - Menandai task selesai
- "Hapus [nama task]" - Menghapus task
- "Bersihkan semua" - Menghapus semua task
- "Bantuan" - Menampilkan help ini
        `;
        alert(helpText);
    }

    showMessage(message) {
        const status = document.getElementById('voiceStatus');
        if (status) {
            const originalText = status.textContent;
            status.textContent = message;
            setTimeout(() => {
                status.textContent = originalText;
            }, 3000);
        }
    }

    stopListening() {
        this.isListening = false;
        this.shouldRestart = false;
        const button = document.getElementById('voiceButton');
        const status = document.getElementById('voiceStatus');
        
        if (button) button.classList.remove('listening');
        if (status) status.textContent = 'Klik untuk berbicara';
    }

    toggle() {
        if (this.isListening) {
            this.recognition.stop();
            this.stopListening();
        } else {
            this.isListening = true;
            this.shouldRestart = true;
            try {
                this.recognition.start();
            } catch (e) {
                console.error('Failed to start recognition:', e);
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
