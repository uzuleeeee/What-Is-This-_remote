//
//  ContentView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/1/23.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    @StateObject var cameraViewModel = CameraViewModel()
    
    @State private var isShowingObjectTextView = false
    
    var body: some View {
        ZStack {
            CameraView(cameraViewModel: cameraViewModel)
                .edgesIgnoringSafeArea(.bottom)
            
            VStack {
                Spacer()
                
                Button ("What is this?") {
                    isShowingObjectTextView.toggle()
                }
                .bold()
                .font(.title)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(25)
                .sheet(isPresented: $isShowingObjectTextView) {
                    ObjectTextView(object: cameraViewModel.currentObject)
                        .presentationDetents([.fraction(0.3), .fraction(1)])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
