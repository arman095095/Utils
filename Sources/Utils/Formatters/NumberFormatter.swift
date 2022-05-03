//
//  File.swift
//  
//
//  Created by Арман Чархчян on 03.05.2022.
//

import Foundation

public enum Item {
    case likes
}

public protocol NumberFormatterProtocol {
    func countFormat(for item: Item, count: Int?) -> String
}

public struct NumberFormatter {
    public init() { }
    public func countFormat(for item: Item, count: Int?) -> String {
        switch item {
        case .likes:
            return itemPresentation(countOf: count)
        }
    }
}

private extension NumberFormatter {
    func itemPresentation(countOf: Int?) -> String {
        guard let count = countOf else { return "" }
        if count == 0 { return "" }
        
        let countDouble = Double(count)
        if count > 999 && count < 1000000 {
            let str = String(format: "%.1f", countDouble/1000)
            if str.last != "0" {
                return String(format: "%.1f", countDouble/1000) + "K" }
            else {
                return "\(Int(countDouble/1000))" + "K"
            }
        }
        else if count >= 1000000 {
            let str = String(format: "%.1f", countDouble/1000000)
            if str.last != "0" {
                return String(format: "%.1f", countDouble/1000000) + "M" }
            else {
                return "\(Int(countDouble/1000000))" + "M"
            }
        } else {
            return "\(count)"
        }
    }
}
