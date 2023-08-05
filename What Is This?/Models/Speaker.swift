//
//  Speaker.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/5/23.
//

import Foundation
import AVFoundation

struct Speaker {
    let synthesizer = AVSpeechSynthesizer()
    
    func Say(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        synthesizer.speak(utterance)
    }
}
