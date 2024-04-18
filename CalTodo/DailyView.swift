
import SwiftUI

struct DailyView: View {
    
    @State var tasks: [Todo]
//    @State private var selectedTask: Task?
    @State private var isShowingEditView = false
    
//    @State private var currentDate: Date = .init()
    
//    var selectedDate: Date
    
    
    
    var body: some View {
        NavigationStack{
            VStack {
                HCalendarView()
                //            .background(Color.cyan)
                
                ScrollView(.vertical) {
                    VStack {
                        // tasks view
                        TasksView()
                    }
                    //            .padding(.top)
                    .hSpacing(.center)
                    .vSpacing(.center)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
    
    // Tasks View
    @ViewBuilder
    func TasksView() -> some View {
        VStack(alignment: .leading, spacing: 35) {
            ForEach($tasks) { $task in
                TaskRowView(task: $task)
                    .background(alignment: .leading) {
                        if tasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 1)
                                .offset(x: 8)
                                .padding(.bottom, -35)
                        }
                    }
            }
        }
        .padding([.vertical, .leading], 15)
        .padding(.top, 15)
        
    }
}

//#Preview {
//    DailyView(tasks: [Todo(taskTitle: "", creationDate: Date(), tint: "customRed", memo: "memo")])
//}
