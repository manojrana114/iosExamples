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
    var operations=[
        "∏":Operation.Constant(M_PI),
        "e":Operation.Constant(M_E),
        "√":Operation.Unary(sqrt),
        "+":Operation.Binary({$0+$1}),
        "-":Operation.Binary({$0-$1}),
        "×":Operation.Binary({$0*$1}),
        "/":Operation.Binary({$0/$1}),
        "=":Operation.Equals,
        "C":Operation.Constant(0.0)
        
    ];
    
    enum Operation{
        case Constant(Double)
        case Unary((Double)->(Double))
        case Binary((Double,Double)-> Double)
        case Equals
        
    }
    
    var pending: PendingOperation?
    
    struct PendingOperation {
        var binaryFunction:(Double,Double)->Double
        var firstOperand:Double
        
    }
    func performOperation(symbol: String){
        if let operation=operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator=value
            case .Unary(let function):
                accumulator=function(accumulator)
            case .Binary(let function):
                executePendingBinaryOperation()
                pending=PendingOperation(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func executePendingBinaryOperation(){
        if pending != nil {
            accumulator=pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending=nil
        }
    }
    var result:Double{
        get{
            return accumulator
        }
    }
    
}
