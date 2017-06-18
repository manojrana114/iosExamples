//
//  ViewController.swift
//  KeychainDemo
//
//  Created by Manoj pratap singh rana on 04/04/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

import UIKit
import Security
class ViewController: UIViewController {

    let myKeychainWrapper = KeychainWrapper(
    
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
    
    
   /*func listCertificates()
    {
        var status : OSStatus ;
    
        let kSecClassValue = kSecClass.takeRetainedValue() as NSString
        let kSecAttrAccountValue = kSecAttrAccount.takeRetainedValue() as NSString
        let kSecValueDataValue = kSecValueData.takeRetainedValue() as NSString
        let kSecClassGenericPasswordValue = kSecClassGenericPassword.takeRetainedValue() as NSString
        let kSecAttrServiceValue = kSecAttrService.takeRetainedValue() as NSString
        let kSecMatchLimitValue = kSecMatchLimit.takeRetainedValue() as NSString
        let kSecReturnDataValue = kSecReturnData.takeRetainedValue() as NSString
        let kSecMatchLimitOneValue = kSecMatchLimitOne.takeRetainedValue() as NSString
    }*/
}
