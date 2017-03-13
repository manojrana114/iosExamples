//
//  TwitterViewController.swift
//  SFDemo
//
//  Created by Manoj Pratap on 28/02/17.
//  Copyright © 2017 learning. All rights reserved.
//


/*
 
 This will demo calling twitter APis to get feeds from timeline.
 
 
 */
import UIKit
import Social
import Accounts
class TwitterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getTwitterAccount()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Model
    
    private func getTwitterAccount(){
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccounts(with: accountType!, options: nil) { (success, error) in
            
            if(success){
            //Fetch the account
                let twitterAccount =
                    accountStore.accounts(with: accountType).last as? ACAccount
                
                if (twitterAccount != nil) {
                    print("Account fetched")
                    //fetch tweets
                    let url = URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")
    let params = [
        "count" : "50",
        "screen_name" : "@CNNnews18 "
                    ]
                    
                    let postRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: params)
                    postRequest?.account = twitterAccount
                    postRequest?.perform(handler: { [weak self](data, response, error) in
                        
                        if(error == nil){
                            
                            self?.twitterDataReceived(jsonResponse: data)
                        }
                    })
                    
                    
                }
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func twitterDataReceived(jsonResponse : Data?){
        var propertyListResponse: Any?
        
        if jsonResponse != nil {
            propertyListResponse = try? JSONSerialization.jsonObject(
                with: jsonResponse!,
                options: JSONSerialization.ReadingOptions.mutableLeaves)
            if propertyListResponse == nil {
                let error = "Couldn't parse JSON response."
                propertyListResponse = error
            }
        } else {
            let error = "No response from Twitter."
            propertyListResponse = error
        }
    }
}
