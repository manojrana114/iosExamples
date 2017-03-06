//
//  AppDelegate.swift
//  UNNotificationDemo
//
//  Created by Manoj pratap singh rana on 06/03/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

import UIKit
import UserNotifications
//1 Registration
//2 Content creation
//3 Trigger Notification(Push, TimeInterval, Calendar and Location)
//4 Schedule Notification



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Set up to configure notifications
        
        //a) Request Authorization and enable/disable features on basis of status.This is needed for both Local and Remote notification
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.badge,.sound]){ (granted, error) in
            //Completion handler called if user Authorize app to notify user
            if granted
            {
            //Enable feature
                print("Authorized  : \(granted)");
            }else
            {
            //Disable notification based feature
            }
            
        };
        
        //b We can set category for the notification. We use to associate custom action with notfication and defines how that notification needs to be handled
        
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
        
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

