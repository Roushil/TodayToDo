//
//  TodayTodoApp.swift
//  TodayTodo
//
//  Created by Roushil on 07/02/26.
//

import SwiftUI
import SwiftData

@main
struct TodayTodoApp: App {
    var modelContainer: ModelContainer = {
        let schema = Schema([TodayTask.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
          WindowGroup {
              TodayTasksView(viewModel: TodayTasksViewModel(context: modelContainer.mainContext, cleanupService: TaskCleanupService(context: modelContainer.mainContext)))
          }
          .modelContainer(modelContainer)
      }
}
