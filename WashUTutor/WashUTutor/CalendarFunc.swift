//
//  CalendarFunc.swift
//  WashUTutor
//
//  Created by Tianqi Xu on 11/4/23.
//

import UIKit

class CalendarFunc
{
    let calendar = Calendar.current
    
    func plusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func plusWeek(date: Date) -> Date {
        return calendar.date(byAdding: .day, value: 7, to: date)!
    }

    func minusWeek(date: Date) -> Date {
        return calendar.date(byAdding: .day, value: -7, to: date)!
    }
    
    func plusDays(date: Date, numberOfDays: Int) -> Date {
        return calendar.date(byAdding: .day, value: numberOfDays, to: date)!
    }
    
    func minusDays(date: Date, numberOfDays: Int) -> Date {
        return calendar.date(byAdding: .day, value: -numberOfDays, to: date)!
    }
    
    func firstOfNextMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        var nextMonthComponents = DateComponents()
        nextMonthComponents.month = 1
        let nextMonthDate = calendar.date(byAdding: nextMonthComponents, to: calendar.date(from: components)!)!
        return calendar.date(from: calendar.dateComponents([.year, .month], from: nextMonthDate))!
    }
    
    func startOfWeek(date: Date) -> Date {
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        components.weekday = calendar.firstWeekday
        return calendar.date(from: components)!
    }
    
    func weekOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.weekOfMonth], from: date)
        return components.weekOfMonth ?? 0
    }
    
    
    func weekDates(date: Date) -> [Date] {
        var week = [Date]()
        let todayComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        let startOfWeek = calendar.date(from: todayComponents)!
        
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                week.append(day)
            }
        }
        return week
    }
    
    func monthString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int
    {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(date: Date) -> Int
    {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(date: Date) -> Date
    {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int
    {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
    func dayString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
    
}
