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
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.displayMode = .singlePage
        pdfView.autoScales = true
        return pdfView
    }
    
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
}


