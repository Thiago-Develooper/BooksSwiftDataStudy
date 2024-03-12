//
//  EditBookView.swift
//  MyBooksGo
//
//  Created by Thiago Menezes on 07/03/24.
//

import SwiftUI

struct EditBookView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let book: Book
    
    @State private var status = Status.onShelf
    @State private var rating: Int?
    @State private var title = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    
    @State private var fistView = true
    
    var changed: Bool {
        changedBookData()
    }
    
    var body: some View {
        
        //Status
        HStack {
            Text("Status")
            Picker("Status", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.descr).tag(status)
                }
            }
        }
        
        VStack(alignment: .leading) {
            GroupBox {
                LabeledContent {
                    DatePicker("", selection: $dateAdded, displayedComponents: .date)
                } label: {
                    Text("Date Added")
                }
                
//                if status != .onShelf { //Se não está na pratileira já foi começado um dia
                if status == .inProgress || status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
                    } label: {
                        Text("Date Added")
                    }
                }
                
                if status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateCompleted, in: dateStarted..., displayedComponents: .date)
                    } label: {
                        Text("Date Completed")
                    }
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                if !fistView {
                    setDatas(oldValue: oldValue, newValue: newValue)
                    fistView = false
                }
            }
            
            Divider()
            
            //MARK: - Dados escritos
            
            //Estrelas
            LabeledContent {
                RatingsView(maxRating: 5, currentRating: $rating, width: 30)
            } label: {
                Text("Rating")
            }
            
            LabeledContent {
                TextField("", text: $title)
            } label: {
                Text("Title").foregroundStyle(.secondary)
            }
            
            LabeledContent {
                TextField("", text: $author)
            } label: {
                Text("Author").foregroundStyle(.secondary)
            }
            
            Divider()
            
            Text("Summary").foregroundStyle(.secondary)
            TextEditor(text: $summary)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed {
                Button("Update") {
                    updateBookData()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            setBookDefaultData()
        }
    }
    
    //MARK: - Functions
    
    private func updateBookData() {
        book.status = status
        book.rating = rating ?? 0
        book.title = title
        book.author = author
        book.sumary = summary
        book.dateAdded = dateAdded
        book.dateStarted = dateStarted
        book.dateCompleted = dateCompleted
    }
    
    private func setBookDefaultData() {
        status = book.status
        rating = book.rating
        title = book.title
        author = book.author
        summary = book.sumary
        dateAdded = book.dateAdded
        dateStarted = book.dateStarted
        dateCompleted = book.dateCompleted
    }
        
    private func setDatas(oldValue: Status, newValue: Status) {
        if newValue == .onShelf {
            dateStarted = Date.distantPast
            dateCompleted = Date.distantPast
        } else if newValue == .inProgress && oldValue == .completed {
            // from completed to inProgress
            dateCompleted = Date.distantPast
        } else if newValue == .inProgress && oldValue == .completed {
            // Book has been started
            dateStarted = Date.now
        } else if newValue == .completed && oldValue == .onShelf {
            // Forgot to start book
            dateCompleted = Date.now
            dateStarted = dateAdded
        } else {
            // completed
            dateCompleted = Date.now
        }
    }
    
    private func changedBookData() -> Bool {
        if status != book.status || rating != book.rating || title != book.title || author != book.author || summary != book.sumary || dateAdded != book.dateAdded || dateStarted != book.dateStarted || dateCompleted != book.dateCompleted {
            return true
        } else {
            return  false
        }
    }
}

//#Preview {
//    EditBookView()
//}

#Preview {
    let preview = Preview()
    
    return NavigationStack {
        EditBookView(book: Book.sampleBooks[4])
            .modelContainer(preview.container)
    }
}
