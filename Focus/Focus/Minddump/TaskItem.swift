//
//  TaskItem.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//


import Foundation
import SwiftData

@Model
class TaskItem {
    var title: String
    var createdAt: Date

    init(title: String, createdAt: Date = Date()) {
        self.title = title
        self.createdAt = createdAt
    }
}
