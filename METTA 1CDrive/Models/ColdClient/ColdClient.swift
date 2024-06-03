//
//  ColdClient.swift
//  salesManager
//
//  Created by Роман Кокорев on 11.01.2024.
//

import Foundation

struct ColdClient: Codable {
    
    var uuid: String
    var name: String
    
    init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
    }
    
    init(entity: ColdClientEntity) {
        self.uuid = entity.uuid ?? ""
        self.name = entity.name ?? ""
    }
}
