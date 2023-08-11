//
//  ObjectTextView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/3/23.
//

import SwiftUI

struct ObjectTextView: View {
    var object : DetectedObject
    
    var body: some View {
        let name = object.firstObjectName
        let roundedConfidencePercentage = object.roundedConfidencePercentage
        
        VStack {
            HStack {
                Text("I am")
                Text("\(roundedConfidencePercentage)")
                    .font(.title3)
                    .bold()
                Text("sure this is a")
            }
            
            Text(name)
                .font(.largeTitle)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .background(.background)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(object.fullText)
    }
}

struct ObjectTextView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectTextView(object: DetectedObject(objectName: "Border Collie", confidence: 0.5677))
            .previewLayout(.sizeThatFits)
    }
}
