//
//  Interstitial.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/12/23.
//

import SwiftUI
import GoogleMobileAds
import UIKit
    
#if DEBUG
let adUnitID = "ca-app-pub-3940256099942544/4411468910"
#else
let adUnitID = "ca-app-pub-3940256099942544/4411468910"
#endif

final class Interstitial: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    
    override init() {
        super.init()
        loadInterstitial()
    }
    
    func loadInterstitial(){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:adUnitID,
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
                              print("Failed to load interstitial ad: \(error.localizedDescription)")
                              return
                            }
                            interstitial = ad
                            interstitial?.fullScreenContentDelegate = self
                          }
        )
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        //loadInterstitial()
    }
    
    func showAd(){
        let root = UIApplication.shared.windows.first?.rootViewController
        interstitial?.present(fromRootViewController: root!)
    }
}
