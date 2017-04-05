//
//  ViewController.swift
//  KeychainDemo
//
//  Created by Manoj pratap singh rana on 04/04/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let myKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        saveKeyInKeyStore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveKeyInKeyStore(){
        //Write values to keychain
        myKeychainWrapper.mySetObject("mmoipihjk", forKey: kSecValueData)
        myKeychainWrapper.writeToKeychain()
        
        // Read values from keychain
       let value =  myKeychainWrapper.myObject(forKey: kSecValueData)as? String
        print(value)
    }
    
}

