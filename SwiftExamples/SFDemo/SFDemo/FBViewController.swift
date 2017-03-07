//
//  ViewController.swift
//  SFDemo
//
//  Created by Manoj Pratap on 28/02/17.
//  Copyright © 2017 learning. All rights reserved.
//

import UIKit
import Accounts
import Social

class FBViewController: UIViewController {
    
    var isFBServiceAvailable : Bool {
        get{
            var result = false
            if SLComposeViewController.isAvailable(
                forServiceType: SLServiceTypeTwitter) {
                // Device is able to send a Twitter message
                result = true
            }
            return result
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isFBServiceAvailable){
        //Show controller to post
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let composeController = SLComposeViewController(forServiceType:
            SLServiceTypeFacebook)
        
        composeController?.setInitialText("Just found this great web site")
        composeController?.add(UIImage(named: "windsor_castle.jpg"))
        composeController?.add(URL(string: "http://www.ebookfrenzy.com"))
        self.present(composeController!,
                     animated: true, completion: nil)
        
    }
}

