//
//  Book.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import Foundation

struct Book: Identifiable {
    let id: UUID
    let title: String
    let author: String
    let coverImageUrl: URL?
    let pdfUrl: URL
    var lastReadDate: Date?
    var isFavorite: Bool
    
    init(id: UUID = UUID(), title: String, author: String, coverImageUrl: URL? = nil, pdfUrl: URL, lastReadDate: Date? = nil, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.author = author
        self.coverImageUrl = coverImageUrl
        self.pdfUrl = pdfUrl
        self.lastReadDate = lastReadDate
        self.isFavorite = isFavorite
    }
}

// MARK: - Sample Data
extension Book {
    static var samples: [Book] = [
        Book(title: "Introduction to Physics", author: "John Doe", coverImageUrl: URL(string: "https://example.com/physics_cover.jpg"), pdfUrl: URL(string: "https://example.com/physics.pdf")!, lastReadDate: Date().addingTimeInterval(-86400), isFavorite: true),
        Book(title: "Organic Chemistry", author: "Jane Smith", coverImageUrl: URL(string: "https://example.com/chemistry_cover.jpg"), pdfUrl: URL(string: "https://example.com/chemistry.pdf")!, lastReadDate: Date().addingTimeInterval(-172800)),
        Book(title: "Calculus Made Easy", author: "Alex Johnson", coverImageUrl: URL(string: "https://example.com/calculus_cover.jpg"), pdfUrl: URL(string: "https://example.com/calculus.pdf")!, isFavorite: true),
    ]
}
