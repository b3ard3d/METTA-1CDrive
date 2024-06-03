//
//  PurposeOfContactEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.03.2024.
//

import Foundation
import CoreData

class PurposeOfContactEntity: NSManagedObject {
    
    class func findOrCreate(_ purposeOfContact: PurposeOfContact, context: NSManagedObjectContext) throws -> PurposeOfContactEntity {
        
        if let purposeOfContactEntity = try? PurposeOfContactEntity.find(uuid: purposeOfContact.uuid, context: context) {
            return purposeOfContactEntity
        } else {
            let purposeOfContactEntity = PurposeOfContactEntity(context: context)
            purposeOfContactEntity.uuid = purposeOfContact.uuid
            purposeOfContactEntity.name = purposeOfContact.name
            return purposeOfContactEntity
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [PurposeOfContactEntity] {
        
        let request: NSFetchRequest<PurposeOfContactEntity> = PurposeOfContactEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> PurposeOfContactEntity? {
        
        let request: NSFetchRequest<PurposeOfContactEntity> = PurposeOfContactEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uuid like %@", uuid)
        
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0 {
                assert(fetchResult.count == 1, "Duplicate has been found in DB")
                return fetchResult[0]
            }
        } catch {
            throw error
        }
        
        return nil
    }
}
