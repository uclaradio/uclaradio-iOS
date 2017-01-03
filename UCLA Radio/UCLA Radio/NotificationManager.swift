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
        return UserDefaults.standard.bool(forKey: String(show.id) + "-notificationToggle")
    }
    
    func dateOfNextNotificationForShow(_ show: Show) -> Date? {
        if areNotificationsOnForShow(show) {
            var offset = DateComponents()
            offset.minute = -15
            let nextShowDate = show.getNextDateOfShow()
            let notificationDate = Calendar(identifier: .gregorian).date(byAdding: offset, to: nextShowDate, wrappingComponents: false)!
            return notificationDate
        }
        return nil
    }
    
    func updateNotificationsForNewSchedule(_ schedule: Schedule) {
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            
            // Check pending notifications and remove them if no longer in the schedule
            // Also note these removed shows with notifications in "HiddenShows" for reenabling later
            current.getPendingNotificationRequests() { (requests) in
                for request in requests {
                    if let id = Int(request.identifier) {
                        if schedule.containsShowWithID(id) == nil {
                            current.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                            if var hiddenShows = UserDefaults.standard.array(forKey: "HiddenShows") as? [String] {
                                hiddenShows.append(request.identifier)
                                UserDefaults.standard.set(hiddenShows, forKey: "HiddenShows")
                            }
                        }
                    }
                }
            }
        } else { // <= iOS 9
            let app = UIApplication.shared
            
            // Check pending notifications and remove them if no longer in the schedule
            // Also note these removed shows with notifications in "HiddenShows" for reenabling later
            if let scheduledNotifications = app.scheduledLocalNotifications {
                for notification in scheduledNotifications {
                    if let userInfoCurrent = notification.userInfo as? [String:String] {
                        if let identifier = userInfoCurrent["id"] {
                            if let id = Int(identifier) {
                                if schedule.containsShowWithID(id) == nil {
                                    app.cancelLocalNotification(notification)
                                    if var hiddenShows = UserDefaults.standard.array(forKey: "HiddenShows") as? [String] {
                                        hiddenShows.append(identifier)
                                        UserDefaults.standard.set(hiddenShows, forKey: "HiddenShows")
                                    }
                                }

                            }
                        }
                    }
                }
            }
            
        }
        
        // Check hidden shows, and reenable notifications if it's been unhidden
        if let hiddenShows = UserDefaults.standard.array(forKey: "HiddenShows") as? [String] {
            for showID in hiddenShows {
                if let id = Int(showID) {
                    if let show = schedule.containsShowWithID(id) {
                        toggleNotificationsForShow(show, toggle: true)
                    }
                }
            }
        }

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
                notification.userInfo = ["id": String(show.id)] // Convert to string to stay consistant with identifier in iOS, which has to be string
                
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
                        if let userInfoCurrent = notification.userInfo as? [String:String] {
                            let id = userInfoCurrent["id"]
                            if id == String(show.id) {
                                app.cancelLocalNotification(notification)
                                break
                            }
                        }
                    }
                }
            }
        }
        UserDefaults.standard.set(toggle, forKey: String(show.id) + "-notificationToggle")
    }
}
