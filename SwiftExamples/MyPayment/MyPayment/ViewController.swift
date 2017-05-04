//
//  ViewController.swift
//  MyPayment
//
//  Created by Manoj Pratap on 03/05/17.
//  Copyright © 2017 impetus. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask permission to access Siri
        INPreferences.requestSiriAuthorization { authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                print("Authorized")
            default:
                print("Not Authorized")
            }
        }
    }
}
