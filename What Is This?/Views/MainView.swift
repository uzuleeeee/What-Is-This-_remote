//
//  ContentView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    @StateObject var cameraViewModel = CameraViewModel()
    
    @State private var isShowingObjectTextView = false
    
    var body: some View {
        ZStack {
            CameraView(cameraViewModel: cameraViewModel)
                .edgesIgnoringSafeArea(.bottom)
            
            VStack {
                BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716") // Replace with real ID
                
                Spacer()
                
                Button ("What is this?") {
                    isShowingObjectTextView.toggle()
                    if (isShowingObjectTextView) {
                        cameraViewModel.stopSession()
                    }
                }
                .disabled(cameraViewModel.isBelowThreshold)
                .buttonStyle(BlueRoundedButtonStyle(isDisabled: cameraViewModel.isBelowThreshold))
                .sheet(isPresented: $isShowingObjectTextView) {
                    ObjectView(cameraViewModel: cameraViewModel)
                        .presentationDetents([.fraction(0.3), .fraction(1)])
                        .presentationDragIndicator(.visible)
                        .persistentSystemOverlays(.hidden)
                }
                .onChange(of: isShowingObjectTextView) { state in
                    if (state == false) {
                        cameraViewModel.resumeSession()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
