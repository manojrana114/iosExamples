//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by Manoj pratap singh rana on 07/05/17.
//  Copyright © 2017 Impetus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var model = DataModel()
    @IBOutlet weak var weatherDate: UILabel!
    
    @IBOutlet weak var weatherTemperature: UILabel!
    
    
    @IBOutlet weak var weatherLocation: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    
    @IBOutlet weak var weatherDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* model.downloadData {
           self.updateUI()
        }*/
        
        model.alamofireTest()
    }

    func updateUI(){
        
        self.weatherDate.text = model.date
        self.weatherTemperature.text = model.temp
        self.weatherLocation.text = model.location
        self.weatherDescription.text = model.weather
    
    }
   
}

