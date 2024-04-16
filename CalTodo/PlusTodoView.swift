
import SwiftUI

struct PlusTodoView: View {
    @State var title: String = ""
    @State var memo: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var currentDate: Date = Date()
    @State var showingDatePicker01 = false
    @State var showingDatePicker02 = false
    
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
        
        VStack {
            TextField("오늘의 일정", text: $title)
                .padding()
                .font(.system(size: 35))
                .bold()
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.black)
                VStack {
                    Text("\(dateFormatter.string(from: currentDate))")
                    Text("\(timeFormatter.string(from: currentDate))")
                        .bold()
                }
                .onTapGesture {
                    self.showingDatePicker01.toggle()
                }
                
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                VStack {
                    Text("\(dateFormatter.string(from: currentDate))")
                    Text("\(timeFormatter.string(from: currentDate.addingTimeInterval(3600)))")
                        .bold()
                }
                .onTapGesture {
                    self.showingDatePicker02.toggle()
                }
            }
            .padding()
            
//            Spacer()

            if showingDatePicker01 {
                DatePicker("", selection: $startDate, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
            }
            
            if showingDatePicker02 {
                DatePicker("", selection: $endDate, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
            }
            
//            VStack {
//                HStack{
//                    Image(systemName: "list.bullet.clipboard")
//                    Text("일정")
//                }
//            }
            
            VStack {
                HStack {
                    Image(systemName: "note.text")
                    Text("메모")
                }
                
                VStack {
                    TextField("메모 작성", text: $memo)
                        .padding()
                        .font(.system(size: 20))
//                        .bold()
                }
            }
        }
    }
}



#Preview {
    PlusTodoView()
}
