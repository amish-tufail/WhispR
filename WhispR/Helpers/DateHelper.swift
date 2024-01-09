//
//  DateHelper.swift
//  WhispR
//
//  Created by Amish on 26/07/2023.
//
 
import Foundation

class DateHelper {
    static func chatTimestampFrom(date: Date?) -> String {
        guard date != nil else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date!)
    }
}
