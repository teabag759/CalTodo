
import SwiftUI

struct PlusTodoView: View {
    @Environment(\.dismiss) private var dismiss
    @State var title: String = ""
    @State var memo: String = ""
    //    @State var startDate: Date = .init()
    @State var startDate: Date = Date()
    @State var startTime: Date = Date()
    @State var endDate: Date = Date()
    @State var endTime: Date = Date()
//    @State var currentDate: Date = Date()
    //    @State var showingDatePicker01 = false
    //    @State var showingDatePicker02 = false
    @State private var taskColor: Color = .cyan
    @State private var selectedColor: String = "blue"
    
    @ObservedObject var taskManager: TaskManager = TaskManager()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        return formatter
    }()
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        return formatter
    }()
    
    
    var body: some View {
        
        HStack {
            Spacer()
            Button(action: {
                let newTask = Todo(taskTitle: title, creationDate: startDate, isCompleted: false, tint: selectedColor, memo: memo)
                taskManager.saveTask(newTask)
                dismiss()
            }, label: {
                Text("저장")
                    .font(.title3)
                
            })
        } .padding()
        
        VStack {
            TextField("오늘의 일정", text: $title)
                .padding()
                .font(.system(size: 35))
                .bold()
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.black)
                HStack{
                    //                VStack {
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    //.padding()
                        .labelsHidden()
                    DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                    //.padding()
                        .labelsHidden()
                    
                    //                }
                }
                //                .onTapGesture {
                //                    self.showingDatePicker01 = true
                //                    self.showingDatePicker02 = false
                //                }
                
                
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.black)
//                VStack {
//                    
//                    DatePicker("", selection: $endDate, displayedComponents: .date)
//                        .datePickerStyle(.compact)
//                    //.padding()
//                        .labelsHidden()
//                    DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
//                        .datePickerStyle(.compact)
//                    //.padding()
//                        .labelsHidden()
//                    
//                }
                //                .onTapGesture {
                //                    self.showingDatePicker02 = true
                //                    self.showingDatePicker01 = true
                //                }
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 8, content: {
                let colors: [Color] = [.customRed, .customBlue, .customPink, .customGreen, .customOrange, .customYellow]
                let colorNames: [String] = ["customRed", "customBlue", "customPink", "customGreen", "customOrange", "customYellow"]

                
                HStack(spacing: 0) {
                    Spacer()
                    ForEach(colors.indices, id: \.self) { index in
                        let color = colors[index]
                        let colorName = colorNames[index]
                        Circle()
                            .fill(color)
                            .frame(width: 20, height: 20)
                            .background(content: {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .opacity(taskColor == color ? 1 : 0)
                            })
                            .hSpacing(.center)
                            .contentShape(.rect)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    taskColor = color
                                    selectedColor = colorName
                                }
                            }
                    }
                    Spacer()
                }
                .frame(width: 200)
            })

            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "note.text")
                    Text("메모")
                }
//                .background(Color.red)
                .padding(.top)
                .padding(.leading)
                
                
                TextEditor(text: $memo)
                    .padding(.leading)
                    .padding(.trailing)
//                    .background(Color.red)
                    .font(.system(size: 20))
                //                        .bold()
            }
        }
    }
}



//
//#Preview {
//    PlusTodoView()
//        .background(Color.white)
//}
