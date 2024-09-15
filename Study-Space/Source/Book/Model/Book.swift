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
    let fileName: String
    let author: String
    let coverImageName: String?
    let pdfUrl: URL
    var lastReadDate: Date?
    var isFavorite: Bool
    
    init(id: UUID = UUID(), title: String, fileName: String, author: String, coverImageName: String? = nil, pdfUrl: URL, lastReadDate: Date? = nil, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.fileName = fileName
        self.author = author
        self.coverImageName = coverImageName
        self.pdfUrl = pdfUrl
        self.lastReadDate = lastReadDate
        self.isFavorite = isFavorite
    }
}

// MARK: - Sample Data
extension Book {
    static var samples: [Book] = [
        Book(title: "Introduction to Physics", fileName: "phys", author: "John Doe", coverImageName: "phys_cvr.png", pdfUrl: URL(string: "https://example.com/physics.pdf")!, lastReadDate: Date().addingTimeInterval(-86400)),
        Book(title: "Chemistry I", fileName: "chem", author: "Jane Smith", coverImageName: "chem_cvr.png", pdfUrl: URL(string: "https://example.com/chemistry.pdf")!, lastReadDate: Date().addingTimeInterval(-172800), isFavorite: true),
        Book(title: "Calculus Made Easy", fileName: "math", author: "Alex Johnson", coverImageName: "math_cvr.png", pdfUrl: URL(string: "https://example.com/calculus.pdf")!, isFavorite: true),
    ]
}
