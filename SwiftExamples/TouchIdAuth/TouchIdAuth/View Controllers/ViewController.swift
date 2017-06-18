//
//  ViewController.swift
//  TouchIdAuth
//
//  Created by Manoj pratap singh rana on 18/06/17.
//  Copyright © 2017 Impetus. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func verifyPassword(_ sender: UIButton) {
        
        
    }
    
    func authenticateUser(){
        // Get the local authentication context.
        let context : LAContext = LAContext()
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        let reasonString = "Authentication is needed to access your HomeScreen."
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, localError) in
                if success {
                    //It's a background thread
                    print("success")
                    }
            //IF ERROR
                if let evalPolicyError = localError as? LAError{
                    print(evalPolicyError.localizedDescription)
                    switch evalPolicyError.code{
                    case .systemCancel:
                        print("Authentication was cancelled by the system")
                        
                    case .userCancel:
                    print("Authentication was cancelled by the user")
                    
                    case .userFallback:
                    print("User selected to enter custom password")
                    OperationQueue.main.addOperation({ () -> Void in
                        //Show alert to take pasword
                    })
                    
                    default:
                    print("Authentication failed")
                    OperationQueue.main.addOperation({ () -> Void in  })
                    }
                }})// Closure ends here
        }
    }
}
