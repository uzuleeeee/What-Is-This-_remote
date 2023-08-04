//
//  LoopingArray.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/4/23.
//

import Foundation
import SwiftUI

struct LoopingArray: CustomStringConvertible {
    var lastestObjects: [DetectedObject] = []
    var objectCountDictionary: [String: Int] = [:]
    let length: Int
    var front = 0
    
    var description: String {
        var output = ""
        
        for object in lastestObjects {
            output.append("\(object.firstObjectName) : \(object.roundedConfidencePercentage), ")
        }
        
        return output
    }
    
    init(backingArray: [DetectedObject] = [], length: Int, front: Int = 0) {
        self.lastestObjects = Array(repeating: DetectedObject(objectName: "", confidence: 0.0), count: length)
        self.length = length
        self.front = front
    }
    
    mutating func add(newObject: DetectedObject) {
        let oldObjectName = lastestObjects[front].firstObjectName
        lastestObjects[front] = newObject
        front = (front + 1) % length
        
        objectCountDictionary[newObject.firstObjectName] = (objectCountDictionary[newObject.firstObjectName] ?? 0) + 1
        let removedObjectCount = objectCountDictionary[oldObjectName] ?? 1
        if removedObjectCount == 1 {
            objectCountDictionary.removeValue(forKey: oldObjectName)
        } else {
            objectCountDictionary[oldObjectName] = (removedObjectCount) - 1
        }
    }
    
    func mostFrequentObject() -> DetectedObject {
        let maxValue = objectCountDictionary.values.max()
        let maxKey = objectCountDictionary.first(where: { $0.value == maxValue })?.key ?? ""
        let averageConfidence = averageConfidence(objectName: maxKey)
        
        return DetectedObject(objectName: maxKey, confidence: averageConfidence)
    }
    
    func averageConfidence(objectName: String) -> Float {
        var totalConfidence: Float = 0.0
        var objectCount: Int = 0
        
        for currentObject in lastestObjects {
            if currentObject.firstObjectName == objectName {
                totalConfidence += currentObject.confidence
                objectCount += 1
            }
        }
        
        return totalConfidence / Float(objectCount)
    }
}
