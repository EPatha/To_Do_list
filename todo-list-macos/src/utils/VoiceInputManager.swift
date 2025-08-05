import Foundation
import Speech

class VoiceInputManager: NSObject, SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                completion(true)
            default:
                completion(false)
            }
        }
    }

    func startListening(completion: @escaping (String?) -> Void) {
        guard let recognitionTask = recognitionTask else {
            return
        }
        recognitionTask.cancel()
        self.recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        } catch {
            print("Audio session properties weren't set because of an error.")
            return
        }

        guard let inputNode = audioEngine.inputNode, let recognitionRequest = recognitionRequest else {
            return
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let spokenText = result.bestTranscription.formattedString
                completion(spokenText)
            }

            if error != nil || (result?.isFinal ?? false) {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        inputNode.scheduleBuffer(AVAudioPCMBuffer(pcmFormat: recordingFormat, frameCapacity: 1024)!, at: nil, options: .interrupts) { }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine couldn't start because of an error.")
            return
        }
    }

    func stopListening() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
}