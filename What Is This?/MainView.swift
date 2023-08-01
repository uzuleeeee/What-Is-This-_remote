//
//  ContentView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    var body: some View {
        CameraView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
