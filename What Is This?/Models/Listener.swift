//
//  Listener.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/5/23.
//

import Speech

class Listener: ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @Published var speechText = ""
    @Published var detected = false

    func startListening() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { return }

            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result {
                    let recognizedText = result.bestTranscription.formattedString
                    DispatchQueue.main.async {
                        self.speechText = recognizedText
                    }

                    // Check if the recognized text contains the desired phrase
                    if recognizedText.contains("What is this") {
                        // Do something when the phrase is detected
                        // e.g., show an alert or trigger some other action
                        print("The phrase 'What is this?' was detected.")
                        self.detected = true
                    }
                }

                if error != nil {
                    print("Error recognizing speech: \(error!.localizedDescription)")
                }
            }

            let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                recognitionRequest.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Error setting up speech recognition: \(error.localizedDescription)")
        }
    }
    
    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                // Microphone access granted, start speech recognition
                self.startListening()
            } else {
                // Microphone access denied, handle accordingly (e.g., show an alert)
                print("Microphone access denied.")
            }
        }
    }
    
    func resetDetected() {
        detected = false
    }
}
