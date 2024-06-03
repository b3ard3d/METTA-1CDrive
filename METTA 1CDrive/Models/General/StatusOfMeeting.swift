//
//  StatusOfMeeting.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.03.2024.
//

import Foundation

struct StatusOfMeeting: Codable {
    
    var uuid: String
    var name: String
    
    init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
    }
    
    init(entity: StatusOfMeetingEntity) {
        self.uuid = entity.uuid ?? ""
        self.name = entity.name ?? ""
    }
}