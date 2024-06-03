//
//  StatusOfClient.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.03.2024.
//

import Foundation

struct StatusOfClient: Codable {
    
    var uuid: String
    var name: String
    
    init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
    }
    
    init(entity: StatusOfClientEntity) {
        self.uuid = entity.uuid ?? ""
        self.name = entity.name ?? ""
    }
}
