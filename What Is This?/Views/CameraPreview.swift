//
//  CameraPreview.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import SwiftUI
import AVKit

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera : CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let previewLayer = AVCaptureVideoPreviewLayer(session: camera.captureSession)
        let view = UIView(frame: UIScreen.main.bounds)
        previewLayer.frame = view.frame
        
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
