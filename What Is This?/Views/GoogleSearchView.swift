//
//  GoogleSearchView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/4/23.
//

import SwiftUI

struct GoogleSearchView: View {
    let term: String

    var body: some View {
        GoogleWebView(searchTerm: term)
            .navigationBarTitle(Text("Google Image Search"))
            .navigationBarBackButtonHidden(true)
    }
}

struct GoogleSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSearchView(term: "Banana")
    }
}
