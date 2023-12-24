//
//  ContactsViewModel.swift
//  WhispR
//
//  Created by Amish on 18/07/2023.
//

import Foundation
import SwiftData
import Contacts

@Observable
final class ContactsViewModel {
    // Published properties
    var users: [UserModel] = [] // Will be used to create ContactsView
    
    // Non-Published properties
    private var localContacts: [CNContact] = []
    
    // This method will ask for user permission to get users contact
    // For bringing the pop persmisson go to > Info.plist > add > Privacy - Contacts Usage Description and give it a description
    func getLocalContacts() throws {
        // Requirment to run it on background thread
        DispatchQueue.init(label: "getContacts").async {
            do {
                // Ask for permission
                let store = CNContactStore()
                
                // List the keys we want to get
                let keys = [
                    CNContactPhoneNumbersKey,
                    CNContactGivenNameKey,
                    CNContactFamilyNameKey
                ] as [CNKeyDescriptor]
                
                // Create a fetch request
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                
                // Get the contacts
                try store.enumerateContacts(with: fetchRequest) { contact, success in
                    // Here we get the local contacts, then we sent it to out DB to check which contacts have an account on the app and then return those users
                    self.localContacts.append(contact)
                }
                
                // Here we check which contacts use this app
                Task {
                    let returnedUsers = await DatabaseServices.shared.getPlatformUsers(localContacts: self.localContacts)
                    
                    // Here we then set the fetched user to the user property
                    DispatchQueue.main.async {
                        self.users = returnedUsers
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getParticipants(ids: [String]) -> [UserModel] {
        let foundUsers = users.filter { user in
            if user.id == nil {
                return false
            } else {
                return ids.contains(user.id!)
            }
        }
        return foundUsers
    }
}
