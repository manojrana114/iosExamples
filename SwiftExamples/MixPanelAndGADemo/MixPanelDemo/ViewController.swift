//
//  ViewController.swift
//  MixPanelAnalytics
//
//  Created by Manoj pratap singh rana on 16/06/17.
//  Copyright © 2017 Impetus. All rights reserved.
//

import UIKit
import Mixpanel
class ViewController: UIViewController {
    
    @IBOutlet weak var counterLabel: UILabel!
    var counter = 0
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startTimer(_ sender: UIButton) {
        counter = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        timer?.fire()
        //Track Event
        Mixpanel.mainInstance().time(event: "Timer Started")
        
    }
    
    @IBAction func stopTimer(_ sender: UIButton) {
        timer?.invalidate()
        //Track event with property
        Mixpanel.mainInstance().track(event: "Timer Stopped", properties: ["Counter":counterLabel.text!])

    }
    
    @objc func updateLabel(){
        if(counter>0){
            counter-=1;
            self.counterLabel.text = String(counter)
        }else{
            timer?.invalidate()
        }
    }
    
}

