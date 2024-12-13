//
//  Item.swift
//  BundaToDo
//
//  Created by Bogdan Tudosie on 11.12.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    enum TaskStatus: Int, Codable, Hashable {
        case new = 0
        case inProgress = 1
        case completed = 2
        
        static let completedValue = Self.completed.rawValue
        static let newValue = Self.new.rawValue
        static let inProgressValue = Self.inProgress.rawValue
    }
    
    var id: UUID = UUID()
    var name: String
    var text: String?
    var createdOn: Date
    var completedOn: Date?
    var taskStatus: Int = 0
    
    // Helper to get enum value
    var status: TaskStatus {
        get { TaskStatus(rawValue: taskStatus) ?? .new }
        set { taskStatus = newValue.rawValue }
    }
    
    init (name: String, text: String? = nil, completedOn: Date? = nil, taskStatus: TaskStatus = .new) {
        self.name = name
        self.text = text
        self.createdOn = Date()
        self.taskStatus = taskStatus.rawValue
    }
}

extension Item.TaskStatus {
    var displayText: String {
        switch self {
        case .new: return "New"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        }
    }
}
