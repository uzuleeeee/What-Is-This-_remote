//
//  ObjectView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/4/23.
//

import SwiftUI

struct ObjectView: View {
    @ObservedObject var cameraViewModel : CameraViewModel
    
    var body: some View {
        VStack {
            ObjectTextView(object: cameraViewModel.currentObject)
            GoogleWebView(searchTerm: cameraViewModel.currentObject.firstObjectName)
        }
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
