
import SwiftUI
//import SwiftData

//@Model
struct Todo: Identifiable, Codable {
    var id: UUID = UUID()
    var taskTitle: String
    var creationDate: Date
    var isCompleted: Bool = false
    var tint: String
    var memo: String
    
    enum CodingKeys: String, CodingKey {
        case id, taskTitle, creationDate, isCompleted, tint, memo
    }
    
    var tintColor: Color {
        switch tint {
        case "customGreen": return .customGreen
        case "customRed": return .customRed
        case "customOrange": return .customOrange
        case "customYellow": return .customYellow
        case "customPink": return .customPink
        case "customBlue": return .customBlue
        default: return .black
        }
    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(UUID.self, forKey: .id)
//        self.taskTitle = try container.decode(String.self, forKey: .taskTitle)
//        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
//        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
//        self.tint = try container.decode(String.self, forKey: .tint)
//        self.memo = try container.decode(String.self, forKey: .memo)
//    }
//    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(taskTitle, forKey: .taskTitle)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(memo, forKey: .memo)
        try container.encode(tint, forKey: .tint)
    }
}

//var sampleTasks: [Task] = [
//    .init(taskTitle: "Record Video", creationDate: .updateHour(-5), isCompleted: false, tint: .customGreen),
//    .init(taskTitle: "Redesign Website", creationDate: .updateHour(-3), isCompleted: true, tint: .customRed),
//    .init(taskTitle: "Go for a Walk", creationDate: .updateHour(-1), isCompleted: false, tint: .customBlue),
//    .init(taskTitle: "Edit Video", creationDate: .updateHour(0), isCompleted: true, tint: .customPink),
//    .init(taskTitle: "Publish Video", creationDate: .updateHour(1), isCompleted: false, tint: .customOrange),
//    .init(taskTitle: "Tweet about new Video", creationDate: .updateHour(2), isCompleted: true, tint: .customYellow)
//]



extension Date {
    static func updateHour(_ hour: Int) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: hour, to: .now) ?? .now
        return date
    }
}



//extension Date {
//    static func updateHour(_ value: Int) -> Date {
//        let calendar = Calendar.current
//        return calendar.date(bySetting: .hour, value: value, to: .init()) ?? .init()
//    }
//}


