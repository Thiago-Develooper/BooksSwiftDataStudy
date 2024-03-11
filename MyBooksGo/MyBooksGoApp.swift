//
//  MyBooksGoApp.swift
//  MyBooksGo
//
//  Created by Thiago Menezes on 07/03/24.
//

import SwiftUI
import SwiftData

@main
struct MyBooksGoApp: App {
    var body: some Scene {
        WindowGroup {
            BookListView()
        }
        .modelContainer(for: [Book.self])
    }
    

}
