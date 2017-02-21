//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Manoj pratap singh rana on 20/02/17.
//  Copyright © 2017 learning. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController ,UISplitViewControllerDelegate{

    private struct Storyboard{
         static let showImageView = "Show Image";
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Storyboard.showImageView)
        {
            //Prepare destination view controller
            if let destinationController = segue.destination.contentViewController as? ImageViewController{
               
                destinationController.imageUrl = DemoURL.NASAImageNamed(imageName: (sender as? UIButton)?.currentTitle) as URL?
                
                destinationController.title = (sender as? UIButton)?.currentTitle
            }
        }
    }
    
    @IBAction func onButtonTapped(_ sender: UIButton) {
        if let imageViewController = self.splitViewController?.viewControllers.last?.contentViewController as? ImageViewController{
            imageViewController.imageUrl = DemoURL.NASAImageNamed(imageName: sender.currentTitle) as URL?
            
        }else{
            performSegue(withIdentifier: Storyboard.showImageView, sender: sender)
        }
        self.title = "Cassini" 
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
 
    }
    
}
extension UIViewController{
    
    var contentViewController : UIViewController{
        get{
            if  let navController = self as? UINavigationController {
                return navController.visibleViewController ?? self
            }else{
                return self
            }
        }
    }
    
}
