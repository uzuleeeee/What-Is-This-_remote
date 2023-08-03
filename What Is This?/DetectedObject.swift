//
//  DetectedObject.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import Foundation

struct DetectedObject: Equatable {
    let objectName: String
    let confidence: Float
    
    var displayText: String {
        let confidencePercentage = confidence * 100
        let roundedConfidencePercentage = String(format: "%0.0f", confidencePercentage)
        return "I am \(roundedConfidencePercentage)% sure this is a \(objectName)"
    }
}
