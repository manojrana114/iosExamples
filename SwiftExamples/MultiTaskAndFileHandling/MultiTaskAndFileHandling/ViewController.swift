//
//  ViewController.swift
//  MultiTaskAndFileHandling
//
//  Created by Manoj pratap singh rana on 02/02/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //createNewQueue()
        operationDemo()
    }

    //MARK:GCD Usages
    func createNewQueue(){
        //Note : Sync function on Serial queue blocks the main queue.
        // On concurrent queues async returns immediatelty and syc blocks the next workitem .
        
        
        //Create queue1
        let queue1 = DispatchQueue(label: "com.learn.self")
        queue1.sync {
            for _ in 1...10{
                print("∏")
            }
        }
        
        for _ in 1...10{
            print("Main queue")
        }
        //Create queue 2
        let queue2 = DispatchQueue(label: "com.self.learning", qos: .userInitiated, attributes: [.concurrent])
        let workItem = DispatchWorkItem { 
            for _ in 1...10{
                print("A")
            }
        }
        let workItem1 = DispatchWorkItem {
            for _ in 1...10{
                print("B")
            }
        }
        let workItem2 = DispatchWorkItem {
            for _ in 1...10{
                print("C")
            }
        }
        queue2.async(execute: workItem)
        queue2.sync(execute: workItem1)
        queue2.sync(execute: workItem2)

        //Create
    }
    
    func getGlobalAndMainQueue(){
    
    //Execute task on main queue
        DispatchQueue.main.async {
            for _ in 1...10{
                print("M")
            }
        }
        
        //Get global queue and execue task
        DispatchQueue.global(qos: .default).async { 
            for _ in 1...10{
                print("Global concurrent queue")
            }
        }
    }
    
    //NSOperationQueue -> Queue where we put operations to execute
    // NSOperation : Abstract classs, used to encapsulate piece of code to execute.
    // NSBlockOperation and are subclasses of NSOperation
   
    //NOTE: NSInvocationOperation is deprecated
    
    //MARK:NSOperation
    func operationDemo(){
    let operationQueue = OperationQueue()
    let operationBlock = BlockOperation {
            print ("block operation")
        }
        
        operationQueue.addOperation {
            print("Operation1")
        }
        
        let operation2 = BlockOperation { 
            print("Operation 2")
            }
        operation2.addDependency(operationBlock)
        
        //Add operation to queue
        operationQueue.addOperation(operation2)
        operationQueue.addOperation(operationBlock)
        
    }

}

