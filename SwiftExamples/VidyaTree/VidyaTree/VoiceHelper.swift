//
//  VoiceHelper.swift
//  VidyaTree
//
//  Created by Manoj pratap singh rana on 04/05/17.
//  Copyright © 2017 Impetus. All rights reserved.
//
import Speech
import AVFoundation
import Accelerate
class VoiceHelper : NSObject, SFSpeechRecognizerDelegate,SFSpeechRecognitionTaskDelegate {
    
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
    
    let audioSession = AVAudioSession.sharedInstance()
    
    //Speech Synthesier
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    //var to hold text read
    var textRead : String = ""
    
    
    ///
    let LEVEL_LOWPASS_TRIG : Float32 = 0.3

    var averagePowerForChannel0 : Float32 = 0.001
    
    
    ////
    
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

            //Code to animate a waveform with the microphone volume, ignore if you don't need it:
            let inNumberFrames:UInt32 = buffer.frameLength;
           
            if(buffer.format.channelCount > 0){
                
               // var samples:Float32 = buffer.floatChannelData![0][0];
                var avgValue:Float32 = 0;
                vDSP_maxmgv((buffer.floatChannelData?[0])!, 1, &avgValue, vDSP_Length(inNumberFrames)); //Accelerate Framework
                
                let avg3:Float32 = ((avgValue == 0) ? (-100) : 20.0)
                
                self.averagePowerForChannel0 = (self.LEVEL_LOWPASS_TRIG * avg3 * log10f(avgValue)) + ((1-self.LEVEL_LOWPASS_TRIG) * self.averagePowerForChannel0) ;
            }
            
           /* if(buffer.format.channelCount > 1){
                
                var avgValue:Float32 = 0;
                vDSP_meamgv((buffer.floatChannelData?[0])!, 1, &avgValue, vDSP_Length(inNumberFrames)); //Accelerate Framework
                
                let avg3:Float32 = ((avgValue == 0) ? (-100) : 20.0)
                
                self.averagePowerForChannel1 = (self.LEVEL_LOWPASS_TRIG * avg3 * log10f(avgValue)) + ((1-self.LEVEL_LOWPASS_TRIG) * self.averagePowerForChannel1) ;
            }*/
            
    
            
            
            print("AVG. POWER: " + self.averagePowerForChannel0.description)
           
            DispatchQueue.main.async {
                self.delegate?.updateWaveView(value: self.averagePowerForChannel0)
            }
            /*dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //print("VU: "+vu.description)
                var fAvgPwr=CGFloat(averagePower)
                print("AvgPwr: "+fAvgPwr.description)
                
                var waveformFriendlyValue=0.5+fAvgPwr //-0.5 is AvgPwrValue when user is silent
                if(waveformFriendlyValue<0){waveformFriendlyValue=0} //round values <0 to 0
                self.waveview.hidden=false
                self.waveview.updateWithLevel(waveformFriendlyValue)
            })*/
    }
   

    //I use this timer to track no speech timeouts, ignore if not neeeded:
   // self.endOfSpeechTimeoutTimer = NSTimer.scheduledTimerWithTimeInterval(utteranceTimeoutSeconds, target: self, selector:  #selector(ViewController.stopNativeRecording), userInfo: nil, repeats: false)
    
    
    
    
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
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
}

extension VoiceHelper : AVSpeechSynthesizerDelegate{
    //Mark : Text to speech Conversion
    func convertTextToSpeech(textToSpeak: String){
        if synth.isSpeaking{
            synth.stopSpeaking(at: .immediate)
        }
//        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        synth.delegate = self;
        myUtterance = AVSpeechUtterance(string: textToSpeak)
        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-IN")
        myUtterance.rate = 0.4
        myUtterance.pitchMultiplier = 1.2
        synth.speak(myUtterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let selectionPosition = characterRange.location;
        let wordLength = characterRange.length;

        delegate?.highLightTextInTextView(position: selectionPosition, length: wordLength)
    }
    
    
}

extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
}
