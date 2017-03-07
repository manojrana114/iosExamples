//
//  ViewController.swift
//  UNNotificationDemo
//
//  Created by Manoj pratap singh rana on 06/03/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

import UIKit
import UserNotifications
class ViewController: UIViewController {
    
    let nIdentifier = "notification" //Notification identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendNotificaion(_ sender: UIButton) {
        
        // 2) Content Creation
        let content = UNMutableNotificationContent()
        content.title = "Notificatio demo"
        content.subtitle = "Time based notification"
        content.body = "My first notification"
        
        
        //3) Create trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        //4) Package everything into request
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        //5) Schedule notification
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil{
                print("Error : \(error)")
            }
        }
    }

    @IBAction func updateNotificationContent(_ sender: UIButton) {
        let updatedContent = UNMutableNotificationContent()
        updatedContent.title = "Updated Notificatio demo"
        updatedContent.subtitle = " Updated Time based notification"
        updatedContent.body = "Updated My first notification"
        
        //3) Create trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        //4) Package everything into request
        let request = UNNotificationRequest(identifier: "notification", content: updatedContent, trigger: trigger)
        
        //5) Schedule notification
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil{
                print("Error : \(error)")
            }
        }
    }
    
    @IBAction func removeNotification(_ sender: Any) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [nIdentifier])
    }
    
    
    @IBAction func addActionNotification(_ sender: Any) {
        
        //Create Action
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION", title: "Snooze", options: UNNotificationActionOptions.init(rawValue: 0))
        
        let textInputAction = UNTextInputNotificationAction(identifier: "input", title: "Message", options: .init(rawValue: 1), textInputButtonTitle: "Send", textInputPlaceholder: "name")
        
        let stopAction = UNNotificationAction(identifier: "STOP_ACTION", title: "Stop", options:.foreground)
        
        //create Category
        let timerCategory = UNNotificationCategory(identifier: "timerCategory", actions: [textInputAction,snoozeAction,stopAction], intentIdentifiers: [], options: [])
        
        //Register category with UNNotifictionCenter
        UNUserNotificationCenter.current().setNotificationCategories([timerCategory])
        
        
        // 2) Content Creation
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Wake up !!"
        content.categoryIdentifier = "timerCategory"
        
        //3) Create trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        //4) Package everything into request
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        
        //5) Schedule notification
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil{
                print("Error : \(error)")
            }
        }
        
        
    }
    
    @IBAction func addTextActionNotification(_ sender: Any) {
        
    }
}

