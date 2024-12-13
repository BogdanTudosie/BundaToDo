//
//  ItemDetailView.swift
//  BundaToDo
//
//  Created by Bogdan Tudosie on 12.12.2024.
//

import SwiftUI

struct ItemDetailView: View {
    @ObservedObject var viewModel: ItemDetailViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                headerSection
                
                // Status Section
                statusSection
                
                // Timeline Section
                timelineSection
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: horizontalSizeClass == .regular ? 600 : nil)
        }
        .navigationTitle(viewModel.item.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                itemMenu
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.item.text ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                StatusBadge(status: viewModel.item.status)
            }
            
            Text("Created \(viewModel.item.createdOn.formatted(date: .abbreviated, time: .shortened))")
                .foregroundStyle(.secondary)
        }
    }
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Status")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(
                        viewModel.item.status.displayText,
                        systemImage: statusIcon
                    )
                    .foregroundColor(statusColor)
                }
                
                if let completedOn = viewModel.item.completedOn {
                    Text("Completed on \(completedOn.formatted(date: .abbreviated, time: .shortened))")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Timeline")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 16) {
                if viewModel.item.status == .completed, let completedOn = viewModel.item.completedOn {
                    TimelineItem(
                        title: "Completed",
                        date: completedOn,
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                }
                else if viewModel.item.status == .new {
                    TimelineItem(
                        title: "Created",
                        date: viewModel.item.createdOn,
                        icon: "plus.circle.fill",
                        color: .blue
                    )
                }
                
                else if viewModel.item.status == .inProgress {
                    TimelineItem(
                        title: "Started",
                        date: viewModel.item.createdOn,
                        icon: "arrow.right.circle.fill",
                        color: .orange
                    )
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private var itemMenu: some View {
        Menu {
            Button(action: { viewModel.toggleStatus() }) {
                Label(
                    viewModel.item.status == .completed ? "Mark as Incomplete" : "Mark as Complete",
                    systemImage: viewModel.item.status == .completed ? "circle" : "checkmark.circle"
                )
            }
            
            Button(action: { viewModel.deleteItem() }) {
                Label("Delete Item", systemImage: "trash")
            }
            .tint(.red)
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    
    private var statusIcon: String {
        switch viewModel.item.status {
        case .new: return "circle"
        case .inProgress: return "arrow.right.circle"
        case .completed: return "checkmark.circle.fill"
        }
    }
    
    private var statusColor: Color {
        switch viewModel.item.status {
        case .new: return .blue
        case .inProgress: return .orange
        case .completed: return .green
        }
    }
}

struct StatusBadge: View {
    let status: Item.TaskStatus
    
    var body: some View {
        Text(status.rawValue.description)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
    
    private var backgroundColor: Color {
        switch status {
        case .new: return .blue
        case .inProgress: return .orange
        case .completed: return .green
        }
    }
}


#Preview {
    ItemDetailView(viewModel: ItemDetailViewModel.previewModel())
}
