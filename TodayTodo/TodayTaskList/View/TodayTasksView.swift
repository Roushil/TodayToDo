//
//  TodayTasksView.swift
//  TodayTodo
//
//  Created by Roushil on 07/02/26.
//

import SwiftUI
import SwiftData

struct TodayTasksView: View {
    
    @State private var viewModel: TodayTasksViewModel
    @State private var isAddAlertPresented = false
    @State private var newTaskTitle = ""
    
    init(viewModel: TodayTasksViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !viewModel.pendingTasks.isEmpty {
                    Section("Pending") {
                        ForEach(viewModel.pendingTasks) { task in
                            TaskRow(task: task) {
                                viewModel.toggleTask(task)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteTask(task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                
                if !viewModel.completedTasks.isEmpty {
                    Section("Completed") {
                        ForEach(viewModel.completedTasks) { task in
                            TaskRow(task: task) {
                                viewModel.toggleTask(task)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteTask(task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        newTaskTitle = ""
                        isAddAlertPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Add your New Task", isPresented: $isAddAlertPresented) {
                TextField("Task name", text: $newTaskTitle)
                Button("Add") {
                    viewModel.addTask(title: newTaskTitle)
                }
                Button("Cancel", role: .cancel) { }
            }
        }
        .task {
            viewModel.loadTasks()
        }
    }
}




#Preview {
    let container = try! ModelContainer(for: TodayTask.self, configurations: .init(isStoredInMemoryOnly: true))
    TodayTasksView(viewModel: TodayTasksViewModel(context: container.mainContext, cleanupService: TaskCleanupService(context: container.mainContext)))
        .modelContainer(container)
}
