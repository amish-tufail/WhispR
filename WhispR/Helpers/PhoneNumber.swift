//
//  PhoneNumber.swift
//  WhispR
//
//  Created by Amish on 18/07/2023.
//

import Foundation

struct PhoneNumber {
    static func santizePhoneNumber(as phone: String) -> String {
        return phone
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
    }
}
