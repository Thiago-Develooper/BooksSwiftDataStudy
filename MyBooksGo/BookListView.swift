//
//  ContentView.swift
//  MyBooksGo
//
//  Created by Thiago Menezes on 07/03/24.
//

import SwiftUI
import SwiftData

struct BookListView: View {
    
    @Query(sort: \Book.title) private var books: [Book]
    @State private var createNewBook = false
    
    var body: some View {
        NavigationStack {
            Group {
                if books.isEmpty {
                    contentUnhavailable()
                } else {
                    BooksListComponent()
                }
            }
            .navigationTitle("My Books")
            .toolbar {
                btnNewBook()
            }
            .sheet(isPresented: $createNewBook) {
                NewBookView()
                    .presentationDetents([.medium])
            }
        }
    }
    
    @ViewBuilder
    func btnNewBook() -> some View {
        Button {
            self.createNewBook = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
        }
    }
    
    @ViewBuilder func contentUnhavailable() -> some View {
        ContentUnavailableView("Enter yout fist book.", systemImage: "book.fill")
    }
}

#Preview {
    BookListView()
        .modelContainer(for: Book.self, inMemory: true)
    //Por padrão o parametro inMemory é igual a false, o que será que ele faz quando o marcamos como true?
}

//MARK: - Célula indivídual de cada item da lista da BooksListComponent
struct BookListCell: View {
    
    @State var book: Book
    
    var body: some View {
        HStack(spacing: 10) {
            book.icon
            
            VStack(alignment: .leading) {
                Text(book.title).font(.title2)
                Text(book.author).foregroundStyle(.secondary)
                
                //MARK: Classificação por estrelas
                if let rating = book.rating {
                    HStack {
                        ForEach(0..<rating, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .imageScale(.small)
                                .foregroundStyle(.yellow)
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Lista de livros exibida na View principal do app
struct BooksListComponent: View {
    
    @Environment(\.modelContext) private var context
    @Query(sort: \Book.title) private var books: [Book]

    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink {
                    //MARK: Conteúdo da navigationLink
                    EditBookView(book: book)
                } label: {
                    BookListCell(book: book)
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                        let book = books[index]
                    context.delete(book)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    let preview = Preview()
    preview.addExamples(Book.sampleBooks)
    return BookListView()
        .modelContainer(preview.container)
}
