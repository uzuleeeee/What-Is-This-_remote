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
    @StateObject var listener = Listener()
    
    @State private var isShowingObjectTextView = false
    
    var body: some View {
        ZStack {
            CameraView(cameraViewModel: cameraViewModel)
                .edgesIgnoringSafeArea(.bottom)
            
            VStack {
                Spacer()
                
                Button ("What is this?") {
                    ShowWhatIsThis()
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
                        listener.resetDetected()
                    }
                }
            }
        }
        .onAppear {
            listener.requestMicrophonePermission()
        }
        .onChange(of: listener.detected) { detected in
            if detected && !cameraViewModel.isBelowThreshold {
                ShowWhatIsThis()
            }
        }
    }
    
    func ShowWhatIsThis() {
        isShowingObjectTextView.toggle()
        if (isShowingObjectTextView) {
            cameraViewModel.stopSession()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
