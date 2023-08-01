//
//  CameraModel.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import Foundation
import AVFoundation

class CameraModel: ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCaptureVideoDataOutput()
    @Published var previewLayer : AVCaptureVideoPreviewLayer!
    
    func CheckCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case.authorized:
            SetUpCamera()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (authorized) in
                if (authorized) {
                    self.SetUpCamera()
                }
            }
        case .restricted:
            print("Camera Authorization: Restricted")
        case .denied:
            self.alert.toggle()
            return
        @unknown default:
            return
        }
    }
    
    func SetUpCamera() {
        self.session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        if (self.session.canAddInput(input)) {
            self.session.addInput(input)
        }
        
        if (self.session.canAddOutput(self.output)) {
            self.session.addOutput(self.output)
        }
        
        self.session.commitConfiguration()
    }
}
