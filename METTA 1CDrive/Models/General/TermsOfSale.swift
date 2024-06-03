//
//  TermsOfSale.swift
//  salesManager
//
//  Created by Роман Кокорев on 09.05.2024.
//

import Foundation

struct TermsOfSale: Codable {
    
    var uuid: String
    var name: String
    var contracts_are_used: Bool
    var supply_orders_separately: Bool
    var effective_date: String
    var expiration_date: String
    var owner_uuid: String
    var uuidCompanies: String
    var uuidCounterparties: String
    
    init(uuid: String, name: String, effective_date: String, expiration_date: String, contracts_are_used: Bool, supply_orders_separately: Bool, owner_uuid: String, uuidCompanies: String, uuidCounterparties: String) {
        self.uuid = uuid
        self.name = name
        self.effective_date = effective_date
        self.expiration_date = expiration_date
        self.contracts_are_used = contracts_are_used
        self.supply_orders_separately = supply_orders_separately
        self.owner_uuid = owner_uuid
        self.uuidCompanies = uuidCompanies
        self.uuidCounterparties = uuidCounterparties
    }
    
    init(entity: TermsOfSaleEntity) {
        self.uuid = entity.uuid ?? ""
        self.name = entity.name ?? ""
        self.effective_date = entity.effective_date ?? ""
        self.expiration_date = entity.expiration_date ?? ""
        self.contracts_are_used = entity.contracts_are_used
        self.supply_orders_separately = entity.supply_orders_separately
        self.owner_uuid = entity.owner_uuid ?? ""
        self.uuidCompanies = entity.uuidCompanies ?? ""
        self.uuidCounterparties = entity.uuidCounterparties ?? ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.effective_date = try container.decode(String.self, forKey: .effective_date)
        self.expiration_date = try container.decode(String.self, forKey: .expiration_date)
        self.contracts_are_used = try container.decode(Bool.self, forKey: .contracts_are_used)
        self.supply_orders_separately = try container.decode(Bool.self, forKey: .supply_orders_separately)
        self.owner_uuid = ""
        self.uuidCompanies = ""
        self.uuidCounterparties = ""
    }
}
