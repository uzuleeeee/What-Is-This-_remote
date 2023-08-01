//
//  SecondPage.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject var camera = CameraModel()
    
    var body: some View {
        CameraPreview(camera: camera)
            .onAppear {
                camera.CheckCameraAuthorization()
            }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.previewLayer = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.previewLayer.frame = view.frame
        
        camera.previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.previewLayer)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
