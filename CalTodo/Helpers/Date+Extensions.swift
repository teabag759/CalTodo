
import SwiftUI

extension Date {
    
    // checking if the date is Same hour
    var isSameHour: Bool {
        return Calendar.current.compare(self, to:.init(), toGranularity: .hour) == .orderedSame
    }
    
    // checking if the date is Past hour
    var isPast: Bool {
        return Calendar.current.compare(self, to:.init(), toGranularity: .hour) == .orderedAscending
    }
}
