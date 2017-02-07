//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Manoj pratap singh rana on 07/02/17.
//  Copyright © 2017 learning. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Emotions"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let emotionalFaces =
    [
        "Angry":FacialExpression(eyes:.Closed,eyeBrows:.Furrowed,mouth:.Frown),
        "Happy":FacialExpression(eyes:.Open,eyeBrows:.Normal,mouth:.Smile),
        "Worried":FacialExpression(eyes:.Open,eyeBrows:.Relaxed,mouth:.Smirk),
        "Mischievious":FacialExpression(eyes:.Open,eyeBrows:.Furrowed,mouth:.Grin)
    ]
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Note: Outlets are not set in prepareSegue methiod
        let destinationVC = (segue.destination as? UINavigationController)?.visibleViewController
        let faceViewController = destinationVC as? FaceViewController
        if let buttonTitle = (sender as! UIButton).currentTitle
        {
            faceViewController?.expression=emotionalFaces[buttonTitle]!
            faceViewController?.navigationItem.title = buttonTitle
        }
    }
    

}
