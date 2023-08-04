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
    
    var loopingArray = LoopingArray(length: 14)
    let threshold: Float = 0.1
    
    @Published var currentObject = DetectedObject(objectName: "Default", confidence: 0.0)
    
    func startSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))

        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }

        setupObjectDetection()
    }
    
    func resumeSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
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
                let newObject = DetectedObject(objectName: topResult.identifier, confidence: topResult.confidence)
                self.loopingArray.add(newObject: newObject)
                DispatchQueue.main.async { // Switch to the main thread
                    self.currentObject = self.loopingArray.mostFrequentObject()
                }
            }
        }

        requests = [request]
    }
    
    var isBelowThreshold: Bool {
        return currentObject.confidence < threshold
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
