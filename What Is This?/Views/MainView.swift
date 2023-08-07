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
        .alert(isPresented: $cameraViewModel.alert) {
            Alert(
                title: Text("Camera Access Denied"),
                message: Text("Please enable camera access in Settings to use this feature."),
                primaryButton: .destructive(Text("Dismiss")),
                secondaryButton: .default(Text("Open Settings"), action: {
                    cameraViewModel.openSettings()
                })
            )
        }
        .onAppear {
            cameraViewModel.checkAuthorization()
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                // This closure will be called when the app is about to enter the foreground.
                // You can put your code here to handle the event.
                print("App is returning to foreground")
                cameraViewModel.checkAuthorization()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
