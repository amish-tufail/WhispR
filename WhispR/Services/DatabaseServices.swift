//
//  DatabaseServices.swift
//  WhispR
//
//  Created by Amish on 18/07/2023.
//

import Foundation
import Contacts
import Firebase
import FirebaseFirestore
import FirebaseStorage
import UIKit
import FirebaseAuth

final class DatabaseServices {
    
    static let shared: DatabaseServices = DatabaseServices() // Singleton Pattern
    
    let db = Firestore.firestore()
    
    var chatListViewListener = [ListenerRegistration]()
    var conversationViewListener = [ListenerRegistration]()
    var mainUser: UserModel = UserModel(givenName: "Test", lastName: "User 1", phoneNumber: "11231231234", photo: "https://firebasestorage.googleapis.com:443/v0/b/whispr-d02bb.appspot.com/o/profileImages%2FDEE071D0-11B7-49D5-B6AB-8E44B33C0FAB.jpg?alt=media&token=3d5e6009-1e86-4658-a585-645ccb0b0144")
    
    func getPlatformUsers(localContacts: [CNContact]) async -> [UserModel] {
        var platformUsers: [UserModel] = [] // Create to append the user and then return them
        
        // This returns phone numbers in String format
        var phoneNumbers = localContacts.map { contact in
            return PhoneNumber.santizePhoneNumber(as: contact.phoneNumbers.first?.value.stringValue ?? "")
        }
        
        // Here we check whether there were any contacts in the phone or not
        guard phoneNumbers.count > 0  else {
            print("No Phone Numbers found!")
            return []
        }
        
        while !phoneNumbers.isEmpty {
            let tenNumbers = Array(phoneNumbers.prefix(10)) // This returns the first ten phone numbers from the array
            phoneNumbers = Array(phoneNumbers.dropFirst(10)) // This removes first ten contacts from the array
            let collection = db.collection("users")
            // Here we fetch those documents whose phoneNumeber field matched the phone numbers in the array
            let query = collection
                .whereField("phone_number", in: tenNumbers)
            do {
                let snapshot = try await query.getDocuments()
                // After getting the documents we decode them using UserModel and then append them into the array
                for document in snapshot.documents {
                    if let user = try? document.data(as: UserModel.self) {
                        // NEW
                        if user.id != AuthenticationManager.shared.getUserID() {
                            platformUsers.append(user)
                        }
                        if user.id == AuthenticationManager.shared.getUserID() {
                            mainUser = user
                        }
                        // OLD
//                        platformUsers.append(user)
                    }
                }
                
            } catch {
                print("Failed to fetch Phone Numbers form DB.")
            }
        }
        // This returns those contacts that match with users local contact in the DB
        return platformUsers
    }
    
    func setUserProfile(firstName: String, lastName: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        // Get a reference to Firestore
        let db = Firestore.firestore()
        // Set the profile data
        let doc = db.collection("users").document(AuthenticationManager.shared.getUserID())
        doc.setData(["given_name": firstName,
                     "last_name": lastName,
                     "phone_number" : PhoneNumber.santizePhoneNumber(as: AuthenticationManager.shared.getUserPhoneNumber())
                    ])
        // Check if an image is passed through
        if let image = image {
            // Create storage reference
            let storageRef = Storage.storage().reference()
            // Turn our image into data
            let imageData = image.jpegData(compressionQuality: 0.8)
            // Check that we were able to convert it to data
            guard imageData != nil else {
                return
            }
            // Specify the file path and name
            let path = "profileImages/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(path)
            let _ = fileRef.putData(imageData!, metadata: nil) { meta, error in
                if error == nil && meta != nil
                {
                    // Get Image URL
                    fileRef.downloadURL { url, error in
                        if url != nil && error == nil {
                            // Set that image path to the profile
                            doc.setData(["photo": url!.absoluteString], merge: true) { error in
                                if error == nil {
                                    // Success, notify caller
                                    completion(true)
                                }
                            }
                        } else {
                            completion(false)
                        }
                    }
                }
                else {
                    // Upload wasn't successful, notify caller
                    completion(true)
                }
            }
        }
    }
    
    func checkUserProfile(completion: @escaping (Bool) -> ()) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        db.collection("users").document(AuthenticationManager.shared.getUserID()).getDocument { snapshot, error in
            if let snapshot = snapshot, error == nil {
                completion(snapshot.exists)
            } else {
                completion(false)
            }
        }
    }
    
    // This returns the chat in which the current user is participating
    func getAllChats(completion: @escaping ([ChatModel]) -> ()) {
        
        let chatsQuery = db.collection("chats")
            .whereField("participants", arrayContains: AuthenticationManager.shared.getUserID())
//        chatsQuery.getDocuments { snapshot, error in
        let listner = chatsQuery.addSnapshotListener { snapshot, error in
            if error == nil, let snapshot = snapshot {
                var chats: [ChatModel] = []
                for document in snapshot.documents {
                    do {
                        let chat = try document.data(as: ChatModel.self)
                        chats.append(chat)
                    } catch {
                        print(error)
                    }
                }
                completion(chats)
            } else {
                print("Error in fetching chats.")
            }
        }
        // Keep track of listener
        chatListViewListener.append(listner)
    }
    
    // This returns the messages in a chat
    func getAllMessages(chat: ChatModel, completion: @escaping ([ChatMessage]) -> ()) {
        guard chat.id != nil else {
            completion([])
            return
        }
        let messageQuery = db.collection("chats")
            .document(chat.id!)
            .collection("messages")
            .order(by: "timestamp")
//        messageQuery.getDocuments { snapshot, error in // This only is a one time fetch method
        let listner = messageQuery.addSnapshotListener { snapshot, error in // This provides real-time updates
            if error == nil, let snapshot = snapshot {
                var messages: [ChatMessage] = []
                for document in snapshot.documents {
                    do {
                        let message = try document.data(as: ChatMessage.self)
                        messages.append(message)
                    } catch {
                        print(error)
                    }
                }
                completion(messages)
            } else {
                print("Error in fetching messages.")
            }
        }
        conversationViewListener.append(listner)
    }
    
    // This sends text
    func sendMessage(message: String, chat: ChatModel) {
        guard chat.id != nil else {
            return
        }
        
        let data: [String : Any] = [
            "image_url" : "",
            "message" : message,
            "sender_id" : AuthenticationManager.shared.getUserID(),
            "timestamp" : Date()
        ]
        
        // Update last message and date
        db.collection("chats").document(chat.id!).collection("messages").addDocument(data: data) // This adds a new message
        
        db.collection("chats") // This updates the date and last text in the document to show in the chat list
            .document(chat.id!)
            .setData([
                "updated" : Date(),
                "last_text" : message
            ], merge: true)
    }
    
    // This sends photo
    func sendPhotoMessage(image: UIImage, chat: ChatModel) {
        guard chat.id != nil else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageData = image.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        let path = "chatImages/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        let _ = fileRef.putData(imageData!, metadata: nil) { meta, error in
            if error == nil && meta != nil  {
                fileRef.downloadURL { url, error in
                    if url != nil && error == nil {
                        // Store the message or send it
                        
                        let data: [String : Any] = [
                            "image_url" : url!.absoluteString,
                            "message" : "",
                            "sender_id" : AuthenticationManager.shared.getUserID(),
                            "timestamp" : Date()
                        ]
                        
                        // Update last message and date
                        self.db.collection("chats").document(chat.id!).collection("messages").addDocument(data: data) // This adds a new message
                        
                        self.db.collection("chats") // This updates the date and last text in the document to show in the chat list
                            .document(chat.id!)
                            .setData([
                                "updated" : Date(),
                                "last_text" : "Sent a photo"
                            ], merge: true)
                        
                    }
                }
            }
        }
    }
    
    func createChat(chat: ChatModel, completion: @escaping (String) -> Void) {
        // Create a document
        let document = db.collection("chats").document()
        
        // Set the data for the document
        try? document.setData(from: chat, completion: { error in
            
            // Communicate the document id
            completion(document.documentID)
        })
    }
    
    func detachChatListViewListeners() {
        for listener in chatListViewListener {
            listener.remove()
        }
    }
    
    func detachConversationViewListeners() {
        for listener in conversationViewListener {
            listener.remove()
        }
    }
    
    func deactivateAccount(completion: @escaping () -> ()) {
        guard AuthenticationManager.shared.isUserLoggedIn() else {
            return
        }
        
        db.collection("users").document(AuthenticationManager.shared.getUserID()).setData(["is_active": false, "given_name" : "Deleted", "last_name" : "User"], merge: true) { error in
            if error == nil {
                completion()
            }
        }
    }
    
    func updateProfile(firstName: String, lastName: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        // Get a reference to Firestore
        let db = Firestore.firestore()
        // Set the profile data
        let doc = db.collection("users").document(AuthenticationManager.shared.getUserID())
//        doc.setData(["given_name": firstName == nil ? mainUser.givenName! : firstName!,
//                     "last_name": lastName == nil ? mainUser.lastName! : lastName!,
//                     "phone_number" : PhoneNumber.santizePhoneNumber(as: AuthenticationManager.shared.getUserPhoneNumber())
//                    ], merge: true)
        doc.setData(["given_name": firstName,
                        "last_name": lastName,
                        "phone_number" : PhoneNumber.santizePhoneNumber(as: AuthenticationManager.shared.getUserPhoneNumber())
                       ], merge: true)
        // Check if an image is passed through
        if let image = image {
            // Create storage reference
            let storageRef = Storage.storage().reference()
            // Turn our image into data
            let imageData = image.jpegData(compressionQuality: 0.8)
            // Check that we were able to convert it to data
            guard imageData != nil else {
                return
            }
            // Specify the file path and name
            let path = "profileImages/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(path)
            let _ = fileRef.putData(imageData!, metadata: nil) { meta, error in
                if error == nil && meta != nil
                {
                    // Get Image URL
                    fileRef.downloadURL { url, error in
                        if url != nil && error == nil {
                            // Set that image path to the profile
                            doc.setData(["photo": url!.absoluteString], merge: true) { error in
                                if error == nil {
                                    // Success, notify caller
                                    completion(true)
                                }
                            }
                        } else {
                            completion(false)
                        }
                    }
                }
                else {
                    // Upload wasn't successful, notify caller
                    completion(true)
                }
            }
        }
    }
    func deleteChat(chat: ChatModel) {
        db.collection("chats").document(chat.id ?? "").delete()
    }
    
    func getName() -> String {
        Auth.auth().currentUser?.displayName ?? ""
    }
}
