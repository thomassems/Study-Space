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
//import Alamofire

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
                summarizeTextWithCohere(extractedText: pageText)
            }
        } else {
            // Optionally handle the case where the pageIndex is out of bounds
            print("Invalid pageIndex: \(pageIndex)")
        }
    }
//    func sendExtractedTextWithAlamofire(pageText: String, pageNumber: Int) {
//        // Define the API endpoint
//        let url = "http://localhost:8080/upload-pdf-text" // Or your remote server URL
//
//        // Create the parameters
//        let parameters: [String: Any] = [
//            "page": pageNumber,
//            "text": pageText
//        ]
//
//        // Send the POST request using Alamofire
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                switch response.result {
//                case .success(let data):
//                    // Handle success
//                    print("Success! Data received: \(data)")
//                case .failure(let error):
//                    // Handle error
//                    print("Request failed with error: \(error)")
//                }
//            }
//    }
   
    // Function to send extracted text to Cohere API for summarization
    func summarizeTextWithCohere(extractedText: String) {
        // Uncomment if adding API key to config file
//        guard let apiKey = Bundle.main.infoDictionary?["COHERE_API_KEY"] as? String else {
//                print("API Key not found")
//                return
//            }
        // Cohere API endpoint for summarization
        let url = URL(string: "https://api.cohere.ai/v1/summarize")!
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // add API key following `Bearer`
        request.setValue("Bearer ", forHTTPHeaderField: "Authorization")
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization") // Replace with your API key
        
        // Create the request body
        let payload: [String: Any] = [
            "text": extractedText,   // Text to be summarized
            "length": "medium"       // You can use "short", "medium", or "long"
        ]
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = requestBody
        } catch {
            print("Error creating JSON request body: \(error)")
            return
        }
        
        // Perform the API request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error in API request: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from API")
                return
            }
            
            // Handle the API response
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Cohere Summarization API Response: \(jsonResponse)")
                    
                    // Parse the summarized text
                    if let summary = jsonResponse["summary"] as? String {
                        print("Summary: \(summary)")
                    } else {
                        print("No summary found in the response.")
                    }
                }
            } catch {
                print("Error parsing API response: \(error)")
            }
        }
        
        // Start the task
        task.resume()
    }


}


