//
//  Book.swift
//  MyBooksGo
//
//  Created by Thiago Menezes on 07/03/24.
//

import SwiftUI
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    
    var sumary: String
    var rating: Int?
    
    var status: Status //Relationship
    
    var icon: Image {
        switch status {
        case .onShelf:
            Image(systemName: "checkmark.diamond.fill")
        case.inProgress:
            Image(systemName: "book.fill")
        case.completed:
            Image(systemName: "books.vertical.fill")
        }
    }
    
    init(
        title: String,
        author: String,
        dateAdded: Date = Date.now,
        dateStarted: Date = Date.distantPast,
        dateCompleted: Date = Date.distantPast,
        sumary: String = "",
        rating: Int? = nil,
        status: Status = .onShelf
    ) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.sumary = sumary
        self.rating = rating
        self.status = status
    }
}

enum Status: Int, Codable, Identifiable, CaseIterable {
    case onShelf, inProgress, completed
    
    var id: Self {
        self
    }
    
    var descr: String {
        switch self {
        case .onShelf:
            "On Shelf"
        case .inProgress:
            "In Progress"
        case . completed:
            "Complete"
        }
    }
}
