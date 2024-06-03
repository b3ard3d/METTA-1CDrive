//
//  ContactDetailsContactPersonColdClient.swift
//  salesManager
//
//  Created by Роман Кокорев on 03.02.2024.
//

import Foundation

struct ContactDetailsContactPersonColdClient: Codable {
 
    var kind: String
    var presentation: String
    var owner_uuid: String
    
    init(kind: String, presentation: String, owner_uuid: String) {
        self.kind = kind
        self.presentation = presentation
        self.owner_uuid = owner_uuid
    }
    
    init(entity: ContactDetailsContactPersonColdClientEntity) {
        self.kind = entity.kind ?? ""
        self.presentation = entity.presentation ?? ""
        self.owner_uuid = entity.owner_uuid ?? ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decode(String.self, forKey: .kind)
        self.presentation = try container.decode(String.self, forKey: .presentation)
        self.owner_uuid = ""
    }
}
