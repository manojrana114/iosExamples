//
//  ViewController.swift
//  Networking
//
//  Created by Manoj pratap singh rana on 22/01/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//


/**
 * Networking iOS using URLSession Apis(NSURLSession apis objc)
 * a) Create URLSessionConfiguration (default,ephermal,background)
 *      Default-> Configured Session with disk based cache.This also ask
 *                Session object to store communication credntial in
 *                keychain
 *      Ephermal-> Configure Session with RAM based cache.Use this when
 *                 small data needs to download.Credential gets disposed
 *                 once we are done with session
 *      Background-> Use this when we need to download data in background even when app is not running
 *
 * b)Create URLSession passing configuration in constructor. Set session delegate if we want to
 *   use delegation mechanish or continous communication.
 * c) Create datatask/downloadtask/uploadtask.
 *       DataTask-> Use this when you want to download data in interactive manner from server.
 *                  Resume is not supported so cant be used in backgrond session
 *       DownloadTask -> It writes the respone to disk at temp location.
 *                       Used for background downloading task.
 *       Upload task -> //Need to try
 *
 *   We can pass completion handler or can use delegate to get notified when task is complete
 * d) call resume method on created task
 *
 *
 *
 */

import UIKit

class ViewController: UIViewController , URLSessionDownloadDelegate {
    
    @IBOutlet weak var jsonTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func OnTapDataTaskButton(_ sender: UIButton) {
        dataTaskExample()
    }
    
    @IBAction func OnTapDownloadTaskButton(_ sender: UIButton) {
        // Call to show download image demo
        downloadTaskExample()
    }
    @IBAction func OnTapUploadTaskButton(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func downloadTaskForVideo(_ sender: UIButton) {
        downloadTaskWithDelegate()
    }
    
    @IBAction func downloadInBackground(_ sender: UIButton) {
        downloadTaskInBackground()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        let task = session.dataTask(with: url!) { [weak self](data:Data?, response:URLResponse?, error:Error?) in
            
            if error != nil{
                //todo: handle error
                return
            }
            guard data != nil else { return }
            
            //Update text view in main thread
            DispatchQueue.main.async {
                self?.jsonTextView.text=String(bytes: data!, encoding: String.Encoding.utf8) ?? "Error in converting"
                
            }
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
        let configuration=URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest=5
        
        // 2) Create session
        let session=URLSession(configuration: configuration)
        
        // 3) create download task
        let downloadTask=session.downloadTask(with: url!) {[weak self] (tempURL:URL?, response:URLResponse?, error:Error?) in
            
            guard error==nil else {return}
            try? fileManager.moveItem(at: tempURL!, to: storedURL)
            DispatchQueue.main.async {
                let image=UIImage(contentsOfFile: storedURL.path)
                self?.imageView.contentMode = .scaleAspectFit
                self?.imageView.image=image
                
            }
            
        }
        
        //Start task
        downloadTask.resume()
    }
    
    func downloadTaskWithDelegate(){
        
        let videoURL = URL(string: "https://ia601409.us.archive.org/8/items/alanoakleysmalltestvideo/spacetestSMALL.ogv");
        
        // 1) Create Default Session configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest=20
        
        // 2) Create Session and set delegate
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    
        // 3) Create download task
        let task=session.downloadTask(with: videoURL!)
        
        task.resume()
       
        
    }
    
   
    
    // MARK: SessionDataDelegate methods
    var data = Data()
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    
        let bgIdentifier=session.configuration.identifier;
        if(bgIdentifier == nil){
        DispatchQueue.main.async {
            self.progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
            }
        }else{
        print("Downloding data in background")
            
        }

    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        guard error==nil else {
            return
        }
        
        session.finishTasksAndInvalidate()
        
    }
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
    }
    
    // MARK: Background download
    let configurationIdentifier="backConfig"
    var backgroundIdentifier:String{
        get{
            let userDefaults=UserDefaults.standard
            if let value=userDefaults.string(forKey: configurationIdentifier){
                return value
            }else{
            let value=Date.description(Date.init())
                return String(describing: value)
            }
        }
    }

    func downloadTaskInBackground(){
        let videoURL = URL(string: "https://ia601409.us.archive.org/8/items/alanoakleysmalltestvideo/spacetestSMALL.ogv");

        // a)create configuration
        let configuration=URLSessionConfiguration.background(withIdentifier: backgroundIdentifier)
        configuration.timeoutIntervalForRequest=10
        // b) create session
        let session=URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        //c)creatse task
        let task=session.downloadTask(with: videoURL!)
        task.resume()
        
    }
}

