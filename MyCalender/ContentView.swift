//
//  ContentView.swift
//  MyCalender
//
//  Created by kbaba on 2024/03/18.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                CalendarView(selectedDate: $selectedDate)
                    .frame(width: 300, height: 300)
                    .border(.red, width: 1.0)
                Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
                Spacer()
            }
            Spacer()
        }
        .background(Color(hue: 0.00, saturation: 0.00, brightness: 0.96, opacity: 1.00))
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }
}

#Preview {
    ContentView()        
}
