//
//  ViewController.swift
//  Cassini
//
//  Created by Manoj Pratap on 20/02/17.
//  Copyright © 2017 learning. All rights reserved.

//

import UIKit

class ImageViewController: UIViewController,UIScrollViewDelegate {

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
            if(view.window != nil){
                fetchImage()
            }
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchImage()
    }
    
    private func fetchImage()
    {
        if let url = imageUrl
        {
            self.activityIndicator.startAnimating()
                let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
                queue.async {
                    do{
                    let data = try Data(contentsOf: url)
                        DispatchQueue.main.async {[weak self] in
                            self?.image = UIImage(data: data)
                            self?.activityIndicator.stopAnimating()

                        }
                }catch{
                    // for now empty
                    print("Exception occured")
                }
                }
                
        }
    }
    
    let imageView = UIImageView()
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var image : UIImage?
    {   get { return imageView.image}
        set
        {   imageView.image = newValue
            imageView.sizeToFit()
            //Optional is required as we are not sure if scroll view outlet would be set here
            scrollView?.contentSize = imageView.frame.size

            
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.3
        scrollView.minimumZoomScale = 2.0
        scrollView.addSubview(imageView)
        activityIndicator.hidesWhenStopped = true
    }
    
    
    
    

  }

