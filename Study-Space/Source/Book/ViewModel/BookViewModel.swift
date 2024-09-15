//
//  BookViewModel.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import Foundation
import PDFKit
import Alamofire

@MainActor
final class BookViewModel: ObservableObject {
    @discardableResult
    func getBackground(textbook: String, page: Int) async -> String {
        guard let textbookText = extractTextFromPage(
            pdfFileName: textbook,
            pdfFileExtension: "pdf",
            pageNumber: page
        ) else {
            print("Fail 1")
            
            return "observatory"
        }
        
        let url = "https://4f2e-2620-101-f000-7c0-00-e16.ngrok-free.app" + "/get-background"
        let parameters: Parameters = ["pdf_content": textbookText]
        
        var background = "observatory"
        
        if textbook == "math" {
            let random = Int.random(in: 0...3)
            
            if random < 2 {
                print("study room")
                ImmersionState.shared = "study room"
            } else {
                print("lecture hall")
                ImmersionState.shared = "lecture hall"
            }
        } else if textbook == "chem" {
            let random = Int.random(in: 0...5)
            
            if random < 3 {
                print("labratory")
                ImmersionState.shared = "labratory"
            } else {
                print("field")
                ImmersionState.shared = "field"
            }
        } else {
            ImmersionState.shared = background
        }
        
//        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseData { response in
//            switch response.result {
//            case .success(let data):
//                if let json = try? JSONSerialization.jsonObject(with: data, options: []), let jsonDict = json as? [String: Any] {
//                    background = jsonDict["background_label"] as? String ?? "observatory"
//                    print("Got background: \(background)")
//                    
//                    ImmersionState.shared = background
//                    print("Background: \(background)")
//                } else {
//                    print("Fail 2")
//                }
//            case .failure(let error):
//                print("Error: \(error)")
//                print("Fail 3")
//            }
//        }
    
        return background
    }
    
    func extractTextFromPage(pdfFileName: String, pdfFileExtension: String, pageNumber: Int) -> String? {
        // Construct the URL for the PDF file in the main bundle
        guard let pdfURL = Bundle.main.url(forResource: pdfFileName, withExtension: pdfFileExtension) else {
            print("Failed to find PDF file in the bundle")
            return nil
        }
        
        // Load the PDF document
        guard let pdfDocument = PDFDocument(url: pdfURL) else {
            print("Failed to load PDF document")
            return nil
        }
        
        // Check if the page number is within the valid range
        guard pageNumber >= 0, pageNumber < pdfDocument.pageCount else {
            print("Page number out of range")
            return nil
        }
        
        // Get the specified page
        guard let page = pdfDocument.page(at: pageNumber) else {
            print("Failed to get page")
            return nil
        }
        
        print(page.string)
        
        // Extract and return the text from the page
        return page.string
    }
}
