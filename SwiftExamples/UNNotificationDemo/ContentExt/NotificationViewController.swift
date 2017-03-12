//
//  NotificationViewController.swift
//  ContentExt
//
//  Created by Manoj pratap singh rana on 08/03/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        self.imageView?.image = UIImage(data: try! Data(contentsOf: notification.request.content.attachments[0].url))
    }

}
