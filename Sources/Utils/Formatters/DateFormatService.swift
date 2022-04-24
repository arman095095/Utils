//
//  DateFormat.swift
//  diffibleData
//
//  Created by Arman Davidoff on 25.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import SwiftDate
import Foundation

protocol DateFormatServiceProtocol {
    func getLocaleDate(date: Date) -> Date
    func getTime(date: Date) -> String
    func getLastActivityDescription(date: Date) -> String
    func onlyWeek(from date: Date) -> String
    func getTimerString(timeInterval: TimeInterval) -> String
    func convertForLabel(from date: Date) -> String
    func convertForActiveChat(from date: Date) -> String
    func convertDate(from date: Date) -> String
    func getAge(date: String) -> String
    func getAge(date: Date) -> String
    func getLocaleBirthdateText(date: Date) -> String
    func getBirthdate(from text: String) -> Date
}

public struct DateFormatService: DateFormatServiceProtocol {
    
    private let totalDateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    private let timeDateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "HH:mm"
        return dt
    }()
    private let ageDateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "dd'.'MM'.'yyyy"
        return dt
    }()
    private let secondsDescriptions: [String]
    private let minutesDescriptions: [String]
    
    public init() {
        self.secondsDescriptions = ["секунд","секунду","секунды"]
        self.minutesDescriptions = ["минут","минуту","минуты"]
    }
    
    public func getLocaleDate(date: Date) -> Date {
        return Date(timeIntervalSince1970: TimeInterval((Int(date.timeIntervalSince1970) + TimeZone.current.secondsFromGMT())))
    }
    
    public func getLocaleBirthdateText(date: Date) -> String {
        let custom = "dd'.'MM'.'yyyy"
        return Date(timeIntervalSince1970: TimeInterval((Int(date.timeIntervalSince1970) + TimeZone.current.secondsFromGMT()))).toString(.custom(custom))
    }
    
    public func getTime(date: Date) -> String {
        return timeDateFormatter.string(from: date)
    }
    
    public func getLastActivityDescription(date: Date) -> String {
        let currentDate = getLocaleDate(date: Date())
        let postData = getLocaleDate(date: date)
        let interval =  currentDate.timeIntervalSince(postData)
        if interval < 60  { return "только что" }
        return convertDate(from: date)
    }
    
    public func onlyWeek(from date: Date) -> String {
        switch date.toString(.custom("EEEE")) {
        case "Monday":
            return "пн"
        case "Tuesday":
            return "вт"
        case "Wednesday":
            return "ср"
        case "Thursday":
            return "чт"
        case "Friday":
            return "пт"
        case "Saturday":
            return "сб"
        case "Sunday":
            return "вс"
        default:
            return ""
        }
    }
    
    public func getTimerString(timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval/60)
        let seconds = Double(timeInterval) - Double(minutes*60)
        let strSeconds = seconds < 10 ? "0" + String(format: "%.2f", seconds) : String(format: "%.2f", seconds)
        let strMinutes = minutes < 10 ? ("0" + "\(minutes)") : "\(minutes)"
        
        return "\(strMinutes):\(strSeconds)"
    }
    
    public func convertForLabel(from date: Date) -> String {
        let currentDate = getLocaleDate(date: Date())
        let messageDate = getLocaleDate(date: date)
        
        if messageDate.month == currentDate.month && messageDate.year == currentDate.year && messageDate.day == currentDate.day  {
            return "сегодня в " + timeDateFormatter.string(from: date)
        } else if messageDate.month == currentDate.month && messageDate.year == currentDate.year && messageDate.day + 1 == currentDate.day {
            return "вчера в " + timeDateFormatter.string(from: date)
        } else  {
            return totalDateFormatter.string(from: date)
        }
    }
    
    public func convertForActiveChat(from date: Date) -> String {
        let currentDate = getLocaleDate(date: Date())
        let messageDate = getLocaleDate(date: date)
        
        if messageDate.month == currentDate.month && messageDate.year == currentDate.year && messageDate.day == currentDate.day  {
            return timeDateFormatter.string(from: date)
        } else if messageDate.month == currentDate.month && messageDate.year == currentDate.year && (currentDate.day - messageDate.day) <= 7 {
            return onlyWeek(from: date)
        } else  {
            return totalDateFormatter.string(from: date)
        }
    }
    
    public func convertDate(from date: Date) -> String {
        
        let currentDate = getLocaleDate(date: Date())
        let postData = getLocaleDate(date: date)
        
        let interval =  currentDate.timeIntervalSince(postData)
        if interval == 0 { return "только что" }
        else if interval < 60 {
            return dateFormat(interval: interval,strs: secondsDescriptions)
        } else if interval < 60*60 {
            return dateFormat(interval: interval/60, strs: minutesDescriptions)
        } else if interval >= 60*60 && interval < 2*60*60 {
            return "час назад"
        } else if interval >= 2*60*60 && interval < 3*60*60 {
            return "два часа назад"
        } else if interval >= 3*60*60 && interval < 4*60*60 {
            return "три часа назад"
        } else if interval >= 4*60*60 && postData.month == currentDate.month && postData.year == currentDate.year && postData.day == currentDate.day  {
            return "сегодня в " + timeDateFormatter.string(from: date)
        } else if postData.month == currentDate.month && postData.year == currentDate.year && postData.day + 1 == currentDate.day {
            return "вчера в " + timeDateFormatter.string(from: date)
        } else  {
            return totalDateFormatter.string(from: date)
        }
    }
    
    public func getAge(date: String) -> String {
        guard let date = ageDateFormatter.date(from: date) else { return "" }
        let timeInterval = Date().timeIntervalSince(date)
        let yearInterval = 1.years.timeInterval
        return "\(Int(timeInterval / yearInterval))"
    }
    
    public func getAge(date: Date) -> String {
        let timeInterval = Date().timeIntervalSince(date)
        let yearInterval = 1.years.timeInterval
        return "\(Int(timeInterval / yearInterval))"
    }
    
    public func getBirthdate(from text: String) -> Date {
        ageDateFormatter.date(from: text) ?? Date()
    }
}

private extension DateFormatService {
    func dateFormat(interval: TimeInterval, strs: [String]) -> String {
        let interval = Int(interval)
        if interval%100 == 11 || interval%100 == 12 || interval%100 == 13 || interval%100 == 14 {
            return "\(interval) \(strs[0]) назад"
        }
        if interval%10 == 1 {
            return "\(interval) \(strs[1]) назад"
        }
        if interval%10 == 2 || interval%10 == 3 || interval%10 == 4 {
            return "\(interval) \(strs[2]) назад"
        }
        return "\(interval) \(strs[0]) назад"
    }
}
