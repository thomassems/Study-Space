//
//  LibraryAddView.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import SwiftUI
import UniformTypeIdentifiers

struct LibraryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: LibraryViewModel
    @State private var title = ""
    @State private var author = ""
    @State private var fileName = ""
    @State private var coverImageUrl = ""
    @State private var pdfFileURL: URL?
    @State private var showingFilePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                TextField("Cover Image URL", text: $coverImageUrl)
                
                Button("Select PDF File") {
                    showingFilePicker = true
                }
                
                if let url = pdfFileURL {
                    Text("Selected file: \(url.lastPathComponent)")
                }
            }
            .navigationTitle("Add Book")
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Save") {
                    if let url = pdfFileURL {
                        let newBook = Book(
                            title: title,
                            fileName: fileName,
                            author: author,
                            coverImageUrl: URL(string: coverImageUrl),
                            pdfUrl: url
                        )
                        viewModel.addBook(newBook)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                    .disabled(title.isEmpty || author.isEmpty || pdfFileURL == nil)
            )
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [UTType.pdf],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                pdfFileURL = selectedFile
            } catch {
                print("Error selecting file: \(error.localizedDescription)")
            }
        }
    }
}
