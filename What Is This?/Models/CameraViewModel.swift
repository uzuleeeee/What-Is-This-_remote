//
//  CameraViewModel.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import SwiftUI
import AVKit
import CoreML
import Vision

class CameraViewModel: NSObject, ObservableObject {
    var captureSession = AVCaptureSession()
    var requests = [VNRequest]()
    let resnetModel = Resnet50()
    
    @Published var currentObject = DetectedObject(objectName: "Default", confidence: 0.0)
    
    func startSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
            captureSession.startRunning()
        }

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))

        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }

        setupObjectDetection()
    }

    func stopSession() {
        captureSession.stopRunning()
    }

    private func setupObjectDetection() {
        guard let model = try? VNCoreMLModel(for: resnetModel.model) else {
            return
        }

        let request = VNCoreMLRequest(model: model) { (request, error) in
            if let results = request.results as? [VNClassificationObservation],
               let topResult = results.first {
                // Process the object detection results here
                print(topResult.identifier, topResult.confidence)
                let newObject = DetectedObject(objectName: topResult.identifier, confidence: topResult.confidence)
                self.currentObject = newObject
            }
        }

        requests = [request]
    }
}

extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print(error)
        }
    }
}
