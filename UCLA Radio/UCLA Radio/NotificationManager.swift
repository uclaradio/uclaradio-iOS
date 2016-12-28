//
//  NotificationManager.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/6/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let sharedInstance = NotificationManager()
    
    private var initialized = false

    func requestNotificationPermission(application: UIApplication) {
        // Configure Notifications
        // User UNUserNotificationCenter if >= iOS 10, UIUserNotificationSettings otherwise

        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if !granted {
                    print("Error: Notifications not authorized by user.")
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func areNotificationsOnForShow(_ show: Show) -> Bool {
        return UserDefaults.standard.bool(forKey: String(show.id) + "-switchState")
    }
    
    func toggleNotificationsForShow(_ show: Show, toggle: Bool) {
        if !initialized {
            NotificationManager.sharedInstance.requestNotificationPermission(application: UIApplication.shared)
            initialized = true
        }

        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            if toggle {
                
                let calendar = Calendar(identifier: .gregorian)
                
                var offset = DateComponents()
                offset.minute = -15
                let nextShowDate = show.getNextDateOfShow()
                
                let notificationDate = calendar.date(byAdding: offset, to: nextShowDate, wrappingComponents: false)!
                let notificationTime = calendar.dateComponents([.hour, .minute, .timeZone, .day, .month], from: notificationDate)
            
                let requestIdentifier = String(show.id)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime,
                                                            repeats: true)
                
                let content = UNMutableNotificationContent()
                content.title = "UCLA Radio"
                //content.subtitle = // I think we're just gonna leave this blank
                content.body = show.title + " is on in 15 minutes!"
                content.sound = UNNotificationSound.default()
                
                let request = UNNotificationRequest(identifier: requestIdentifier,
                                                    content: content,
                                                    trigger: trigger)
                
                current.add(request)
            } else {
                current.removePendingNotificationRequests(withIdentifiers: [String(show.id)])
            }
        } else {
            let app = UIApplication.shared
            if toggle {
                let notification = UILocalNotification()
                
                notification.alertBody = show.title + " is on in 15 minutes!"
                notification.userInfo = ["id": show.id]
                
                //  show.title
                
                let calendar = Calendar(identifier: .gregorian)
                
                let notificationDate = calendar.date(byAdding: DateComponents(minute: -15), to: show.getNextDateOfShow())!
                
                
                print("Notification Date: \(notificationDate)")
                
                notification.fireDate = notificationDate
                notification.repeatInterval = .weekOfYear
                notification.repeatCalendar = Calendar.current
                notification.soundName = UILocalNotificationDefaultSoundName;
                
                app.scheduleLocalNotification(notification)
            } else {
                if let scheduledNotifications = app.scheduledLocalNotifications {
                    for notification in scheduledNotifications {
                        if let userInfoCurrent = notification.userInfo as? [String:Int] {
                            let id = userInfoCurrent["id"]
                            if id == show.id {
                                app.cancelLocalNotification(notification)
                                break
                            }
                        }
                    }
                }
            }
        }
        UserDefaults.standard.set(toggle, forKey: String(show.id) + "-switchState")
    }
}
