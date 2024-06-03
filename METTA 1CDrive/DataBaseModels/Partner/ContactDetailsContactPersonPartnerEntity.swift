//
//  ContactDetailsContactPersonPartnerEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 02.02.2024.
//

import Foundation
import CoreData

class ContactDetailsContactPersonPartnerEntity: NSManagedObject {
    
    class func findOrCreate(_ contactDetailsContactPersonPartner: ContactDetailsContactPersonPartner, context: NSManagedObjectContext) throws -> ContactDetailsContactPersonPartnerEntity? {
        
        let request: NSFetchRequest<ContactDetailsContactPersonPartnerEntity> = ContactDetailsContactPersonPartnerEntity.fetchRequest()
        let predicateOwneUUID = NSPredicate(format: "owner_uuid like %@", contactDetailsContactPersonPartner.owner_uuid)
        let predicateKind = NSPredicate(format: "kind like %@", contactDetailsContactPersonPartner.kind)
        let predicatePresentation = NSPredicate(format: "presentation like %@", contactDetailsContactPersonPartner.presentation)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateOwneUUID, predicateKind, predicatePresentation])
        request.predicate = compoundPredicate
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                assert(result.count == 1, "Duplicates in ContactPersonPartnerEntity")
                return result[0]
            }
            
            if let contactPersonPartnerEntity = try ContactPersonPartnerEntity.find(uuid: contactDetailsContactPersonPartner.owner_uuid, context: context) {
                
                let entity = ContactDetailsContactPersonPartnerEntity(context: context)
                entity.kind = contactDetailsContactPersonPartner.kind
                entity.presentation = contactDetailsContactPersonPartner.presentation
                entity.owner_uuid = contactDetailsContactPersonPartner.owner_uuid
                entity.contactPersonPartner = contactPersonPartnerEntity
                
                return entity
            }
            
        } catch {
            throw error
        }
        
        return nil
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [ContactDetailsContactPersonPartnerEntity] {
        
        let request: NSFetchRequest<ContactDetailsContactPersonPartnerEntity> = ContactDetailsContactPersonPartnerEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(owner_uuid: String, kind: String, presentation: String, context: NSManagedObjectContext) throws -> ContactDetailsContactPersonPartnerEntity? {
        
        let request: NSFetchRequest<ContactDetailsContactPersonPartnerEntity> = ContactDetailsContactPersonPartnerEntity.fetchRequest()
        let predicateOwneUUID = NSPredicate(format: "owner_uuid like %@", owner_uuid)
        let predicateKind = NSPredicate(format: "kind like %@", kind)
        let predicatePresentation = NSPredicate(format: "presentation like %@", presentation)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateOwneUUID, predicateKind, predicatePresentation])
        request.predicate = compoundPredicate
        
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
    
    class func findByOwnerUUID(owner_uuid: String, context: NSManagedObjectContext) throws -> [ContactDetailsContactPersonPartnerEntity] {
        
        let request: NSFetchRequest<ContactDetailsContactPersonPartnerEntity> = ContactDetailsContactPersonPartnerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "owner_uuid like %@", owner_uuid)
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
