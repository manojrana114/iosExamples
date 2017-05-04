//
//  VoiceHelper.swift
//  VidyaTree
//
//  Created by Manoj pratap singh rana on 04/05/17.
//  Copyright © 2017 Impetus. All rights reserved.
//
import Speech
import AVFoundation

class VoiceHelper : NSObject, SFSpeechRecognizerDelegate ,AVSpeechSynthesizerDelegate {
    
    //Delegate
     weak var delegate :VoiceHelperDelegate?
    
    //Enable/Disable Microphone button
    var isButtonEnabled = false {
        didSet{
            delegate?.enableMicrophone(enable: isButtonEnabled)
        }
    }

    //Speech recognition
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-IN"))!
    
    private var recognitionRequest:SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    //Speech Synthesier
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    //var to hold text read
    var textRead : String = ""
    
    //MARK: Setup speech recognition
    func setupSpeechRecognition(){
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization {[weak self] (authStatus) in
            switch authStatus {
            case .authorized:
                self?.isButtonEnabled = true
        
            case .denied,.restricted,.notDetermined :
                self?.isButtonEnabled = false
                print("User denied access to speech recognition")
              }
        }
    }
    
    //Mark Recording
  private  func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }  //4
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { [weak self](result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
               self?.textRead = (result?.bestTranscription.formattedString)! //9
                isFinal = (result?.isFinal)!
            }
            
            print(isFinal)
            if error != nil || isFinal {  //10
                self?.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
    
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
                self?.isButtonEnabled = true
                self?.delegate?.textFromSpeech(text: (self?.textRead)!)//9

            
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        //self.delegate?.textFromSpeech(text : "Say something, I'm listening!")
    }
    
    func onMicrophoneTap(){
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            self.isButtonEnabled = false
        } else {
            startRecording()
        }
    }
    
    //Mark : Delegate Method
    internal func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.isButtonEnabled = true
        } else {
            self.isButtonEnabled = false
        }
    }
    
    //Mark : Text to speech Conversion
    func convertTextToSpeech(textToSpeak: String){
        //stop audio engine
        if audioEngine.isRunning {
            audioEngine.stop()
        }
        synth.delegate = self;
        myUtterance = AVSpeechUtterance(string: textToSpeak)
        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-IN")
        myUtterance.rate = 0.3
        myUtterance.pitchMultiplier = 2
        synth.speak(myUtterance)
    }
    
    //Mark : Observer Microphone volume
    //TODO
}
