//
//  ContactPersonColdClientEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 11.01.2024.
//

import Foundation
import CoreData

class ContactPersonColdClientEntity: NSManagedObject {
    
    class func findOrCreate(_ contactPersonColdClient: ContactPersonColdClient, context: NSManagedObjectContext) throws -> ContactPersonColdClientEntity? {
        
        let request: NSFetchRequest<ContactPersonColdClientEntity> = ContactPersonColdClientEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uuid like %@", contactPersonColdClient.uuid)
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                assert(result.count == 1, "Duplicates in ContactPersonPartnerEntity")
                return result[0]
            }
            
            if let coldClientEntity = try ColdClientEntity.find(uuid: contactPersonColdClient.owner_uuid, context: context) {
                
                let entity = ContactPersonColdClientEntity(context: context)
                entity.uuid = contactPersonColdClient.uuid
                entity.name = contactPersonColdClient.name
                entity.owner_uuid = contactPersonColdClient.owner_uuid
                entity.coldClient = coldClientEntity
                
                return entity
            }
            
        } catch {
            throw error
        }
        
        return nil
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [ContactPersonColdClientEntity] {
        
        let request: NSFetchRequest<ContactPersonColdClientEntity> = ContactPersonColdClientEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> ContactPersonColdClientEntity? {
        
        let request: NSFetchRequest<ContactPersonColdClientEntity> = ContactPersonColdClientEntity.fetchRequest()
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
    
    class func findByOwnerUUID(owner_uuid: String, context: NSManagedObjectContext) throws -> [ContactPersonColdClientEntity] {
        
        let request: NSFetchRequest<ContactPersonColdClientEntity> = ContactPersonColdClientEntity.fetchRequest()
        request.predicate = NSPredicate(format: "owner_uuid like %@", owner_uuid)
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
