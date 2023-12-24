//
//  UserModel.swift
//  WhispR
//
//  Created by Amish on 18/07/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct UserModel: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var givenName: String?
    var lastName: String?
    var phoneNumber: String?
    var photo: String?
    
    init(id: String? = nil, givenName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, photo: String? = nil) {
        self.id = id
        self.givenName = givenName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.photo = photo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(DocumentID<String>.self, forKey: .id)
        self.givenName = try container.decodeIfPresent(String.self, forKey: .givenName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.photo = try container.decodeIfPresent(String.self, forKey: .photo)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case givenName = "given_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case photo = "photo"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self._id, forKey: .id)
        try container.encodeIfPresent(self.givenName, forKey: .givenName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(self.photo, forKey: .photo)
    }
}
