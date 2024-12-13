//
//  ItemRepository.swift
//  BundaToDo
//
//  Created by Bogdan Tudosie on 11.12.2024.
//

import Foundation
import SwiftData

protocol ItemRepository {
    var modelContext: ModelContext { get }
    func addItem(item: Item) throws
    func deleteItem(at offsets: IndexSet, from items: [Item]) throws
    func deleteItem(_ item: Item) throws
    func updateItem(_ item: Item, name: String, description: String) throws
    func fetchAllItems() throws -> [Item]
    func fetchCompletedItems() throws -> [Item]
    func fetchIncompleteItems() throws -> [Item]
}
