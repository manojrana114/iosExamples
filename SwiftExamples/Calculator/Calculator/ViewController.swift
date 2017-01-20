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
    
    var userInMiddleOfTyping=false
    
    
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit=sender.currentTitle!
        
        if userInMiddleOfTyping{
            display.text=display.text!+digit
        }else{
            display.text=digit
        }
        userInMiddleOfTyping=true
        
    }
    
    //Computed property to track tet in display Label
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            if(newValue == 0){
                display.text="0"
            }else{
                display.text=String(newValue)
            }
        }
    }
    
    var brain=CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if(userInMiddleOfTyping){
            userInMiddleOfTyping=false
            brain.setOperand(operand: displayValue)
        }
        
        if let mathematicalSymbol=sender.currentTitle{
            brain.performOperation(symbol: mathematicalSymbol)
            displayValue=brain.result
        }
    }
    
    
    @IBAction func decimalTapped() {
        let result=display.text!.range(of: ".")
        if result == nil{
            display.text!+="."
            userInMiddleOfTyping=true

        }
    }
}

