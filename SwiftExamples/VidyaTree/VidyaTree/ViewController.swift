//
//  ViewController.swift
//  VidyaTree
//
//  Created by Manoj pratap singh rana on 03/05/17.
//  Copyright © 2017 Impetus. All rights reserved.
//

import UIKit
import ApiAI
import SCSiriWaveformView
import AVFoundation
class ViewController: UIViewController ,VoiceHelperDelegate {
    
    
    @IBOutlet weak var speechToTextView: UITextView!

    @IBOutlet weak var microphoneButton: UIButton!
    
    @IBOutlet weak var waveView: SCSiriWaveformView!
    
    let voiceHelper : VoiceHelper = VoiceHelper()
    
    //API.AI init
    private let apiAI = ApiAI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup for API.AI
        let configuration :AIDefaultConfiguration = AIDefaultConfiguration()
        configuration.clientAccessToken = "fba659ea6d954bfca5146000cad53a8d"
        self.apiAI.configuration = configuration
        
        // Setup speech recognition
            voiceHelper.delegate = self;
            voiceHelper.setupSpeechRecognition()
       
        //setup waveview
        configureWaveView()        
    }


    @IBAction func microphoneTapped(_ sender: AnyObject) {
        
      let permission =   AVAudioSession.sharedInstance().recordPermission()
    
        if(permission == .undetermined)
        {        AVAudioSession.sharedInstance().requestRecordPermission({ (result) in})
        }
            
        if(permission == .granted){
            self.showWave()
            self.speechToTextView.text =  "Say something, I'm listening!"
            self.voiceHelper.onMicrophoneTap()
            }
        }
    
    //Mark: Configure WaveView
    func configureWaveView(){
        waveView.waveColor = UIColor.white
        waveView.primaryWaveLineWidth = 2.0
        waveView.secondaryWaveLineWidth = 1.0
    }
    
    func updateWaveView(value : Float32){
        //Normal silent value ranges from -22 to - 28
        let normalizedValue : CGFloat = (40 + CGFloat(value)) * 0.03
        waveView.update(withLevel: normalizedValue)
    }
  
    //Mark : VoiceHelper Delegate
    func textFromSpeech(text: String) {
        if(!(text == "What was that ?")){
            self.speechToTextView.text = text
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 1000)) { [weak self] in
            self?.submitQuery(query: text)
        }
        
    }
    
    func highLightTextInTextView(position : Int ,length: Int){
        self.speechToTextView.scrollRangeToVisible(NSMakeRange(position, length));
        let string = NSMutableAttributedString(attributedString: speechToTextView.attributedText)
        let attributes = [NSBackgroundColorAttributeName : UIColor.init(red: 0.6784, green: 0.8392, blue: 1.0000, alpha: 0.8)]
        string.addAttributes(attributes, range: speechToTextView.selectedRange)
        speechToTextView.attributedText = string
        speechToTextView.selectedRange = NSMakeRange(position, length)
    }

    func enableMicrophone(enable : Bool){
        submitQuery(query: "")
        self.microphoneButton.isHidden = false
        self.waveView.isHidden = true
    }

    //MARK : API.AI Handling
    func submitQuery(query : String){
        let request = self.apiAI.textRequest()
        request?.query = [query]
        request?.setCompletionBlockSuccess({ [weak self](request, response) in
            //Success
            if let res = response as? Dictionary<String, Any>
            {
                if let result =  res["result"] as? Dictionary<String, Any>{
                    if let fulfillment =  result["fulfillment"] as? Dictionary<String, Any>{
                        if let speech =  fulfillment["speech"] as? String{
                            //Response from query , schedule it to play
                            DispatchQueue.main.async {
                                self?.showMic()
                                self?.speechToTextView.text = speech
                                self?.voiceHelper.convertTextToSpeech(textToSpeak: speech)

                            }
                        }
                    }
                }
            }
            
        }, failure: { (request, error) in
            print(error.debugDescription)
            self.showMic()

            //Error
        })
        
        //Call API for query
        self.apiAI.enqueue(request)
    }
    
    //toggle WaveView and microphone
    func showMic(){
            self.microphoneButton.isHidden = false
            self.waveView.isHidden = true
        }
    
    func showWave(){
        self.microphoneButton.isHidden = true
        self.waveView.isHidden = false
    }
    
}

