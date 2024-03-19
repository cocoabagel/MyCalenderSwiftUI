import SwiftUI
import UIKit

class CalendarViewDelegate: NSObject, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
    var selectedDate: Binding<Date>

    init(selectedDate: Binding<Date>) {
        self.selectedDate = selectedDate
    }

    // MARK: UICalendarSelectionSingleDateDelegate
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let dateComponents = dateComponents {
            let calendar = Calendar(identifier: .gregorian)
            if let date = calendar.date(from: dateComponents) {
                selectedDate.wrappedValue = date
            }
        }
    }

    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        if let dateComponents, let date = Calendar.current.date(from: dateComponents) {
            let currentDate = Date()
            let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: currentDate)!

            // 偶数日は選択不可
            if let day = dateComponents.day, day % 2 == 0 {
                return false
            }

            // 直近3ヶ月以内の日付のみ選択可能
            return date >= threeMonthsAgo && date <= currentDate
        }
        return false
    }
    
    // MARK: UICalendarViewDelegate
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let date = Calendar.current.date(from: dateComponents) {
            if date == selectedDate.wrappedValue {
                return .default(color: .orange, size: .small)
            } else {
                return nil
            }
        }
        return nil
    }
}


struct CalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.locale = Locale(identifier: "ja_JP")
        calendarView.fontDesign = .default
        calendarView.tintColor = .orange
        calendarView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        calendarView.calendar.firstWeekday = 2
        calendarView.wantsDateDecorations = true

        // 表示する日の範囲を去年の1年間と今年の1年間に指定
        let currentDate = Date()
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: currentDate)
        let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: currentDate)
        calendarView.availableDateRange = DateInterval(start: oneYearAgo!, end: oneYearFromNow!)

        // UICalendarSelectionSingleDateDelegateを有効にする
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = selection

        // UICalendarViewDelegateを有効にする
        // calendarView.delegate = context.coordinator

        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // 必要に応じてカレンダーの更新処理を行う
    }

    func makeCoordinator() -> CalendarViewDelegate {
        CalendarViewDelegate(selectedDate: $selectedDate)
    }
}

