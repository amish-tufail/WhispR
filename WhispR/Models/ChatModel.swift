//
//  ChatModel.swift
//  WhispR
//
//  Created by Amish on 24/07/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatModel: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var participantsNumber: Int
    var participants: [String]
    var lastText: String?
    @ServerTimestamp var updated: Date?
    var messages: [ChatMessage]?
    
    init(id: String? = nil, participantsNumber: Int, participants: [String], lastText: String? = nil, updated: Date? = nil, messages: [ChatMessage]? = nil) {
        self.id = id
        self.participantsNumber = participantsNumber
        self.participants = participants
        self.lastText = lastText
        self.updated = updated
        self.messages = messages
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.participantsNumber = try container.decode(Int.self, forKey: .participantsNumber)
        self.participants = try container.decode([String].self, forKey: .participants)
        self.lastText = try container.decodeIfPresent(String.self, forKey: .lastText)
        self._updated = try container.decode(ServerTimestamp<Date>.self, forKey: .updated)
        self.messages = try container.decodeIfPresent([ChatMessage].self, forKey: .messages)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case participantsNumber = "participants_number"
        case participants = "participants"
        case lastText = "last_text"
        case updated = "updated"
        case messages = "messages"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self._id, forKey: .id)
        try container.encode(self.participantsNumber, forKey: .participantsNumber)
        try container.encode(self.participants, forKey: .participants)
        try container.encodeIfPresent(self.lastText, forKey: .lastText)
        try container.encode(self._updated, forKey: .updated)
        try container.encodeIfPresent(self.messages, forKey: .messages)
    }
}

struct ChatMessage: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var imageURL: String?
    var message: String
    var senderID: String
    @ServerTimestamp var timeStamp: Date?
    
    init(id: String? = nil, imageURL: String? = nil, message: String, senderID: String, timeStamp: Date? = nil) {
        self.id = id
        self.imageURL = imageURL
        self.message = message
        self.senderID = senderID
        self.timeStamp = timeStamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.message = try container.decode(String.self, forKey: .message)
        self.senderID = try container.decode(String.self, forKey: .senderID)
        self._timeStamp = try container.decode(ServerTimestamp<Date>.self, forKey: .timeStamp)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageURL = "image_url"
        case message = "message"
        case senderID = "sender_id"
        case timeStamp = "timestamp"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self._id, forKey: .id)
        try container.encodeIfPresent(self.imageURL, forKey: .imageURL)
        try container.encode(self.message, forKey: .message)
        try container.encode(self.senderID, forKey: .senderID)
        try container.encode(self._timeStamp, forKey: .timeStamp)
    }
}
