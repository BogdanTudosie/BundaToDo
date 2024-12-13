//
//  ItemViewModel.swift
//  BundaToDo
//
//  Created by Bogdan Tudosie on 11.12.2024.
//

import Foundation
import SwiftData

class ItemDetailViewModel: ObservableObject {
    @Published var item: Item
    private let repository: ItemRepository
    
    // Computed properties
    var formattedCreatedDate: String {
        item.createdOn.formatted(Date.FormatStyle()
            .month(.abbreviated)
            .day()
            .hour()
            .minute())
    }
    
    var formattedCompletedDate: String {
        item.completedOn?.formatted(Date.FormatStyle()
            .month(.abbreviated)
            .day()
            .hour()
            .minute()) ?? "Incomplete"
    }
    
    init(item: Item, repository: ItemRepository) {
        self.item = item
        self.repository = repository
    }
    
    func saveChanges() {
        do {
            try repository.updateItem(item, name: item.name, description: item.text ?? "")
        } catch {
            fatalError("Failed to save changes: \(error.localizedDescription)")
        }
    }
    
    func toggleStatus() {
        if item.status == .completed {
            item.status = .new
            item.completedOn = nil
        } else {
            item.status = .completed
            item.completedOn = Date()
        }
        
        try? repository.updateItem(item, name: item.name, description: item.text ?? "")
    }
    
    func deleteItem() {
        try? repository.deleteItem(item)
    }
}

extension ItemDetailViewModel {
    @MainActor static func previewModel() -> ItemDetailViewModel {
        let container = try! ModelContainer(for: Item.self)
        let mockItem = Item(
            name: "Feed cat",
            text: "Feed the cat every day",
            taskStatus: .completed
        )
        let repository = ItemRepositoryDefault(modelContext: container.mainContext)
        return ItemDetailViewModel(item: mockItem, repository: repository)
    }
}
