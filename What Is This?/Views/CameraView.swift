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
    @ObservedObject var cameraViewModel : CameraViewModel
    
    var body: some View {
        CameraPreview(camera: cameraViewModel)
            .ignoresSafeArea()
            .cornerRadius(25)
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(cameraViewModel: CameraViewModel())
    }
}
