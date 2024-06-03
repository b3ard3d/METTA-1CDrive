//
//  ContactPersonPartnerEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 28.12.2023.
//

import Foundation
import CoreData

class ContactPersonPartnerEntity: NSManagedObject {
    
    class func findOrCreate(_ contactPersonPartner: ContactPersonPartner, context: NSManagedObjectContext) throws -> ContactPersonPartnerEntity? {
        
        let request: NSFetchRequest<ContactPersonPartnerEntity> = ContactPersonPartnerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uuid like %@", contactPersonPartner.uuid)
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                assert(result.count == 1, "Duplicates in ContactPersonPartnerEntity")
                return result[0]
            }
            
            if let partnerEntity = try PartnerEntity.find(uuid: contactPersonPartner.owner_uuid, context: context) {
                
                let entity = ContactPersonPartnerEntity(context: context)
                entity.uuid = contactPersonPartner.uuid
                entity.name = contactPersonPartner.name
                entity.owner_uuid = contactPersonPartner.owner_uuid
                entity.partner = partnerEntity
                
                return entity
            }
            
        } catch {
            throw error
        }
        
        return nil
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [ContactPersonPartnerEntity] {
        
        let request: NSFetchRequest<ContactPersonPartnerEntity> = ContactPersonPartnerEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> ContactPersonPartnerEntity? {
        
        let request: NSFetchRequest<ContactPersonPartnerEntity> = ContactPersonPartnerEntity.fetchRequest()
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
    
    class func findByOwnerUUID(owner_uuid: String, context: NSManagedObjectContext) throws -> [ContactPersonPartnerEntity] {
        
        let request: NSFetchRequest<ContactPersonPartnerEntity> = ContactPersonPartnerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "owner_uuid like %@", owner_uuid)
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
