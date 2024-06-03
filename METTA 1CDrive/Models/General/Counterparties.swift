//
//  Counterparties.swift
//  salesManager
//
//  Created by Роман Кокорев on 09.05.2024.
//

import Foundation

struct Counterparties: Codable {
    
    var uuid: String
    var name: String
    var tin: String
    var kpp: String
    var owner_uuid: String
    
    init(uuid: String, name: String, tin: String, kpp: String, owner_uuid: String) {
        self.uuid = uuid
        self.name = name
        self.tin = tin
        self.kpp = kpp
        self.owner_uuid = owner_uuid
    }
    
    init(entity: CounterpartiesEntity) {
        self.uuid = entity.uuid ?? ""
        self.name = entity.name ?? ""
        self.tin = entity.tin ?? ""
        self.kpp = entity.kpp ?? ""
        self.owner_uuid = entity.owner_uuid ?? ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.tin = try container.decode(String.self, forKey: .tin)
        self.kpp = try container.decode(String.self, forKey: .kpp)
        self.owner_uuid = ""
    }
}
