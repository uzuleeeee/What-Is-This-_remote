//
//  ObjectView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/4/23.
//

import SwiftUI
import Network

struct ObjectView: View {
    @ObservedObject var cameraViewModel : CameraViewModel
    @State private var isOnline = true
    
    var body: some View {
        VStack {
            ObjectTextView(object: cameraViewModel.currentObject)
                .padding(.top)
            GoogleSearchView(term: cameraViewModel.currentObject.firstObjectName, isOnline: $isOnline)
            
            Spacer()
        }
        .onAppear {
            checkInternetConnection()
        }
    }
    
    private func checkInternetConnection() {
        print("CHECKING INTERNET CONNECTION")
        
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        monitor.pathUpdateHandler = { path in
            isOnline = path.status == .satisfied
            print(isOnline)
        }
        
        monitor.start(queue: queue)
    }
}

func openGoogleImageSearch(term: String) {
    if let encodedSearchTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
       let searchURL = URL(string: "https://www.google.com/search?q=\(encodedSearchTerm)&tbm=isch") {
        UIApplication.shared.open(searchURL, options: [:], completionHandler: nil)
    }
}

struct ObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectView(cameraViewModel: CameraViewModel())
    }
}
