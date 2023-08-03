//
//  ViewModifiers.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/3/23.
//

import SwiftUI

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
