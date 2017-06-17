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

// NOTIFICATION MANAGEMENT: We can access pending and delivered notification: IS used to remove or update notification(see viewcontroller for code)
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        
        //Steps configure notifications
        
        //1) Registration /Request Authorization.Needed for both Local and Remote notification
        center.requestAuthorization(options: [.alert,.badge,.sound]){ (granted, error) in
            if granted{
                //Enable feature
                print("Authorized  : \(granted)")
                
                //a) Part of registration process  for remoter notification
                application.registerForRemoteNotifications();
            }else{
                    //Disable notification based feature
                }};
        
        // TO handle case when user enable/disable notifications from seting
        self.enableNotificationDependentFeature()

        // 2) Content Creation
        let content = UNMutableNotificationContent()
        content.title = "Notificatio demo"
        content.subtitle = "Time based notification"
        content.body = "My first notification"
        //NOTE : Required to get callbacks in handler methods
        center.delegate = self
        
        
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
    
    // MARK:UNUserNotificationDelegate : Notification handling ,We needs to set notification center delagate.
    //These will be called for both Remote and Local notificaton

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handling notification when app is in Foreground
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle user respose(Actionable notification)
        print(response)
        completionHandler()
    }
    
    //MARK: Remote notification handling method
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
        //Send tokem to server.....
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail to register device token")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
}

