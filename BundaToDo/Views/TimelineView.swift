//
//  TimelineView.swift
//  BundaToDo
//
//  Created by Bogdan Tudosie on 12.12.2024.
//

import SwiftUI
// Custom Timeline View
struct TimelineView: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if item.status == .completed, let completedDate = item.completedOn {
                TimelineItem(
                    title: "Completed",
                    date: completedDate,
                    icon: "checkmark.circle.fill",
                    color: .green
                )
            }
            else if item.status == .new {
                TimelineItem(
                    title: "Created",
                    date: item.createdOn,
                    icon: "plus.circle.fill",
                    color: .blue
                )
            } else if item.status == .inProgress {
                TimelineItem(
                    title: "Started",
                    date: item.createdOn,
                    icon: "arrow.right.circle.fill",
                    color: .orange
                )
            }
        }
    }
}

struct TimelineItem: View {
    let title: String
    let date: Date
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(color)
            
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.medium)
                Text(date, style: .date)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            // Preview with incomplete item
            let incompleteItem = Item(
                name: "Test Task",
                text: "Description",
                completedOn: nil,
                taskStatus: .new)
            TimelineView(item: incompleteItem)
                .padding()
            
            
            
            Divider()
            
            // Preview for in progress item
            let progressItem = Item(
                name: "In Progress Task",
                text: "Description",
                completedOn: nil,
                taskStatus: .inProgress
            )
            TimelineView(item: progressItem)
                .padding()
            
            
            Divider()
            
            // Preview with complete item
            let completeItem = Item(
                name: "Complete Task",
                text: "Description",
                completedOn: Date(),
                taskStatus: .completed
            )
            
            
            TimelineView(item: completeItem)
                .padding()
        }
    }
}
