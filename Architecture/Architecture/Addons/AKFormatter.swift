//
//  AKFormatter.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

enum Format: String {

    // date masks
    
    case server = "yyyy-MM-dd HH:mm:ss"
    case serverWithT = "yyyy-MM-dd'T'HH:mm:ss"
    case activity = "yyyy-MM-dd HH:mm"
    case activityDotted = "dd.MM.yyyy HH:mm"
    case shortActivity = "MM-dd HH:mm"
    case dateWithTime = "dd.MM.yyyy (HH:mm)"
    case anchor = "yyyy-MM-dd"
    case anchorB = "dd-MM-yyyy"
    case dateYearLong = "dd.MM.yyyy"
    case dateYearShort = "dd.MM.yy"
    case timeWithSeconds = "HH:mm:ss"
    case time = "HH:mm"
    case zz = "d MMMM, EEEE."
    case record = "EE, dd.MM.yy"
    case day = "dd.MM"
    case weekDay = "EEEE"
    case month = "MMM"
    case monthLong = "MMMM"
    case year = "yyyy"
    case cart = "HH:mm, dd.MM.yyyy"
    case bank = "MM/yy"
    case header = "dd MMMM yyyy"
    case shortHeader = "dd MMM"
    case headerTime = "dd MMMM yyyy, HH:mm"
    case transfer = "dd.MM.yyyy\nHH:mm"
    case device = "dd.MM.yyyy HH:mm:ss"
    case period = "MM.yy"
    case fullPeriod = "M.yyyy"
    case monthWithYear = "LLLL yyyy"
    
    // string masks
    
    case iban = "xxxx xxxxxx xxxxx xxxxxxxxxxxxxxx"
    case card = "xxxx xxxx xxxx xxxx"
    case cardWide = "xxxx  xxxx  xxxx  xxxx"
    case cvv = "xxx"
    case phone3 = "xxx xx xxx xx xx"
    case phone8 = "x xxx xxx xx xx"
    case phone0 = "xxx xxx xx xx"
    case phonePlus = "xxx xxx xxx xx xx"
    case phoneOperator = "(xx) xxx xx xx"
    case phoneOperatorForeign = "xxxxxxxxxxxxxxx"
    case mobile = "xxx xx xx"
    
}

class AKFormatter: NSObject {
    
    static func formatter(using format: Format) -> DateFormatter {
        dateFormatter.dateFormat = format.rawValue
        let identifier = NSLocalizedString("current_localization", comment: "")
        dateFormatter.locale = Locale(identifier: identifier)
        return dateFormatter
    }
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    } ()
    
    static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter
    } ()
    
    static func dataFrom(format: Format, string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
    
        return dateFormatter.date(from: string) ?? Date()
    }
    
    static func formatString(string: String, mask: Format) -> String {
        var formatted = ""
        var string = string
        for character in mask.rawValue {
            if string.last == nil { break }
            formatted = character == "x" ? formatted + String(string.first!) : formatted + String(character)
            string = character == "x" ? String(string.dropFirst()) : string
        }
        return formatted
    }
    
}

