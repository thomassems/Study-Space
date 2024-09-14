//
//  PDFPageView.swift
//  Study-Space
//
//  Created by Mingchung Xia on 2024-09-14.
//


import Foundation
import UIKit
import PDFKit
import SwiftUI

struct PDFPageView: UIViewRepresentable {
    let pdfDocument: PDFDocument?
    let pageIndex: Int
    @Binding var summaryText: String   // Bind the summary text to update in the main view
    @Binding var showSummaryScreen: Bool  // Bind the state to show the summary screen
    
    // Required makeUIView method for UIViewRepresentable
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.displayMode = .singlePage
        pdfView.autoScales = true
        return pdfView
    }

    // Required updateUIView method for UIViewRepresentable
    func updateUIView(_ uiView: PDFView, context: Context) {
        guard let document = pdfDocument else {
            uiView.document = nil
            return
        }
        
        uiView.document = document
        
        if pageIndex >= 0 && pageIndex < document.pageCount {
            if let page = document.page(at: pageIndex) {
                uiView.go(to: page)
                
                // Extract and log the text content of the page
                let pageText = page.string ?? "No text found"
                print("Text on page \(pageIndex):\n\(pageText)")
        
            }
        } else {
            // Optionally handle the case where the pageIndex is out of bounds
            print("Invalid pageIndex: \(pageIndex)")
        }
    }

    // Optional but can be implemented if needed
    static func dismantleUIView(_ uiView: PDFView, coordinator: Coordinator) {
        // You can perform any cleanup or resource release here when the view is dismantled.
    }
}
