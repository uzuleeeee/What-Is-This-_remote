//
//  GoogleSearchView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/4/23.
//

import SwiftUI

struct GoogleSearchView: View {
    let term: String
    @Binding var isOnline: Bool
    
    var body: some View {
        VStack {
            if isOnline {
                GoogleWebView(searchTerm: term)
            } else {
                VStack(alignment: .center) {
                    Image(systemName: "wifi.slash")
                        .font(.title)
                        .padding(.bottom)
                        .foregroundColor(.red)
                    Text("No internet connection.")
                }
                .padding()
            }
        }
    }
}
