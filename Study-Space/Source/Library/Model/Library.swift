//
//  Library.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import Foundation

struct Library {
    var books: [Book]
    
    init(books: [Book] = []) {
        self.books = books
    }
    
    mutating func addBook(_ book: Book) {
        books.append(book)
    }
    
    mutating func removeBook(at index: Int) {
        books.remove(at: index)
    }
}
