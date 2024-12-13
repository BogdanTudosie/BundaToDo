//
//  ItemListViewModel.swift
//  BundaToDo
//
//  Created by Bogdan Tudosie on 12.12.2024.
//

import Foundation
import SwiftData

class ItemListViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var selectedItemId: UUID?
    @Published var isPopoverPresented: Bool = false
    @Published var error: Error?
    
    let itemRepository: ItemRepository
    private let modelContext: ModelContext
    
    init(repository: ItemRepository) {
        self.itemRepository = repository
        self.modelContext = repository.modelContext
        fetchItems()
    }
    
    func addItem(_ item: Item) {
        do {
            try itemRepository.addItem(item: item)
            fetchItems()
        } catch {
            self.error = error
        }
    }
    
    func deleteItem(offsets: IndexSet) {
        do {
            try itemRepository.deleteItem(at: offsets, from: items)
            fetchItems()
        } catch {
            self.error = error
        }
    }
    
    func updateItem(_ item: Item) {
        
    }
    
    func fetchItems() {
        do {
            items = try itemRepository.fetchAllItems()
        } catch {
            self.error = error
        }
    }
    
    func togglePopover() {
        isPopoverPresented.toggle()
    }
    
    func toggleCompletion(for item: Item) {
        let isCompleting = item.status != .completed
        item.status = isCompleting ? .completed : .new
        item.completedOn = isCompleting ? Date() : nil
    }
}

extension ItemListViewModel {
    @MainActor static func previewViewModel() -> ItemListViewModel {
        do {
            // Create in-memory container with explicit config
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: Item.self,
                configurations: config
            )
            
            let context = container.mainContext
            
            // Preview data
            let items: [Item] = [
                Item(name: "Wash the dishes", text: "Please wash the dishes", taskStatus: .new),
                Item(name: "Walk the Dog", text: "Walk the Husky", taskStatus: .completed)
            ]
            
            // Insert and save in a batch
            context.insert(items[0])
            context.insert(items[1])
            try context.save()
            
            let repository = ItemRepositoryDefault(modelContext: context)
            let viewModel = ItemListViewModel(repository: repository)
            
            return viewModel
        } catch {
            fatalError("Failed to create preview: \(error)")
        }
    }
}
