//
//  TodayTasksViewModel.swift
//  TodayTodo
//
//  Created by Roushil on 07/02/26.
//

import SwiftUI
import SwiftData
import Observation

@Observable
final class TodayTasksViewModel {

    private var tasks: [TodayTask] = []
    private let context: ModelContext
    private let dateProvider: DateProvider
    private let todayKey: String

    init(context: ModelContext, dateProvider: DateProvider = TodayDateProvider(), cleanupService: CleanupService) {
        self.context = context
        self.dateProvider = dateProvider
        self.todayKey = dateProvider.date.dayKey()
        cleanupService.cleanOldTasks(keeping: todayKey)
    }

    var pendingTasks: [TodayTask] {
        tasks.filter { !$0.isCompleted }
    }

    var completedTasks: [TodayTask] {
        tasks.filter { $0.isCompleted }
    }
    
    func loadTasks() {
        let descriptor = FetchDescriptor<TodayTask>(predicate: #Predicate { $0.dayKey == todayKey })
        do {
            tasks = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch tasks:", error)
            tasks = []
        }
    }

    func addTask(title: String) {
        guard !title.isEmpty else { return }
        let task = TodayTask(title: title, dayKey: todayKey)
        context.insert(task)
        do {
            try context.save()
            tasks.append(task)
        } catch {
            print("Failed to save task:", error)
        }
    }

    func toggleTask(_ task: TodayTask) {
        task.isCompleted.toggle()
        do {
            try context.save()
        } catch {
            print("Failed to update task:", error)
        }
    }
    
    func deleteTask(_ task: TodayTask) {
        context.delete(task)
        do {
            try context.save()
            tasks.removeAll { $0.id == task.id }
        } catch {
            print("Delete failed:", error)
        }
    }
}
