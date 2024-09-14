//
//  LibraryAddView.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import SwiftUI

struct LibraryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: LibraryViewModel
    @State private var title = ""
    @State private var author = ""
    @State private var coverImageUrl = ""
    @State private var pdfUrl = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                TextField("Cover Image URL", text: $coverImageUrl)
                TextField("PDF URL", text: $pdfUrl)
            }
            .navigationTitle("Add Book")
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Save") {
                    if let url = URL(string: pdfUrl) {
                        let newBook = Book(
                            title: title,
                            author: author,
                            coverImageUrl: URL(string: coverImageUrl),
                            pdfUrl: url
                        )
                        viewModel.addBook(newBook)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(title.isEmpty || author.isEmpty || pdfUrl.isEmpty)
            )
        }
    }
}
