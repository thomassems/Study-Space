//
//  LibraryView.swift
//  Study-Space
//
//  Created by Jared Drueco on 2024-09-14.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    @State private var showingAddBook = false
    @State private var selectedCategory: BookCategory? = .all

    enum BookCategory: String, CaseIterable {
        case recents = "Recents"
        case favorites = "Favorites"
        case all = "All"
    }
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            bookGrid
        }
    }
    
    var sidebar: some View {
        List(BookCategory.allCases, id: \.self, selection: $selectedCategory) { category in
            NavigationLink(value: category) {
                Label(category.rawValue, systemImage: iconForCategory(category))
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Library")
    }
    
    var bookGrid: some View {
        ScrollView {
            HStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 170), spacing: 100)], spacing: 100) {
                    ForEach(filteredBooks) { book in
                        LibraryBookView(book: book, isFavorite: Binding(
                            get: { book.isFavorite },
                            set: { newValue in
                                viewModel.toggleFavorite(for: book)
                            }
                        ))
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(selectedCategory?.rawValue ?? "Library")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddBook = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        // FIXME: Sheet disappears when keyboard pops up
        .sheet(isPresented: $showingAddBook) {
            LibraryAddView(viewModel: viewModel)
        }
    }
    
    var filteredBooks: [Book] {
        guard let category = selectedCategory else { return viewModel.library.books }
        switch category {
        case .recents:
            return viewModel.library.books.sorted { $0.lastReadDate ?? .distantPast > $1.lastReadDate ?? .distantPast }.prefix(5).map { $0 }
        case .favorites:
            return viewModel.library.books.filter { $0.isFavorite }
        case .all:
            return viewModel.library.books
        }
    }
    
    func iconForCategory(_ category: BookCategory) -> String {
        switch category {
        case .recents:
            return "clock"
        case .favorites:
            return "star.fill"
        case .all:
            return "books.vertical"
        }
    }
}


struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
