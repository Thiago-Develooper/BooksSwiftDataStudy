//
//  PreviewContainer.swift
//  MyBooksGo
//
//  Created by Thiago Menezes on 11/03/24.
//

import SwiftUI
import Foundation
import SwiftData

struct Preview {
    let container: ModelContainer
    
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true) //isStoredInMemoryOnly: Um valor booliano que determina se o armazenamento persistente associado é efêmero e existe apenas na memória.
        
        do {
            container = try ModelContainer(for: Book.self, configurations: config)
        } catch {
            fatalError("Could not be create preview container")
        }
    }
    
    func addExamples(_ examples: [Book]) {
        Task { @MainActor in
            examples.forEach { example in
                container.mainContext.insert(example)
            }
        }
    }
}

//#Preview {
//    let preview = PreviewContainer()
//    preview.addExamples(Book.sampleBooks)
//    return BookListView()
//        .modelContainer(preview.container)
//}
