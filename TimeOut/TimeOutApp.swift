//
//  TimeOutApp.swift
//  TimeOut
//
//  Created by Jimmy Ti on 5/8/21.
//

import SwiftUI
import UIKit

@main
struct TimeOutApp: App {
    
    init() {
        let primaryButtonPressedNotif = "com.example.timeout.primaryButtonPressed" as CFString
        let eventWillReachThresholdNotif = "com.example.timeout.eventWillReachThresholdWarning" as CFString
        let eventDidReachThresholdNotif = "com.example.timeout.eventDidReachThreshold" as CFString
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        
        CFNotificationCenterAddObserver(notificationCenter,
                                        nil,
                                        { (
                                            center: CFNotificationCenter?,
                                            observer: UnsafeMutableRawPointer?,
                                            name: CFNotificationName?,
                                            object: UnsafeRawPointer?,
                                            userInfo: CFDictionary?
                                        ) in
            
            print("Notification name: \(String(describing: name))")
        },
                                        primaryButtonPressedNotif,
                                        nil,
                                        CFNotificationSuspensionBehavior.deliverImmediately)
        
        CFNotificationCenterAddObserver(notificationCenter,
                                        nil,
                                        { (
                                            center: CFNotificationCenter?,
                                            observer: UnsafeMutableRawPointer?,
                                            name: CFNotificationName?,
                                            object: UnsafeRawPointer?,
                                            userInfo: CFDictionary?
                                        ) in
            
            print("Notification name: \(String(describing: name))")
        },
                                        eventWillReachThresholdNotif,
                                        nil,
                                        CFNotificationSuspensionBehavior.deliverImmediately)
        
        CFNotificationCenterAddObserver(notificationCenter,
                                        nil,
                                        { (
                                            center: CFNotificationCenter?,
                                            observer: UnsafeMutableRawPointer?,
                                            name: CFNotificationName?,
                                            object: UnsafeRawPointer?,
                                            userInfo: CFDictionary?
                                        ) in
            
            print("Notification name: \(String(describing: name))")
        },
                                        eventDidReachThresholdNotif,
                                        nil,
                                        CFNotificationSuspensionBehavior.deliverImmediately)
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
