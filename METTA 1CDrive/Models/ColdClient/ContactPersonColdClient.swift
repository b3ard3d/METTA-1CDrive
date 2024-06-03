//
//  ContactPersonColdClient.swift
//  salesManager
//
//  Created by Роман Кокорев on 11.01.2024.
//

import Foundation

struct ContactPersonColdClient: Codable {
    
    let uuid: String
    var name: String
    var owner_uuid: String
    
    init(uuid: String, name: String, owner_uuid: String) {
        self.uuid = uuid
        self.name = name
        self.owner_uuid = owner_uuid
    }
    
    init(entity: ContactPersonColdClientEntity) {
        self.uuid = entity.uuid ?? ""
        self.name = entity.name ?? ""
        self.owner_uuid = entity.owner_uuid ?? ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.owner_uuid = ""
    }
    
}
