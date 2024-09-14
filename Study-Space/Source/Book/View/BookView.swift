//
//  BookView.swift
//  Study-Space
//
//  Created by Mingchung Xia on 2024-09-14.
//

import Foundation
import SwiftUI
import PDFKit

struct BookView: View {
    let book: Book
    @Binding var selectedBookID: UUID?
    @State private var pdfDocument: PDFDocument?
    @State private var currentPage: Int = 0
    @State private var query: String = ""
    @State private var lockedIn = false
    
    @State private var immersiveSpaceIsShown: Bool = false
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
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
    
    var content: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                pdfContent
                    .frame(width: geometry.size.width * 1/2) // 2/3 of HStack's available width
                
                Divider()
                
                chatbot
                    .frame(width: geometry.size.width * 1/2) // 1/3 of HStack's available width
            }
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    var pdfContent: some View {
        if let document = pdfDocument {
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
                TextField("Ask a question...", text: $query)
                Button {
                    
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray5))
            )
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
                
            } label: {
                Image(systemName: "bookmark")
            }
            
            Button {
                /// Set resource of ImmersiveState.shared (string) here!
                /// CODE TO SET IMMERSIVE STATE HERE
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
