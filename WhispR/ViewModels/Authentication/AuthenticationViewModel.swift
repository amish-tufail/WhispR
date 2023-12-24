//
//  AuthenticationViewModel.swift
//  WhispR
//
//  Created by Amish on 16/07/2023.
//

import Foundation
import SwiftData

@Observable
final class AuthenticationViewModel {
    
    func isUserLoggedIn() -> Bool {
        AuthenticationManager.shared.isUserLoggedIn()
    }
    
    func getUserID() -> String {
        AuthenticationManager.shared.getUserID()
    }
    
    func logOut() {
        AuthenticationManager.shared.logOut()
    }
    
    func getUserPhoneNumber() -> String {
        AuthenticationManager.shared.getUserPhoneNumber()
    }
    
    func sendPhoneNumber(phone: String, completion: @escaping (Error?) -> Void) {
        AuthenticationManager.shared.sendPhoneNumber(phone: phone) { error in
            completion(error)
        }
    }
    
    func verifyCode(code: String, completion: @escaping (Error?) -> Void)  {
        AuthenticationManager.shared.verifyCode(code: code) { error in
            completion(error)
        }
    }
}
