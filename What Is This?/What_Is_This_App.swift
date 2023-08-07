//
//  What_Is_This_App.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import SwiftUI
import GoogleMobileAds

@main
struct What_Is_This_App: App {
    init () {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            StartingView()
                .persistentSystemOverlays(.hidden)
                .preferredColorScheme(.dark)
        }
    }
}
