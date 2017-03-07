//
//  AppDelegate.swift
//  UNNotificationDemo
//
//  Created by Manoj pratap singh rana on 06/03/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

import UIKit
import UserNotifications
//1. Registration / Request Authorization (Required for both Local and Remote)
//2 Content creation
//3 Trigger Notification(Push, TimeInterval, Calendar and Location)
//4 Schedule Notification



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        
        //Set up to configure notifications
        
        //1) Registration /Request Authorization.Needed for both Local and Remote notification
        center.requestAuthorization(options: [.alert,.badge,.sound]){ (granted, error) in
            if granted{
                //Enable feature
                print("Authorized  : \(granted)");
                //a) PArt of registration process  for remoter notification
                UIApplication.shared.registerForRemoteNotifications();
            }else{
            //Disable notification based feature
                
            }};
        
        // 2) Content Creation
        let content = UNUser
        
        
        /* //b We can set category for the notification. We use to associate custom action with notfication and defines how that notification needs to be handled
         
         //Category without action
         let generalCategory = UNNotificationCategory(identifier: "GENERAL", actions: [], intentIdentifiers: [], options: .customDismissAction)
         
         //Category with action
         //Note: we might add four custom action but only in banner notification are enabled user will see only Top 2 action.
         //We can also add UNTextInputNotificationAction (To take input from user as in chat applicatiom)
         //First create action
         let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION", title: "Snooze", options:.init(rawValue: 0))
         let stopAction = UNNotificationAction(identifier: "STOP_ACTION", title: "Stop", options:.foreground)
         
         let expiredCategory = UNNotificationCategory(identifier: "TIMER_EXPIRED", actions: [snoozeAction,stopAction], intentIdentifiers: [], options: .init(rawValue: 0))
         
         
         
         //3 Register category with Notificaion center
         center.setNotificationCategories([generalCategory,expiredCategory]);
         
         */
        
        
        return true
    }
    
    
    
    private func enableNotificationDependentFeature(){
        // Get authorization status
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if  settings.authorizationStatus == .authorized
            {
                //MARK : Code to enable notification dependent features
            }
        }
        
    }
    
}

