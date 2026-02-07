//
//  TaskCleanUpService.swift
//  TodayTodo
//
//  Created by Roushil on 07/02/26.
//

import SwiftUI
import SwiftData

protocol CleanupService {
    func cleanOldTasks(keeping dayKey: String)
}

final class TaskCleanupService: CleanupService {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func cleanOldTasks(keeping dayKey: String) {
        let descriptor = FetchDescriptor<TodayTask>(predicate: #Predicate { $0.dayKey != dayKey })
        do {
            let oldTasks = try context.fetch(descriptor)
            oldTasks.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Cleanup failed:", error)
        }
    }
}
