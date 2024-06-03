//
//  ContactDetailsPartnerEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 30.01.2024.
//

import Foundation
import CoreData

class ContactDetailsPartnerEntity: NSManagedObject {
    
    class func findOrCreate(_ contactDetailsPartner: ContactDetailsPartner, context: NSManagedObjectContext) throws -> ContactDetailsPartnerEntity? {
        
        let request: NSFetchRequest<ContactDetailsPartnerEntity> = ContactDetailsPartnerEntity.fetchRequest()
        let predicateOwneUUID = NSPredicate(format: "owner_uuid like %@", contactDetailsPartner.owner_uuid)
        let predicateKind = NSPredicate(format: "kind like %@", contactDetailsPartner.kind)
        let predicatePresentation = NSPredicate(format: "presentation like %@", contactDetailsPartner.presentation)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateOwneUUID, predicateKind, predicatePresentation])
        request.predicate = compoundPredicate
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                assert(result.count == 1, "Duplicates in ContactPersonPartnerEntity")
                return result[0]
            }
            
            if let partnerEntity = try PartnerEntity.find(uuid: contactDetailsPartner.owner_uuid, context: context) {
                
                let entity = ContactDetailsPartnerEntity(context: context)
                entity.kind = contactDetailsPartner.kind
                entity.presentation = contactDetailsPartner.presentation
                entity.owner_uuid = contactDetailsPartner.owner_uuid
                entity.partner = partnerEntity
                
                return entity
            }
            
        } catch {
            throw error
        }
        
        return nil
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [ContactDetailsPartnerEntity] {
        
        let request: NSFetchRequest<ContactDetailsPartnerEntity> = ContactDetailsPartnerEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(owner_uuid: String, kind: String, presentation: String, context: NSManagedObjectContext) throws -> ContactDetailsPartnerEntity? {
        
        let request: NSFetchRequest<ContactDetailsPartnerEntity> = ContactDetailsPartnerEntity.fetchRequest()
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
    
    class func findByOwnerUUID(owner_uuid: String, context: NSManagedObjectContext) throws -> [ContactDetailsPartnerEntity] {
        
        let request: NSFetchRequest<ContactDetailsPartnerEntity> = ContactDetailsPartnerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "owner_uuid like %@", owner_uuid)
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
