//
//  DetectedObject.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import Foundation

struct DetectedObject: Identifiable {
    var id = UUID()
    let objectName: String
    let confidence: Float
    
    var firstObjectName: String {
        let objectNameArray = objectName.components(separatedBy:", ")
        return objectNameArray.first ?? objectName
    }
    
    var roundedConfidencePercentage: String {
        let confidencePercentage = confidence * 100
        return String(format: "%0.0f", confidencePercentage) + "%"
    }
}
