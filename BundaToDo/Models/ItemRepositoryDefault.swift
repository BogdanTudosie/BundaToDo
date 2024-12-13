//
//  ItemRepositoryDefault.swift
//  BundaToDo
//
//  Created by Bogdan Tudosie on 11.12.2024.
//

import Foundation
import SwiftData

class ItemRepositoryDefault: ItemRepository {
    let modelContext: ModelContext
    
    private let completedStatus = Item.TaskStatus.completed.rawValue  // 2
    private let inProgressStatus = Item.TaskStatus.inProgress.rawValue // 1
    private let newStatus = Item.TaskStatus.new.rawValue  // 0
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addItem(item: Item) throws {
        modelContext.insert(item)
        try modelContext.save()
    }
    
    func deleteItem(at offsets: IndexSet, from items: [Item]) throws {
        for index in offsets {
            modelContext.delete(items[index])
        }
        try modelContext.save()
    }
    
    func deleteItem(_ item: Item) throws {
        modelContext.delete(item)
        try modelContext.save()
    }
    
    func updateItem(_ item: Item, name: String, description: String) throws {
        item.name = name
        item.text = description
        try modelContext.save()
    }
    
    func fetchAllItems() throws -> [Item] {
        let descriptor = FetchDescriptor<Item>(
            sortBy: [SortDescriptor(\.createdOn, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func fetchCompletedItems() throws -> [Item] {
        let descriptor = FetchDescriptor<Item>(
            predicate: #Predicate<Item> { item in
                item.taskStatus == completedStatus
            },
            sortBy: [SortDescriptor(\.createdOn, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func fetchIncompleteItems() throws -> [Item] {
        let descriptor = FetchDescriptor<Item>(
            predicate: #Predicate<Item> { item in
                item.taskStatus < completedStatus
            },
            sortBy: [SortDescriptor(\.createdOn, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
}
