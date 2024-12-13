//
//  BundaToDoApp.swift
//  BundaToDo
//
//  Created by Bogdan Tudosie on 11.12.2024.
//

import SwiftUI
import SwiftData

@main
struct YourApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Item.self)
        } catch {
            fatalError("Failed to initialize container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            let repository = ItemRepositoryDefault(modelContext: container.mainContext)
            ContentView(viewModel: ItemListViewModel(repository: repository))
        }
    }
}
