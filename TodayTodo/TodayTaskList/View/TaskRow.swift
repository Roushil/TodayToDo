//
//  TaskRow.swift
//  TodayTodo
//
//  Created by Roushil on 07/02/26.
//

import SwiftUI

struct TaskRow: View {

    let task: TodayTask
    let onToggle: () -> Void

    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .onTapGesture { onToggle() }

            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundStyle(task.isCompleted ? .secondary : .primary)

            Spacer()

            Text(task.formattedDay)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}


#Preview {
    TaskRow(task: TodayTask(title: "Hey there", dayKey: "2026-02-07"), onToggle: { })
}
