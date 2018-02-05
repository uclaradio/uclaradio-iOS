//
//  AnalyticsManager.swift
//  UCLA Radio
//
//  Created by Nathan Smith on 12/24/16.
//  Copyright © 2016 UCLA Student Media. All rights reserved.
//
import Google

class AnalyticsManager {
    
    static let sharedInstance = AnalyticsManager()
    
    func configureAtLaunch() {
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        gai?.logger.logLevel = GAILogLevel.error  // remove before app release
    }
    
    func trackPageWithValue(_ value: String) {
        // track view analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: value)
        let builder = GAIDictionaryBuilder.createScreenView()
        if let builder = builder {
            tracker?.send(builder.build() as [NSObject : AnyObject])
        }
    }
    
    
}
