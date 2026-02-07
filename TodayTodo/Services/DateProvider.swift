//
//  DateProvider.swift
//  TodayTodo
//
//  Created by Roushil on 07/02/26.
//

import Foundation

protocol DateProvider {
    var date: Date { get }
}

struct TodayDateProvider: DateProvider {
    var date: Date { Date() }
}

extension Date {
    func dayKey(calendar: Calendar = .current) -> String {
        let comps = calendar.dateComponents([.year, .month, .day], from: self)
        return "\(comps.year!)-\(comps.month!)-\(comps.day!)"
    }
    
    func humanReadableDate(calendar: Calendar = .current, locale: Locale = .current) -> String {
          let formatter = DateFormatter()
          formatter.calendar = calendar
          formatter.locale = locale
          formatter.dateStyle = .medium
          formatter.timeStyle = .none
          return formatter.string(from: self)
      }
}
