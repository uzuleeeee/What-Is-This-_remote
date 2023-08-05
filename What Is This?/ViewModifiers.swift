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
            .padding(.horizontal)
            .background(isDisabled ? .gray : .blue)
            .foregroundColor(.white)
            .cornerRadius(50)
    }
}
