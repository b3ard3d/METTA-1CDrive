//
//  UserDefaults.swift
//  salesManager
//
//  Created by Роман Кокорев on 23.04.2024.
//

import Foundation

extension UserDefaults {
    var contactDetailsPartner: [String: String] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "SavedJsonContactDetailsPartnerData") else { return [:] }
            return (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)) as? [String: String] ?? [:]
        }
        set {
            UserDefaults.standard.set(try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false), forKey: "SavedJsonContactDetailsPartnerData")
        }
    }
}
