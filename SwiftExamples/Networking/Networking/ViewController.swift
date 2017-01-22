//
//  ViewController.swift
//  Networking
//
//  Created by Manoj pratap singh rana on 22/01/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func OnTapDataTaskButton(_ sender: UIButton) {
       
        // Call to show download image demo
        downloadTaskExample()
        
    }
    
    @IBAction func OnTapDownloadTaskButton(_ sender: UIButton) {
    }
    @IBAction func OnTapUploadTaskButton(_ sender: UIButton) {
    }

    //Data task example with completion block
    private func dataTaskExample(){
      
        //Note :NSURLSessionConfiguration apis has been renamed
        //Data task exam
        let url=URL(string: "https://jsonplaceholder.typicode.com/posts/1")
        
        // 1)Create configuration first
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest=5
        
        // 2) Create session
        let session=URLSession(configuration: configuration)
        
        // 3)Create/Obtain task
        let task = session.dataTask(with: url!) { (data:Data?, response:URLResponse?, error:Error?) in
            
            guard data != nil else { return }
            print(String(bytes: data!, encoding: String.Encoding.utf8) ?? "Error in converting")
            
            print()
            session.finishTasksAndInvalidate()
        }
        
        // 4) Start task
        task.resume()
        
    }
    
    private func downloadTaskExample(){
    
        //URL of image to download,NOTE: it's optional
        let url=URL(string: "https://placeholdit.imgix.net/~text?txtsize=14&bg=dff9f6&txt=150%C3%97150&w=150&h=150")
        
        //URL for temp store
        let fileManager=FileManager.default
        
        let filePaths=fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        
        let storedURL=filePaths[0].appendingPathComponent("1.png")
        
        // 1)Create SessionConfiguration
        let configuration=URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest=5
        
        // 2) Create session
        let session=URLSession(configuration: configuration)

        // 3) create download task
        let downloadTask=session.downloadTask(with: url!) { (tempURL:URL?, response:URLResponse?, error:Error?) in
           
            guard error==nil else {return}
            try? fileManager.moveItem(at: tempURL!, to: storedURL)
            
        }
        
        //Start task
        downloadTask.resume()
    }
}

