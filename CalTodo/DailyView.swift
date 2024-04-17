
import SwiftUI

struct DailyView: View {
    
//    @State private var tasks: [Task] = sampleTask.sorted(by: { $1.creationDate > $0.creationDate })
    
    var body: some View {
        HCalendarView()
        
        ScrollView(.vertical) {
            VStack {
                // tasks view
//                TasksView()
            }
        }
        .scrollIndicators(.hidden)
        
    }
    
//    @ViewBuilder
//    func TasksView() -> some View {
//        VStack(alignment: .leading, spacing: 35) {
//            ForEach($tasks) { $task in
//                TaskRowView(task: $task)
//            }
//        }
//    }
}

#Preview {
    DailyView()
}
