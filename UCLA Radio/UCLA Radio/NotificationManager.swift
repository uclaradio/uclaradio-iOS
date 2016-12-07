//
//  NotificationManager.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/6/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let sharedInstance = NotificationManager()
    private init() {} // This prevents others from using the default '()' initializer for this class.
    
    func requestNotificationPermission(application: UIApplication) {
        // Configure Notifications
        // User UNUSerNotificationCenter if >= iOS 10, UIUserNotificationSettings otherwise
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    print("Yay!")
                } else {
                    print("D'oh")
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func notificationsToggledForShow(_ show: Show, isOn: Bool) {
            if #available(iOS 10.0, *) {
                let current = UNUserNotificationCenter.current()
                if isOn {
                    
                    let calendar = Calendar(identifier: .gregorian)
                    
                    var offset = DateComponents()
                    offset.minute = -15
                    let nextShowDate = show.getNextDateOfShow()
                    
                    let notificationDate = calendar.date(byAdding: offset, to: nextShowDate, wrappingComponents: false)!
                    let notificationTime = calendar.dateComponents([.hour, .minute, .timeZone, .day, .month], from: notificationDate)
                
                    let requestIdentifier = show.title
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime,
                                                                repeats: true)
                    
                    let content = UNMutableNotificationContent()
                    content.title = "UCLA Radio"
                    //content.subtitle =
                    content.body = show.title + " is on in 15 minutes!"
                    content.sound = UNNotificationSound.default()
                    
                    // For testing
                    
                    print("Notification Time: \(notificationTime)")
                
                    
                    let request = UNNotificationRequest(identifier: requestIdentifier,
                                                        content: content,
                                                        trigger: trigger)
                    
                    current.add(request)
                } else {
                    current.removePendingNotificationRequests(withIdentifiers: [show.title])
                }
                
                
            } else {
                
                let notification = UILocalNotification()
                
                notification.alertBody = show.title + " is on in 15 minutes!"
                //notification.userInfo =
                    
                  //  show.title
                
                let calendar = Calendar(calendarIdentifier: .gregorian)
                
                let notificationDate = calendar.date(byAdding: DateComponents(minute: -15), to: show.getNextDateOfShow())!
                
                
                print("Notification Date: \(notificationDate)")
                
                notification.fireDate = notificationDate
                notification.repeatInterval = .weekOfYear
                notification.repeatCalendar = Calendar.current
                notification.soundName = UILocalNotificationDefaultSoundName;
                
                if isOn {
                    UIApplication.shared.scheduleLocalNotification(notification)
                } else {
                    UIApplication.shared.cancelLocalNotification(notification)
                }
            }
        }
}
