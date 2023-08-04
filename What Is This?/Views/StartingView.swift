//
//  StartingView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/4/23.
//

import SwiftUI

struct StartingView: View {
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
            } else {
                MainView()
            }
        }
        .persistentSystemOverlays(.hidden)
        .onAppear {
            // Simulate a loading delay (e.g., 2 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isLoading = false
                }
            }
        }
    }
}

struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView()
    }
}
