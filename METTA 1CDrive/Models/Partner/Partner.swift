//
//  Partner.swift
//  salesManager
//
//  Created by Роман Кокорев on 26.12.2023.
//

import Foundation

struct Partner: Codable {
    
    var uuid: String
    var name: String
    
    init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
    }
    
    init(entity: PartnerEntity) {
        self.uuid = entity.uuid ?? ""
        self.name = entity.name ?? ""
    }
}
