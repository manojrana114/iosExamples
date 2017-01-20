//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Manoj pratap singh rana on 20/01/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

/**
 Model class
 */
import Foundation

class CalculatorBrain{
    
    var accumulator=0.0
    func setOperand(operand: Double){
        accumulator=operand
    }
    
    func performOperation(symbol: String){
        switch symbol {
        case "∏":
            accumulator=M_PI
        case "√":
            accumulator=sqrt(accumulator)
        default:
            break;
        }
    }
    
    var result:Double{
        get{
            return accumulator
        }
    }
    
}
