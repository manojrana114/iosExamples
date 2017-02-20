//
//  ViewController.swift
//  Cassini
//
//  Created by Manoj Pratap on 20/02/17.
//  Copyright © 2017 learning. All rights reserved.

//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
        {
        didSet{
            scrollView.contentSize = imageView.frame.size

            }
        }
   
    var imageUrl : URL?
        {
        didSet{
            image = nil
            fetchImage()
            }
        }
    
    private func fetchImage()
    {
        if let url = imageUrl
        {
            do{
                let data = try Data(contentsOf: url)
                image = UIImage(data: data)
            }catch{
            // for now empty
                print("Exception occured")
            }
        }
    }
    
    let imageView = UIImageView()
   
    var image : UIImage?
    {   get { return imageView.image}
        set
        {   imageView.image = newValue
            imageView.sizeToFit()
            //Optional is required as we are not sure if scroll view outlet would be set here
            scrollView?.contentSize = imageView.frame.size

            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        imageUrl =  DemoURL.NASAImageNamed(imageName: "Cassini") as URL?

    }

  }

