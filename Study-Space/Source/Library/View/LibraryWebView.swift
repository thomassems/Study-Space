//
//  LibraryWebView.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import SwiftUI
import WebKit
 
// MARK: UIKit View
struct LibraryWebView: UIViewRepresentable {
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        if let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest {
            mutableRequest.cachePolicy = .reloadIgnoringLocalCacheData
            webView.load(mutableRequest as URLRequest)
        }
    }
}
