//
//  AuthenticationManager.swift
//  WhispR
//
//  Created by Amish on 16/07/2023.
//

import Foundation
import FirebaseAuth

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }
    
    func isUserLoggedIn() -> Bool {
        Auth.auth().currentUser != nil
    }
    
    func getUserID() -> String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()            
        } catch {
            print("Log out error: \(error)")
        }
    }
    
    func getUserPhoneNumber() -> String {
        Auth.auth().currentUser?.phoneNumber ?? ""
    }
    
    func sendPhoneNumber(phone: String, completion: @escaping (Error?) -> Void) {
        
        // Send the phone number to Firebase Auth
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationId, error in
            
            if error == nil {
                // Got the verification id
                UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
            }
            DispatchQueue.main.async {
                // Notify the UI
                completion(error)
            }
        }
    }
    
    func verifyCode(code: String, completion: @escaping (Error?) -> Void) {
        
        // Get the verification id from local storage
        let verificationId = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        
        // Send the code and the verification id to Firebase
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationId,
          verificationCode: code
        )
        
        // Sign in the user
        Auth.auth().signIn(with: credential) { authResult, error in
            DispatchQueue.main.async {
                // Notify the UI
                completion(error)
            }
        }
    }
}
