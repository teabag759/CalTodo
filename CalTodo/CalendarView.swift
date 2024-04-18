import SwiftUI

struct CalendarView: View {
    // 현재 월과 선택된 날짜 관리
    @State private var month: Date = Date()
    @State private var clickedCurrentMonthDates: Date?
    @State private var showDailyView = false
    
    // 초기화 함수
    init(
        month: Date = Date(),
        clickedCurrentMonthDates: Date? = nil
    ) {
        // 초기값 설정
        _month = State(initialValue: month)
        _clickedCurrentMonthDates = State(initialValue: clickedCurrentMonthDates)
    }
    
    // view body
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView()
                    .padding(30)
                
                headerView
                    .padding()
                calendarGridView
                    .padding()
            }
        }
        
    }
    
    // MARK: - 헤더 뷰
    private var headerView: some View {
        VStack {
            HStack {
                yearMonthView // 연, 월 표시
                
                Spacer()
                
                //        Button(
                //          action: { },
                //          label: {
                //              Image(systemName: "plus.app")
                //                  .font(.title)
                //                  .foregroundColor(.black)
                //          }
                //        )
                
                NavigationLink(destination: PlusTodoView()) {
                    Image(systemName: "plus.app")
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
            
            
            
            // 요일 표시
            HStack {
                // 요일을 반복하여 표시
                ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
                    Text(Self.weekdaySymbols[symbol].uppercased())
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
        }
    }
    
    // MARK: - 연월 표시
    private var yearMonthView: some View {
        HStack(alignment: .center, spacing: 20) {
            // 이전 달로 이동하는 버튼
            Button(
                action: {
                    changeMonth(by: -1) // 월 변경 함수 호출
                },
                label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(canMoveToPreviousMonth() ? .black : . gray)
                }
            )
            .disabled(!canMoveToPreviousMonth()) // 이전 달로 이동 가능한지에 따라 버튼 활성화 여부
            
            // 현재 연월 표시
            Text(month, formatter: Self.calendarHeaderDateFormatter)
                .font(.title.bold())
            
            // 다음 달로 이동하는 버튼
            Button(
                action: {
                    changeMonth(by: 1) // 월 변경 함수 호출
                },
                label: {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .foregroundColor(canMoveToNextMonth() ? .black : .gray)
                }
            )
            .disabled(!canMoveToNextMonth())
            // 다음 달로 이동 가능한지에 따라 버튼 활성/비활성화
        }
    }
    
    // MARK: - 날짜 그리드 뷰
    private var calendarGridView: some View {
        // 달력의 날짜 계산 로직. 각 날짜별 셀 구성
        let daysInMonth: Int = numberOfDays(in: month) // 해당 월의 총 일수
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1 // 해당 월의 첫 요일
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth()) // 이전 달의 마지막 날짜
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0)) // 그리드의 총 행 수
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday) // 다음 달에서 보여줄 일의 수
        
        
        // LazyVGrid 사용하여 날짜를 그리드 형태로 표시
        // LazyVGrid : A container view that arranges its child views in a grid that grows vertically, creating items only as needed.
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            // 각 날짜별 셀 구성
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    // Group : A type that collects multiple instances of a content type — like views, scenes, or commands — into a single unit.
                    if index > -1 && index < daysInMonth {
                        // 현재 달의 날짜 처리
                        let date = getDate(for: index) // 날짜 계산
                        let day = Calendar.current.component(.day, from: date) // 일자 추출
                        let clicked = clickedCurrentMonthDates == date // 선택된 날짜인지 확인
                        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate // 오늘 날짜인지 확인
                        
                        // 날짜 셀 뷰
                        CellView(day: day, clicked: clicked, isToday: isToday)
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        // 이전 달 또는 다음 달의 날짜 처리
                        let day = Calendar.current.component(.day, from: prevMonthDate) // 일자 추출
                        
                        CellView(day: day, isCurrentMonthDay: false) // 날짜 셀 뷰 (현재 달이 아님)
                    }
                }
                .onTapGesture {
                    // 날짜 셀 tab 시 처리
                    if 0 <= index && index < daysInMonth {
                        let date = getDate(for: index) // 날짜 계산
                        clickedCurrentMonthDates = date // 선택된 날짜 업데이트
                        showDailyView = true
                    }
                }
            }
        }
        .background(
            NavigationLink(destination: DailyView(tasks: [Todo(taskTitle: "title", creationDate: Date(), tint: "customRed", memo: "memo1")]), isActive: $showDailyView) {
                EmptyView()
            }
        )
    }
}


// MARK: - 일자 셀 뷰
// 각 일자별 셀을 표시
private struct CellView: View {
    private var day: Int // 일자
    private var clicked: Bool // 선택된 날짜인지 여부
    private var isToday: Bool // 오늘 날짜인지 여부
    private var isCurrentMonthDay: Bool // 현재 달의 날짜인지 여부
    private var hasEvent: Bool // 이벤트가 존재하는 지 확인
    private var textColor: Color {
        // 텍스트 색상 설정
        if clicked {
            return Color.white
        } else if isCurrentMonthDay {
            return Color.black
        } else {
            return Color.gray
        }
    }
    private var backgroundColor: Color {
        // 배경 색상 설정
        if clicked {
            return Color.black
        } else if isToday {
            return Color.gray
        } else {
            return Color.white
        }
    }
    
    // 초기화 설정
    // fileprivate : 동일한 소스 파일에서만 접근이 가능
    fileprivate init(
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        hasEvent: Bool = false,
        isCurrentMonthDay: Bool = true
    ) {
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.hasEvent = hasEvent
        self.isCurrentMonthDay = isCurrentMonthDay
    }
    
    fileprivate var body: some View {
        VStack {
            Circle()
                .fill(backgroundColor) // 배경 색상 적용
                .overlay(Text(String(day))) // 일자 표시
                .foregroundColor(textColor) // 텍스트 색상 적용
            
            Spacer()
            
            if clicked {
                // 선택된 날짜에 대한 표시
                RoundedRectangle(cornerRadius: 10)
                    .fill(.red)
                    .frame(width: 10, height: 10)
            } else {
                // 선택되지 않은 날짜에 대한 표시
                Spacer()
                    .frame(height: 10)
            }
            
        }
        .frame(height: 50)
    }
}

// MARK: - CalendarView Static 프로퍼티
private extension CalendarView {
    // 오늘 날짜를 반환하는 계산 속성, 년, 월, 일만 포함
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
    
    // 연, 월을 표시하는데 사용하는 DateFormatter
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM"
        return formatter
    }()
    
    // 한 주의 요일 이름을 나타나내는 배열 ["Sun", "Mon",,, ]
    static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
}

// MARK: - 내부 로직 메서드
private extension CalendarView {
    /// 주어진 index에 해당하는 날짜를 계산하여 반환
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        // 현재 월의 첫째 날 구하기
        guard let firstDayOfMonth = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: month),
                month: calendar.component(.month, from: month),
                day: 1
            )
        ) else {
            return Date()
        }
        
        // 주어진 index에 해당하는 날짜 계산
        var dateComponents = DateComponents()
        dateComponents.day = index
        let timeZone = TimeZone.current
        let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
        dateComponents.second = Int(offset)
        
        let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
        return date
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 이전 월 마지막 일자
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        self.month = adjustedMonth(by: value)
    }
    
    /// 이전 월로 이동 가능한지 확인
    func canMoveToPreviousMonth() -> Bool {
//        let currentDate = Date()
        let calendar = Calendar.current
        let targetDate = calendar.date(byAdding: .month, value: -3, to: Date()) ?? Date()
        
        if adjustedMonth(by: -1) < targetDate {
            return false
        }
        return true
    }
    
    /// 다음 월로 이동 가능한지 확인
    func canMoveToNextMonth() -> Bool {
//        let currentDate = Date()
        let calendar = Calendar.current
        let targetDate = calendar.date(byAdding: .month, value: 3, to: Date()) ?? Date()
        
        if adjustedMonth(by: 1) > targetDate {
            return false
        }
        return true
    }
    
    /// 변경하려는 월 반환
    func adjustedMonth(by value: Int) -> Date {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
            return newMonth
        }
        return month
    }
}

// MARK: - Date 익스텐션
extension Date {
    static let calendarDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    // Date 인스턴스를 위 형식의 문자열로 변환하는 계산 속성
    var formattedCalendarDayDate: String {
        return Date.calendarDayDateFormatter.string(from: self)
    }
}

// MARK: - 프리뷰
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
