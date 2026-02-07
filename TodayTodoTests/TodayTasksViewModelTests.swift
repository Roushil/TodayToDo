//  TodayTasksViewModelTests.swift
//  TodayTodoTests
//
//  Created by Roushil on 07/02/26.
//

import XCTest
@testable import TodayTodo
import SwiftData

@MainActor
final class TodayTasksViewModelTests: XCTestCase {
    
    private var container: ModelContainer!
    private var context: ModelContext!
    private var dateProvider: FixedDateProvider!
    private var cleanupService: MockCleanupService!
    private var viewModel: TodayTasksViewModel!

    override func setUp() async throws {
        try await super.setUp()
        
        // Create fresh in-memory container for each test case
        let schema = Schema([TodayTask.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true, allowsSave: true)
        container = try ModelContainer(for: schema, configurations: config)
        context = container.mainContext
        
        // Fixed test date
        let fixedDate = Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 7))!
        dateProvider = FixedDateProvider(date: fixedDate)
        cleanupService = MockCleanupService()
        viewModel = TodayTasksViewModel(context: context, dateProvider: dateProvider, cleanupService: cleanupService)
    }

    override func tearDown() async throws {
        container = nil
        viewModel = nil
        dateProvider = nil
        cleanupService = nil
        context = nil
        try await super.tearDown()
    }

    func testTriggersCleanup() {
        XCTAssertEqual(cleanupService.receivedDayKey, dateProvider.date.dayKey())
    }

    func testLoadTasksWork() throws {
        let todayTask = TodayTask(title: "Test Task", dayKey: dateProvider.date.dayKey())
        context.insert(todayTask)
        try context.save()
        viewModel.loadTasks()
        XCTAssertEqual(viewModel.pendingTasks.count, 1)
        XCTAssertEqual(viewModel.pendingTasks.first?.title, "Test Task")
        XCTAssertEqual(viewModel.completedTasks.count, 0)
    }

    func testLoadTasksFiltersByDay() throws {
        let todayTask = TodayTask(title: "Today", dayKey: dateProvider.date.dayKey())
        let yesterdayTask = TodayTask(title: "Yesterday", dayKey: "20260206")
        context.insert(todayTask)
        context.insert(yesterdayTask)
        try context.save()
        viewModel.loadTasks()
        XCTAssertEqual(viewModel.pendingTasks.count, 1)
        XCTAssertEqual(viewModel.pendingTasks.first?.title, "Today")
    }

    func testAddToPendingTasks() throws {
        viewModel.loadTasks()
        viewModel.addTask(title: "New Task")
        XCTAssertEqual(viewModel.pendingTasks.count, 1)
        XCTAssertEqual(viewModel.pendingTasks.first?.title, "New Task")
    }

    func testToggleTaskMovesToCompleted() throws {
        let task = TodayTask(title: "Toggle Me", dayKey: dateProvider.date.dayKey())
        context.insert(task)
        try context.save()
        viewModel.loadTasks()
        let pendingTask = viewModel.pendingTasks.first!
        viewModel.toggleTask(pendingTask)
        XCTAssertEqual(viewModel.pendingTasks.count, 0)
        XCTAssertEqual(viewModel.completedTasks.count, 1)
        XCTAssertTrue(viewModel.completedTasks.first!.isCompleted)
    }

    func testDeleteTaskRemovesFromAll() throws {
        let task = TodayTask(title: "Delete Me", dayKey: dateProvider.date.dayKey())
        context.insert(task)
        try context.save()
        viewModel.loadTasks()
        let pendingTask = viewModel.pendingTasks.first!
        viewModel.deleteTask(pendingTask)
        XCTAssertTrue(viewModel.pendingTasks.isEmpty)
        XCTAssertTrue(viewModel.completedTasks.isEmpty)
    }

    func testCompletedTaskMovesToPending() throws {
        let task = TodayTask(title: "Completed", dayKey: dateProvider.date.dayKey())
        task.isCompleted = true
        context.insert(task)
        try context.save()
        viewModel.loadTasks()
        let completedTask = viewModel.completedTasks.first!
        viewModel.toggleTask(completedTask)
        XCTAssertEqual(viewModel.pendingTasks.count, 1)
        XCTAssertEqual(viewModel.completedTasks.count, 0)
        XCTAssertFalse(viewModel.pendingTasks.first!.isCompleted)
    }
    
    func testCleanupServiceOldTasks() throws {
         let todayKey = dateProvider.date.dayKey()
         let oldKey = "20260206"
         let oldTask = TodayTask(title: "Old", dayKey: oldKey)
         let todayTask = TodayTask(title: "Today", dayKey: todayKey)
         context.insert(oldTask)
         context.insert(todayTask)
         try context.save()
         cleanupService.cleanOldTasks(keeping: todayKey)
         let remainingCount = try context.fetchCount(
             FetchDescriptor<TodayTask>(predicate: #Predicate { $0.dayKey == todayKey })
         )
         XCTAssertEqual(remainingCount, 1)
     }
    
    func testCleanupServiceEmptyDatabase() throws {
         let todayKey = dateProvider.date.dayKey()
         cleanupService.cleanOldTasks(keeping: todayKey)
         let count = try context.fetchCount(FetchDescriptor<TodayTask>())
         XCTAssertEqual(count, 0)
     }
}
