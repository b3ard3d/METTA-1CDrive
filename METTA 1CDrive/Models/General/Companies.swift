//
//  Companies.swift
//  salesManager
//
//  Created by Роман Кокорев on 21.04.2024.
//

import Foundation

struct Companies: Codable {
    
    var uuid: String
    var name: String
    var tin: String
    var kpp: String
    
    init(uuid: String, name: String, tin: String, kpp: String) {
        self.uuid = uuid
        self.name = name
        self.tin = tin
        self.kpp = kpp
    }
    
    init(entity: CompaniesEntity) {
        self.uuid = entity.uuid ?? ""
        self.name = entity.name ?? ""
        self.tin = entity.tin ?? ""
        self.kpp = entity.kpp ?? ""
    }
    
}
