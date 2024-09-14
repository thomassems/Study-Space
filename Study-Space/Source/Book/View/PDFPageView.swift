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
    let pdfDocument: PDFDocument
    let pageIndex: Int
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.displayMode = .singlePage
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
        if let page = pdfDocument.page(at: pageIndex) {
            uiView.go(to: page)
        }
    }
}
