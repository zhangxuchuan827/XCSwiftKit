//
//  XCDateExtension.swift
//  XCSwiftKitDemo
//
//  Created by zhangxuchuan on 2018/7/1.
//  Copyright © 2018年 zhangxuchuan. All rights reserved.
//

import Foundation

extension Date {
    
    //MARK:- 时间
    public var year : Int{
        return Calendar.current.component(Calendar.Component.year, from: self)
    }
    public var month : Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }
    public var day : Int {
        return Calendar.current.component(Calendar.Component.day, from: self)
    }
    public var hour : Int {
        return Calendar.current.component(Calendar.Component.hour, from: self)
    }
    public var minute : Int {
        return Calendar.current.component(Calendar.Component.minute, from: self)
    }
    public var second : Int {
        return Calendar.current.component(Calendar.Component.second, from: self)
    }
    public var nanosecond : Int {
        return Calendar.current.component(Calendar.Component.nanosecond, from: self)
    }
    public var weekday : Int{
        return Calendar.current.component(Calendar.Component.weekday, from: self)
    }
    public var weekdayOrdinal : Int {
        return Calendar.current.component(Calendar.Component.weekdayOrdinal, from: self)
    }
    public var weekOfMonth : Int {
        return Calendar.current.component(Calendar.Component.weekOfMonth, from: self)
    }
    public var weekOfYesr : Int {
        return Calendar.current.component(Calendar.Component.weekOfYear, from: self)
    }
    public var yearForWeekOfYear : Int {
        return Calendar.current.component(Calendar.Component.yearForWeekOfYear, from: self)
    }
    public var quarter : Int{
        return Calendar.current.component(Calendar.Component.quarter, from: self)
    }
    
    //MARK:- 判断
    
    
    public var isToday : Bool{
        if fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24{
            return false
        }
        return Date().day == self.day
    }
    public var isYesterday : Bool {
        let added = self.dateByAddingDays(days: 1)
        return added.isToday
    }
    public var isDayBeforYesterday : Bool{
        let added = self.dateByAddingDays(days: 2)
        return added.isToday
    }
    
    
    public func dateByAddingYears(years : Int) -> Date {
        var components = DateComponents()
        components.year = years
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    public func dateByAddingMonths(months : Int) -> Date {
        var components = DateComponents()
        components.month = months
        return Calendar.current.date(byAdding: components, to: self)!
    }
    public func dateByAddingWeeks(weeks : Int) -> Date {
        var components = DateComponents()
        components.weekOfYear = weeks
        return Calendar.current.date(byAdding: components, to: self)!
    }
    public func dateByAddingDays(days : Int) -> Date {
        let tvl = self.timeIntervalSinceReferenceDate + TimeInterval(86400) * TimeInterval(days)
        let newDate = Date.init(timeIntervalSinceReferenceDate: tvl)
        return newDate
    }
    public func dateByAddingHours(hours : Int) -> Date {
        let tvl = self.timeIntervalSinceReferenceDate + TimeInterval(3600) * TimeInterval(hours)
        let newDate = Date.init(timeIntervalSinceReferenceDate: tvl)
        return newDate
    }
    public func dateByAddingMinutes(minutes : Int) -> Date {
        let tvl = self.timeIntervalSinceReferenceDate + TimeInterval(60) * TimeInterval(minutes)
        let newDate = Date.init(timeIntervalSinceReferenceDate: tvl)
        return newDate
    }
    public func dateByAddingSeconds(seconds : Int) -> Date {
        let tvl = self.timeIntervalSinceReferenceDate + TimeInterval(seconds)
        let newDate = Date.init(timeIntervalSinceReferenceDate: tvl)
        return newDate
    }
    
    //MARK:- String to Date
    
    ///yyyy-MM-dd HH:mm:ss , currentTimeZone , currentLocale
    init(date : String) {
        self.init(date: date, format: "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone.current, locale: Locale.current)
    }
    
    init(isoFormatDate : String) {
        self.init(date: isoFormatDate, format: "yyyy-MM-dd'T'HH:mm:ssZ", timeZone: nil, locale: Locale.init(identifier: "en_US_POSIX"))
    }
    
    /// currentTimeZone , currentLocale
    init(date : String , format : String) {
        self.init(date: date, format: format, timeZone: TimeZone.current, locale: Locale.current)
    }
    
    init(date : String , format : String , timeZone : TimeZone? , locale : Locale?) {
        let formatter = DateFormatter()
        if timeZone != nil {
            formatter.timeZone = timeZone
        }
        if locale != nil {
            formatter.locale = locale
        }
        formatter.dateFormat = format
        self = formatter.date(from: date)!
    }
    
    //MARK:- Date to String
    
    /// yyyy-MM-dd HH:mm:ss , currentTimeZone , currentLocale
    public func toString() -> String {
        return self.toString(format: "yyyy-MM-dd HH:mm:ss", locale: Locale.current, timeZone: TimeZone.current)
    }
    /// ISOFormat
    func toISOFormatString() -> String {
        return self.toString(format: "yyyy-MM-dd'T'HH:mm:ssZ", locale: Locale.init(identifier: "en_US_POSIX"), timeZone: nil)
    }
    /// currentTimeZone , currentLocale
    public func toString(format : String) -> String {
        return self.toString(format: format, locale: Locale.current, timeZone: TimeZone.current)
    }
    
    public func toString(format : String, locale : Locale? , timeZone : TimeZone?) -> String {
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = format
        if locale != nil {
            dateFormat.locale = locale
        }
        if timeZone != nil{
            dateFormat.timeZone = timeZone
        }
        return dateFormat.string(from: self)
    }
    
    /// 特殊格式化
    public func specialFormat() -> String{
        if self.isToday {
            let timeOffset = Date().timeIntervalSince1970 - self.timeIntervalSince1970
            if timeOffset < 3600 {
                let t1 = Int(timeOffset / 60)
                return "\(t1)分钟前"
            }else{
                let t2 = Int(timeOffset / 3600)
                return "\(t2)小时前"
            }
        }else if self.isYesterday {
            return "昨天 \(self.toString(format: "HH:mm"))"
        }else if self.isDayBeforYesterday{
            return "前天 \(self.toString(format: "HH:mm"))"
        }else{
            return self.toString(format: "MM-dd HH:mm")
        }
    }
    
    
    
}
