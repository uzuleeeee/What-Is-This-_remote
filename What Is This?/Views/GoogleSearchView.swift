//
//  GoogleSearchView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/4/23.
//

import SwiftUI
import Network

struct GoogleSearchView: View {
    let term: String
    @State private var isOnline = true
    
    var body: some View {
        VStack {
            if isOnline {
                GoogleWebView(searchTerm: term)
                    .navigationBarTitle(Text("Google Image Search"))
            } else {
                Text("No internet connection. Please check your Wi-Fi or mobile data settings.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            checkInternetConnection()
        }
    }
    
    private func checkInternetConnection() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        monitor.pathUpdateHandler = { path in
            isOnline = path.status == .satisfied
        }
        
        monitor.start(queue: queue)
    }
}

struct GoogleSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSearchView(term: "Apple")
    }
}
