//
//  LoadingView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/4/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            
            /*
            Text("What Is This?")
                .font(.largeTitle)
                .fontWeight(.heavy)
             */
            Image(decorative: "Icon")
                .accessibilityHidden(true)
            
            Spacer()
            Spacer()
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
