//
//  ContentView.swift
//  BundaToDo
//
//  Created by Bogdan Tudosie on 11.12.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var viewModel: ItemListViewModel
    @State var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    
    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility
        ) {
            // Sidebar (Master)
            List(viewModel.items, selection: $viewModel.selectedItemId) { item in
                NavigationLink(value: item.id) {
                    Text(item.name)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: showAddItemPopover) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            // Detail
            if let selectedId = viewModel.selectedItemId,
               let selectedItem = viewModel.items.first(where: { $0.id == selectedId }) {
                ItemDetailView(viewModel: ItemDetailViewModel(
                    item: selectedItem,
                    repository: viewModel.itemRepository
                ))
            } else {
                Text("Select a task")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteItem(offsets: offsets)
        }
    }
    
    private func showAddItemPopover() {
        viewModel.togglePopover()
    }
}

// Separate preview container helper
struct PreviewContainer {
    @MainActor
    static var container: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Item.self, configurations: config)
            
            // Add preview items
            let items = [
                Item(name: "Wash the dishes", text: "Please wash the dishes", taskStatus: .new),
                Item(name: "Walk the Dog", text: "Walk the Husky", taskStatus: .completed)
            ]
            
            let context = container.mainContext
            items.forEach { context.insert($0) }
            try context.save()
            
            return container
        } catch {
            fatalError("Failed to create preview container")
        }
    }()
}

// Updated preview
#Preview {
    let container = PreviewContainer.container
    let repository = ItemRepositoryDefault(modelContext: container.mainContext)
    let viewModel = ItemListViewModel(repository: repository)
    
    return ContentView(viewModel: viewModel)
        .modelContainer(PreviewContainer.container)
}
