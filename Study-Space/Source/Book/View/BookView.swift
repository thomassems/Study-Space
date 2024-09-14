//
//  BookView.swift
//  Study-Space
//
//  Created by Mingchung Xia on 2024-09-14.
//

import Foundation
import SwiftUI
import PDFKit

import SwiftUI
import PDFKit

struct BookView: View {
    let book: Book
    @Binding var selectedBookID: UUID?
    @State private var pdfDocument: PDFDocument?
    @State private var currentPage: Int = 0
    @State private var summaryText: String = "Waiting for summary..." // State to hold summary text
    @State private var showSummaryScreen = false // Toggle to navigate to the summary screen
    @State private var query: String = ""
    @State private var lockedIn = false

    @State private var immersiveSpaceIsShown: Bool = false
    @Environment(\.openWindow) var openWindow
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        NavigationStack {
            VStack {
                content
                footerInfo
                buttons
            }
            .onAppear(perform: loadPDF)
            .onChange(of: lockedIn) { _, newValue in
                Task {
                    if newValue {
                        switch await openImmersiveSpace(id: "ImmersiveSpace") {
                        case .opened:
                            immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            lockedIn = false
                        }
                    } else if immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                        immersiveSpaceIsShown = false
                    }
                }
            }
        }
    }

    var content: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                pdfContent
                    .frame(width: geometry.size.width * 2 / 3) // 2/3 of the total width

                Divider()

                chatbot
                    .frame(width: geometry.size.width * 1 / 3) // 1/3 of the total width
            }
        }
        .padding(.bottom)
    }

    @ViewBuilder
    var pdfContent: some View {
        if let document = pdfDocument {
            // Pass summaryText binding to PDFPageView
            PDFPageView(pdfDocument: document, pageIndex: currentPage)
                .ignoresSafeArea(.all)
                .background(.white)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            withAnimation {
                                if value.translation.width < 0 {
                                    nextPage()
                                } else if value.translation.width > 0 {
                                    previousPage()
                                }
                            }
                        }
                )
                .overlay(alignment: .topLeading) {
                    Button {
                        withAnimation {
                            selectedBookID = nil
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                    .padding()
                }
        } else {
            Text("Loading PDF...")
        }
    }

    var chatbot: some View {
        VStack {
            // Chat content

            Spacer()

            HStack {
                HStack {
                    TextField("Ask a question...", text: $query)

                    Button {
                        // Handle any chatbot logic here
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray5))
                )

                Button {
                    // Activate voiceflow or another chat API
                } label: {
                    Image(systemName: "mic")
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }

    var footerInfo: some View {
        VStack {
            HStack {
                Text("Page \(currentPage + 1) of \(pdfDocument?.pageCount ?? 1)")
                    .font(.caption2)

                Spacer()

                Text("Algorithms by Author1, Author2...")
                    .font(.caption2)
            }
            .padding(.horizontal)

            Divider()
        }
    }

    var buttons: some View {
        HStack {
            Button(action: previousPage) {
                Image(systemName: "chevron.left")
                    .font(.largeTitle)
            }
            .disabled(currentPage == 0)

            Spacer()

            Button {
                lockedIn.toggle()
            } label: {
                HStack {
                    Image(systemName: "person.and.background.dotted")

                    if !lockedIn {
                        Text("Lock in")
                    } else {
                        Text("Lock out")
                    }
                }
            }

            Button {
                summarizeTextWithCohere(extractedText: pdfDocument?.page(at: currentPage)?.string ?? "")
            } label: {
                HStack {
                    Text("Summarize")
                }
            }

            Spacer()

            Button(action: nextPage) {
                Image(systemName: "chevron.right")
                    .font(.largeTitle)
            }
            .disabled(currentPage == (pdfDocument?.pageCount ?? 1) - 1)
        }
        .padding(.bottom)
        .padding(.horizontal)
    }

    private func loadPDF() {
        if let url = Bundle.main.url(forResource: "algorithms", withExtension: "pdf") {
            pdfDocument = PDFDocument(url: url)
        }
    }

    private func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }

    private func nextPage() {
        if let document = pdfDocument, currentPage < document.pageCount - 1 {
            currentPage += 1
        }
    }

    // Function to send extracted text to Cohere API for summarization
    func summarizeTextWithCohere(extractedText: String) {
        let url = URL(string: "https://api.cohere.ai/v1/summarize")!  // API endpoint

        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add your API key (make sure to store your key securely)
        let apiKey = "api_key"  // Replace with your actual API key
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        // Create the request body
        let payload: [String: Any] = [
            "text": extractedText,  // Text to be summarized
            "length": "medium"      // You can use "short", "medium", or "long"
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

                    // Parse the summarized text and update the binding
                    if let summary = jsonResponse["summary"] as? String {
                        DispatchQueue.main.async {
                            Summary.shared.text = summary   // Update the summary text
                            openWindow(id: "Summary") // Open the summary window
                        }
                    } else {
                        DispatchQueue.main.async {
                            Summary.shared.text = "No summary found."
                            openWindow(id: "Summary") // Open the summary window
                        }
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

struct Summary {
    var text: String

    static var shared: Summary = Summary(text: "fjoisjfewf")
}

struct SummaryScreen: View {
    @Environment(\.dismissWindow) var dismissWindow

    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()

                Button("Close") {
                    dismissWindow()
                }
            }

            Text("Summary")
                .font(.largeTitle)
                .padding()

            ScrollView {
                Text(Summary.shared.text)
                    .font(.body)
                    .padding()
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}

#Preview(windowStyle: .automatic) {
    BookView(
        book: Book(
            id: UUID(),
            title: "Sample Book",
            author: "John Doe",
            coverImageUrl: URL(string: "https://example.com/cover.jpg"),
            pdfUrl: Bundle.main.url(forResource: "algorithms", withExtension: "pdf")!,
            lastReadDate: Date(),
            isFavorite: false
        ),
        selectedBookID: .constant(UUID())
    )
}
