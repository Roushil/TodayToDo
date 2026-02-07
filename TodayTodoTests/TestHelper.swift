//
//  TestHelper.swift
//  TodayTodoTests
//
//  Created by Roushil on 07/02/26.
//

import Foundation
import SwiftData

@testable import TodayTodo



@MainActor
func makeInMemoryContext() throws -> ModelContext {
    let schema = Schema([TodayTask.self])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true, allowsSave: true)
    let container = try ModelContainer(for: schema, configurations: config)
    return container.mainContext
}

struct FixedDateProvider: DateProvider {
    let date: Date
}

final class MockCleanupService: CleanupService {
    private(set) var receivedDayKey: String?

    func cleanOldTasks(keeping dayKey: String) {
        receivedDayKey = dayKey
    }
}
