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
    let offsets = [-30, -15, 0]

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

    // MARK: Information
    
    func areNotificationsOnForShow(_ show: Show) -> Bool {
        for offset in offsets {
            let id = getNotificationIDFrom(showID: show.id, notificationOffset: offset)
            if UserDefaults.standard.bool(forKey: "\(id)-notificationToggle") {
                return true
            }
        }
        return false
    }
    
    func areNotificationsOnForShow(_ show: Show, withOffset offset: Int) -> Bool {
        let id = getNotificationIDFrom(showID: show.id, notificationOffset: offset)
        if UserDefaults.standard.bool(forKey: "\(id)-notificationToggle") {
            return true
        }
        return false
    }
    
    func totalNotificationsOnForSchedule(_ schedule: Schedule) -> Int {
        var notificationCount = 0
        for day in [schedule.sunday, schedule.monday, schedule.tuesday, schedule.wednesday, schedule.thursday, schedule.friday, schedule.saturday] {
            for show in day {
                if areNotificationsOnForShow(show) {
                    notificationCount += 1
                }
            }
        }
        return notificationCount
    }
    
    func dateOfNextNotificationForShow(_ show: Show) -> Date? {
        for offset in offsets {
            if areNotificationsOnForShow(show, withOffset: offset) {
                let nextShowDate = show.getNextDateOfShow()
                let notificationDate = Calendar(identifier: .gregorian).date(byAdding: DateComponents(minute: offset), to: nextShowDate)!
                return notificationDate
            }
        }

        return nil
    }
    
    func datesOfWeeklyNotificationsForShow(_ show: Show) -> [Date]? {
        var dates = [Date]()
        
        for offset in offsets {
            if areNotificationsOnForShow(show, withOffset: offset) {
                let nextShowDate = show.getNextDateOfShow()
                let notificationDate = Calendar(identifier: .gregorian).date(byAdding: DateComponents(minute: offset), to: nextShowDate)!
                dates.append(notificationDate)
            }
        }
        
        if dates.count > 0 {
            return dates
        }
        return nil
    }

    // MARK: Add, Remove, Update Notifications
    func addNotificationForShow(_ show: Show, withOffset offset: Int) {
        if !initialized {
            NotificationManager.sharedInstance.requestNotificationPermission(application: UIApplication.shared)
            initialized = true
        }

        if !NotificationManager.sharedInstance.areNotificationsOnForShow(show, withOffset: offset) {
            let body = offset == 0 ? "\(show.title) is on right now!" : "\(show.title) is on in \(abs(offset)) minutes!"
            let id = getNotificationIDFrom(showID: show.id, notificationOffset: offset)
            let calendar = Calendar(identifier: .gregorian)
            let notificationDate = calendar.date(byAdding: DateComponents(minute: offset), to: show.getNextDateOfShow())!
            
            if #available(iOS 10.0, *) {
                let current = UNUserNotificationCenter.current()
                var notificationOffset = DateComponents()
                notificationOffset.minute = offset
                
                let notificationTime = calendar.dateComponents([.hour, .minute, .timeZone, .day, .month], from: notificationDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime,
                                                            repeats: true)
                
                let content = UNMutableNotificationContent()
                content.title = "UCLA Radio"
                content.body = body
                content.sound = UNNotificationSound.default()
                
                let request = UNNotificationRequest(identifier: id,
                                                    content: content,
                                                    trigger: trigger)
                
                current.add(request)
            } else {
                let app = UIApplication.shared
                
                let notification = UILocalNotification()
                
                notification.alertBody = body
                notification.userInfo = ["id": id] // Convert to string to stay consistant with identifier in iOS, which has to be string
                
                notification.fireDate = notificationDate
                notification.repeatInterval = .weekOfYear
                notification.repeatCalendar = calendar
                notification.soundName = UILocalNotificationDefaultSoundName;
                
                app.scheduleLocalNotification(notification)
            }
            UserDefaults.standard.set(true, forKey: id + "-notificationToggle")
        }
    }
    
    func removeNotificationForShow(_ show: Show, withOffset offset: Int) {
        if self.areNotificationsOnForShow(show, withOffset: offset) {
            let id = getNotificationIDFrom(showID: show.id, notificationOffset: offset)

            if #available(iOS 10.0, *) {
                let current = UNUserNotificationCenter.current()
                current.removePendingNotificationRequests(withIdentifiers: [id])
            } else {
                let app = UIApplication.shared
                if let scheduledNotifications = app.scheduledLocalNotifications {
                    for notification in scheduledNotifications {
                        if let userInfoCurrent = notification.userInfo as? [String:String] {
                            let identifier = userInfoCurrent["id"]
                            if identifier == id {
                                app.cancelLocalNotification(notification)
                                break
                            }
                        }
                    }
                }
            }
            UserDefaults.standard.set(false, forKey: id + "-notificationToggle")
        }
    }
    
    func removeAllNotificationsForShow(_ show: Show) {
        for offset in offsets {
            if areNotificationsOnForShow(show, withOffset: offset) {
                removeNotificationForShow(show, withOffset: offset)
            }
        }
    }

    func removeAllNotificationsForShows(_ shows: [Show]) {
        for show in shows {
            removeAllNotificationsForShow(show)
        }
    }
    
    func updateNotificationsForNewSchedule(_ schedule: Schedule) {
        // Check hidden shows, and reenable notifications if it's been unhidden
        if let hiddenShows = UserDefaults.standard.array(forKey: "HiddenShows") as? [String] {
            for id in hiddenShows {
                if let idComponents = convertNotificationIDIntoComponents(id),
                    let show = schedule.showWithID(idComponents.showID) {
                    addNotificationForShow(show, withOffset: idComponents.notificationOffset)
                }
            }
        }
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            
            // Check pending notifications and remove them if no longer in the schedule
            // Also note these removed shows with notifications in "HiddenShows" for reenabling later
            current.getPendingNotificationRequests() { (requests) in
                var canceledShows: [String] = []
                for request in requests {
                    if let idComponents = self.convertNotificationIDIntoComponents(request.identifier) {
                        if schedule.showWithID(idComponents.showID) == nil {
                            canceledShows.append(request.identifier)
                        }
                    } else { // Remove any requests that aren't in our format because that's weird
                        current.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    }
                }
                
                current.removePendingNotificationRequests(withIdentifiers: canceledShows)
                let hiddenShows: [String] = UserDefaults.standard.array(forKey: "HiddenShows") as? [String] ?? []
                UserDefaults.standard.set(hiddenShows + canceledShows, forKey: "HiddenShows")
            }
        } else { // <= iOS 9
            let app = UIApplication.shared
            
            // Check pending notifications and remove them if no longer in the schedule
            // Also note these removed shows with notifications in "HiddenShows" for reenabling later
            if let scheduledNotifications = app.scheduledLocalNotifications {
                var canceledShows: [String] = []
                for notification in scheduledNotifications {
                    if let userInfoCurrent = notification.userInfo as? [String:String],
                        let identifier = userInfoCurrent["id"],
                        let idComponents = convertNotificationIDIntoComponents(identifier) {
                        if schedule.showWithID(idComponents.showID) == nil {
                            app.cancelLocalNotification(notification)
                            canceledShows.append(identifier)
                        }
                    }
                }
                let hiddenShows: [String] = UserDefaults.standard.array(forKey: "HiddenShows") as? [String] ?? []
                UserDefaults.standard.set(hiddenShows + canceledShows, forKey: "HiddenShows")
            }
            
        }
    }

    
    // MARK: Helper Functions
    
    private func convertNotificationIDIntoComponents(_ id: String) -> (showID: Int, notificationOffset: Int)? {
        let token = id.components(separatedBy: "-")
        if token.count == 2 {
            if let showID = Int(token[0]),
                let absNotificationOffset = Int(token[1]) {
                return (showID, -1 * absNotificationOffset)
            }
        }
        return nil
    }
    
    private func getNotificationIDFrom(showID: Int, notificationOffset: Int) -> String {
        return "\(showID)-\(abs(notificationOffset))"
    }
}
