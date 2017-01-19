//
//  ViewController.swift
//  Calculator
//
//  Created by Manoj pratap singh rana on 15/01/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var displayLong:Double?{
        
        get{
            return Double(display.text!)
        }
        set{
            display.text=String(describing: newValue)
        }
    }
    
    var userInMiddleOfTyping=false
    
    @IBAction private func digitTapped(_ sender: UIButton) {
        
        if let digitTapped=sender.currentTitle{
            if userInMiddleOfTyping{
                display.text=display.text!+digitTapped
            }else{
                display.text=digitTapped
                userInMiddleOfTyping=true
            }
        }
    }
    
}

