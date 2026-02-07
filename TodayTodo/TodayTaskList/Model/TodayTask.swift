//
//  TodayTask.swift
//  TodayTodo
//
//  Created by Roushil on 07/02/26.
//

import Foundation
import SwiftData

@Model
final class TodayTask {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var dayKey: String

    init(title: String, dayKey: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.dayKey = dayKey
    }
}

extension TodayTask {
    var formattedDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        guard let date = formatter.date(from: dayKey) else { return dayKey }
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
