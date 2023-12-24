//
//  ChatViewModel.swift
//  WhispR
//
//  Created by Amish on 26/07/2023.
//

import Foundation
import SwiftUI
import SwiftData
import UserNotifications

@Observable
class ChatViewModel {
    var chats: [ChatModel] = []
    var selectedChat: ChatModel?
    var messages: [ChatMessage] = []
    
//    init() {
//        getChats()
//    }
    
    func getChats() {
        DatabaseServices.shared.getAllChats { chats in
            self.chats = chats
        }
    }
    
    func getMessages() {
        guard selectedChat != nil else {
            return
        }
        DatabaseServices.shared.getAllMessages(chat: selectedChat!) { messages in
            self.messages = messages
        }
    }
    
    // This sends only text
    func sendMessage(message: String) {
        guard selectedChat != nil else {
            return
        }
        DatabaseServices.shared.sendMessage(message: message, chat: selectedChat!)
    }
    
//    func sendTextNotification(message: String) {
//        let content = UNMutableNotificationContent()
//        content.title = "New Message"
//        content.subtitle = message
//        content.sound = UNNotificationSound.default
//        content.badge = 1
//
//        // show this notification five seconds from now
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//        // choose a random identifier
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        // add our notification request
//        UNUserNotificationCenter.current().add(request)
//    }
    
    // This send Image
    func sendImageMessage(image: UIImage) {
        guard selectedChat != nil else {
            return
        }
        DatabaseServices.shared.sendPhotoMessage(image: image, chat: selectedChat!)
        print("Photo sent")
    }
    
    func getParticipantsIDs() -> [String] {
        guard selectedChat != nil else {
            return []
        }
        let ids = selectedChat!.participants.filter { id in
            id != AuthenticationManager.shared.getUserID()
        }
        return ids
    }
    
    // This function does two thing, if we are in conversation with a user it loads it else it starts a new chat with that user
//    func getChatFor(contact: UserModel) {
//        guard contact.id != nil else {
//            return
//        }
//        let foundChat = chats.filter { chat in
//            return chat.participantsNumber == 2 && chat.participants.contains(contact.id!)
//        }
//        // If there exists
//        if !foundChat.isEmpty {
//            self.selectedChat = foundChat.first
//            getMessages()
//        } else {
//            let newChat = ChatModel(id: nil, participantsNumber: 2, participants: [AuthenticationManager.shared.getUserID(), contact.id!], lastText: nil, updated: nil, messages: nil)
//            self.selectedChat = newChat
//            DatabaseServices.shared.createChat(chat: newChat) { id in
////                newChat.id = id // We don't need to do this as the @DocumentID wrapper auto fills the id
//                self.selectedChat = ChatModel(id: id, participantsNumber: 2, participants: [AuthenticationManager.shared.getUserID(), contact.id!], lastText: nil, updated: nil, messages: nil)
//                self.chats.append(self.selectedChat!)
//            }
//        }
//    }
    
    func getChatFor(contact: [UserModel]) {
        // Check the users
        for contact in contact {
            if contact.id == nil { return }
        }
        let sefOfContactIds = Set(contact.map({ user in
            user.id!
        }))
        let foundChat = chats.filter { chat in
            let setOfParticipantIds = Set(chat.participants)
            return chat.participantsNumber == contact.count + 1 && sefOfContactIds.isSubset(of: setOfParticipantIds)
        }
        // If there exists
        if !foundChat.isEmpty {
            self.selectedChat = foundChat.first
            getMessages()
        } else {
            // Create no chat if not found
            var allParticipantIds = contact.map({ user in
                user.id!
            })
            allParticipantIds.append(AuthenticationManager.shared.getUserID())
            let newChat = ChatModel(id: nil, participantsNumber: allParticipantIds.count, participants: allParticipantIds, lastText: nil, updated: nil, messages: nil)
            self.selectedChat = newChat
            DatabaseServices.shared.createChat(chat: newChat) { id in
//                newChat.id = id // We don't need to do this as the @DocumentID wrapper auto fills the id
                self.selectedChat = ChatModel(id: id, participantsNumber: allParticipantIds.count, participants: allParticipantIds, lastText: nil, updated: nil, messages: nil)
                self.chats.append(self.selectedChat!)
            }
        }
    }
    
    func closeConversationViewListener() {
        DatabaseServices.shared.detachConversationViewListeners()
    }
    
    func closeChatListViewListener() {
        DatabaseServices.shared.detachChatListViewListeners()
    }
    
    func clearSelectedChat() {
        self.selectedChat = nil
        self.messages.removeAll()
    }
    func deleteChat(chat: ChatModel) {
        DatabaseServices.shared.deleteChat(chat: chat)
    }
}
