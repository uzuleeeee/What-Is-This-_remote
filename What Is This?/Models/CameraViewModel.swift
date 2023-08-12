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
    private var currentImage: UIImage?
    
    var loopingArray = LoopingArray(length: 14)
    let threshold: Float = 0.1
    
    @Published var currentObject = DetectedObject(objectName: "Default", confidence: 0.0)
    @Published var alert = false
    
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
    
    func checkAuthorization() {
        print("Check auth")
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            print("not det")
            AVCaptureDevice.requestAccess(for: .video) { status in
                if (status == true) {
                    self.startSession()
                    return
                }
            }
        case .restricted:
            print("res")
            AVCaptureDevice.requestAccess(for: .video) { status in
                if (status == true) {
                    self.startSession()
                    return
                }
            }
        case .denied:
            print("den")
            print("before", alert)
            self.alert = true
            print("after", alert)
            return
        case .authorized:
            print("auth")
            self.startSession()
            return
        @unknown default:
            return
        }
    }
    
    func openSettings() {
        self.alert = false
        
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
    func analyzeImage(_ image: UIImage) {
        guard let model = try? VNCoreMLModel(for: resnetModel.model) else {
            return
        }

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            self?.processObservations(for: request, error: error)
        }

        guard let ciImage = CIImage(image: image) else {
            return
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform Vision request: \(error.localizedDescription)")
        }
    }

    private func processObservations(for request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else {
            print("Unable to classify image: \(error?.localizedDescription ?? "Error")")
            return
        }

        print("Detected object: \(topResult.identifier), Confidence: \(topResult.confidence)")
        let newObject = DetectedObject(objectName: topResult.identifier, confidence: topResult.confidence)
        DispatchQueue.main.async { // Switch to the main thread
            self.currentObject = newObject
        }
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
