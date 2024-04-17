//
//  Task.swift
//  CalTodo
//
//  Created by 이소현 on 4/17/24.
//

import SwiftUI

struct Task: Identifiable {
    var id: UUID = .init()
    var taskTitle: String
    var creationDate: Date = .init()
    var isCompleted: Bool = false
    var tint: Color
}

//var sampleTasks: [Task] = [
//    .init(taskTitle: "Record Video", creationDate: ., isCompleted: true, tint: <#T##Color#>)
//]
