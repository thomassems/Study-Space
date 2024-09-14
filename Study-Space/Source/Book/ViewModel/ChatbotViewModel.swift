//
//  ChatbotViewModel.swift
//  Study-Space
//
//  Created by Mingchung Xia on 2024-09-14.
//

import Foundation
import Alamofire
import PDFKit

@MainActor
final class ChatbotViewModel: ObservableObject {
    @Published var messages: [String] = []
    
    func respond(query: String, textbook: String, page: Int) async throws {
        let textbookText = extractTextFromPage(pdfFileName: textbook, pdfFileExtension: "pdf", pageNumber: page)
        
        let url = "http://127.0.0.1:8000" + "/respond"
        let parameters: Parameters = ["message": query, "textbook_content": textbookText as Any]
        
        self.messages.append(query)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseData { response in
                switch response.result {
                case .success(let data):
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []), let jsonDict = json as? [String: Any] {
                        let response = jsonDict["response"] as? String ?? "No response"
                        self.messages.append(response)
                        print("Got response: \(response)")
                    }
                    continuation.resume(returning: ())
                case .failure(let error):
                    print("Error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
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
