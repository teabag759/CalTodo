
import SwiftUI

@main
struct CalTodoApp: App {
    var body: some Scene {
        WindowGroup {
            CalendarView()
        }
//        .modelContainer(for: Task.self)
    }
}
