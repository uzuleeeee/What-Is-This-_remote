//
//  ViewModifiers.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/3/23.
//

import SwiftUI

struct BlueRoundedButtonStyle: ButtonStyle {
    var isDisabled = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(isDisabled ? .semibold : .bold)
            .font(.title)
            .padding()
            .background(isDisabled ? .gray : .blue)
            .foregroundColor(.white)
            .cornerRadius(25)
    }
}

struct BlueRoundedButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .font(.title)
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(25)
    }
}

extension View {
    func blueRoundedButtonStyle() -> some View {
        modifier(BlueRoundedButton())
    }
}
