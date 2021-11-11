//
//  TimeOutMonitor.swift
//  MonitorExtension
//
//  Created by Jimmy Ti on 5/8/21.
//

// EXTENSION: Create a DeviceActivityMonitor
// EXTENSION: Shield the Discouraged Apps

import DeviceActivity
import ManagedSettings
import Foundation
import UserNotifications
import SwiftUI
import FamilyControls

class TimeOutMonitor: DeviceActivityMonitor, NSExtensionRequestHandling {
    
    @AppStorage("shieldedApps", store: UserDefaults(suiteName: "group.com.example.timeout")) var shieldedApps = FamilyActivitySelection()
    @AppStorage("excludedApps", store: UserDefaults(suiteName: "group.com.example.timeout")) var excludedApps = FamilyActivitySelection()
    
    var context: NSExtensionContext?
    let store = ManagedSettingsStore()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        print("intervalDidStart for: \(activity.rawValue)")
        
        let store = ManagedSettingsStore()
        store.shield.applications = .none
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy<Application>.none
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        print("intervalDidEnd for: \(activity.rawValue)")
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        print("eventWillReachThresholdWarning")
        
        let notificationName = CFNotificationName("com.example.timeout.eventWillReachThresholdWarning" as CFString)
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        CFNotificationCenterPostNotification(notificationCenter, notificationName, nil, nil, true)
        
        if let context = context,
            let url = URL(string: "timeout://event-will-reach-threshold") {
            context.open(url, completionHandler: nil)
        }
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        print("eventDidReachThreshold")
        
        let store = ManagedSettingsStore()
        store.shield.applications = shieldedApps.applicationTokens.subtracting(excludedApps.applicationTokens)
        store.shield.applicationCategories = .specific(shieldedApps.categoryTokens, except: excludedApps.applicationTokens)
        
        let content = UNMutableNotificationContent()
        content.title = "Time's Up!"
        content.subtitle = "Answer questions to get more time."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        let notificationName = CFNotificationName("com.example.timeout.eventDidReachThreshold" as CFString)
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        CFNotificationCenterPostNotification(notificationCenter, notificationName, nil, nil, true)
        
        if let context = context,
            let url = URL(string: "timeout://event-did-reach-threshold") {
            context.open(url, completionHandler: nil)
        }
    }
    
    func beginRequest(with context: NSExtensionContext) {
        print("beginRequest with: \(context)")
        self.context = context
    }
}

extension FamilyActivitySelection: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
