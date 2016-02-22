//
//  AppDelegate.swift
//  Snapchat
//
//  Created by Nick on 2016-01-26.
//  Copyright © 2016 Nicholas Ivanecky. All rights reserved.
//

import UIKit
import Bolts
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initialize Parse.
        Parse.setApplicationId("mn9WVV56sz6tuK5kCuXS0Nlh5TRHMtpdHKbMRKl1",
            clientKey: "OQKPzfEphpdOgXeXV5AchYjwBxhXBEtnTMT0oYAD")
        
        
        customizeAppearance()
        
        //register for Parse Push Notification
        let userNotificatonTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificatonTypes, categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        return true
    }
    
    func customizeAppearance() {
        let tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        window!.tintColor = tintColor
    }

    //MARK: - Parse Push Notifications
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackground()
    }
    
    // handle the push notifications
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print ("push notifications are not supported in the ios simulator")
        } else {
            print ("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //PFPush.handlePush(userInfo)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadMessages", object: nil)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        let tabBarController = self.window?.rootViewController as! UITabBarController
        let navigationController = tabBarController.viewControllers?.first as! UINavigationController
        let inboxViewController = navigationController.viewControllers.first as! InboxViewController
        let numberOfMessages = inboxViewController.messages.count
        UIApplication.sharedApplication().applicationIconBadgeNumber = numberOfMessages
        
    }

}













