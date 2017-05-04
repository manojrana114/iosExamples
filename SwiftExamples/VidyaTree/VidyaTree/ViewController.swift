//
//  ViewController.swift
//  VidyaTree
//
//  Created by Manoj pratap singh rana on 03/05/17.
//  Copyright © 2017 Impetus. All rights reserved.
//

import UIKit
import ApiAI
import Speech
import SCSiriWaveformView

class ViewController: UIViewController ,SFSpeechRecognizerDelegate {
    
    
    @IBOutlet weak var speechToTextView: UITextView!
    @IBOutlet weak var textToSpeechView: UITextView!

    @IBOutlet weak var microphoneButton: UIButton!
    
    @IBOutlet weak var waveView: SCSiriWaveformView!
    //API.AI init
    private let apiAI = ApiAI()
    
    //Speech recognition
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup for API.AI
        let configuration :AIDefaultConfiguration = AIDefaultConfiguration()
        configuration.clientAccessToken = "fba659ea6d954bfca5146000cad53a8d"
        self.apiAI.configuration = configuration
        
        // Setup speech recognition
        setupSpeechRecognition()
        
        //setup waveview
        configureWaveView()
        updateWaveViewMeters()
        
    }

    //MARK: Setup speech recognition
    func setupSpeechRecognition(){
        microphoneButton.isEnabled = false
    
        speechRecognizer.delegate = self
    
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    
    @IBAction func microphoneTapped(_ sender: AnyObject) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            //microphoneButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
           // microphoneButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func startRecording() {
        
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
                
                self?.speechToTextView.text = result?.bestTranscription.formattedString  //9
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self?.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
                
                self?.microphoneButton.isEnabled = true
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
        
        speechToTextView.text = "Say something, I'm listening!"
        
    }
    
     func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }

    //Mark: Configure WaveView
    
    func configureWaveView(){
        waveView.waveColor = UIColor.white
        waveView.primaryWaveLineWidth = 3.0
        waveView.secondaryWaveLineWidth = 1.0
    }
    
    func updateWaveViewMeters(){
    //TODO: Fetch from Recorder
        let normalizedValue:CGFloat = 0.5 //pow(10, CGFloat(recorder.averagePowerForChannel(0))/20)
       waveView.update(withLevel: normalizedValue)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

