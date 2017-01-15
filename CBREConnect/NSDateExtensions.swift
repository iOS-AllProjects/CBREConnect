//
//  NSDateExtensions.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/19/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import Foundation
extension NSDate {
    var calendar: NSCalendar {
        return NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
    }
    
    func equalsTo(date: NSDate) -> Bool {
        return self.compare(date as Date) == ComparisonResult.orderedSame
    }
    
    func greaterThan(date: NSDate) -> Bool {
        return self.compare(date as Date) == ComparisonResult.orderedDescending
    }
    
    func lessThan(date: NSDate) -> Bool {
        return self.compare(date as Date) == ComparisonResult.orderedAscending
    }
    
    func toString(format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self as Date)
    }
    
    func getNumOfDays() -> Int{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: self as Date)
        let date = calendar.date(from: components)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}
