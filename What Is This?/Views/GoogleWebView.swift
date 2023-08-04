//
//  GoogleWebView.swift
//  What Is This?
//
//  Created by Mac-aroni on 8/4/23.
//

import SwiftUI
import WebKit

struct GoogleWebView: UIViewRepresentable {
    let searchTerm: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let searchURL = URL(string: "https://www.google.com/search?q=\(encodedSearchTerm)&tbm=isch") {
            let request = URLRequest(url: searchURL)
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        // You can implement WKNavigationDelegate methods here if needed.
    }
}
