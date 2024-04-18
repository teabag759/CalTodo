import Foundation

class TaskManager: ObservableObject {
    @Published var tasks: [Todo] = []
    
    private let tasksKey = "tasks"
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: tasksKey),
              let savedTasks = try? JSONDecoder().decode([Todo].self, from: data)
        else { return }
        self.tasks = savedTasks
    }
    
    func saveTask(_ task: Todo) {
        self.tasks.append(task)
        if let encoded = try? JSONEncoder().encode(self.tasks) {
            UserDefaults.standard.setValue(encoded, forKey: tasksKey)
        }
    }
                
}
