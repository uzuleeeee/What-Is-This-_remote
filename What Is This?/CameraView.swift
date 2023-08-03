//
//  SecondPage.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import SwiftUI
import AVFoundation

import SwiftUI
import AVKit

struct CameraView: View {
    @ObservedObject var cameraViewModel = CameraViewModel()
    var body: some View {
        ZStack {
            CameraPreview(camera: cameraViewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text(cameraViewModel.currentObject.displayText)
                    .padding()
                    .font(.largeTitle)
            }
        }
        .onAppear {
            cameraViewModel.startSession()
        }
        .onDisappear {
            cameraViewModel.stopSession()
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
