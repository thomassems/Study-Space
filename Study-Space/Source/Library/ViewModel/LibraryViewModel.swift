//
//  LibraryViewModel.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    @Published var library: Library
    
    init() {
        self.library = Library()
        fetchBooks()
    }
    
    func fetchBooks() {
        // TODO: Implement Convex backend call to fetch books
        // For now, we'll use sample data
        self.library.books = Book.samples
    }
    
    func addBook(_ book: Book) {
        // TODO: Implement Convex backend call to add a book
        library.addBook(book)
        
        // Simulating a backend call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("Book added to backend: \(book.title)")
        }
    }
    
    func toggleFavorite(for book: Book) {
        if let index = library.books.firstIndex(where: { $0.id == book.id }) {
            library.books[index].isFavorite.toggle()
            // TODO: Implement Convex backend call to update favorite status
        }
    }
    
    func updateLastReadDate(for book: Book) {
        if let index = library.books.firstIndex(where: { $0.id == book.id }) {
            library.books[index].lastReadDate = Date()
            // TODO: Implement Convex backend call to update last read date
        }
    }
}
