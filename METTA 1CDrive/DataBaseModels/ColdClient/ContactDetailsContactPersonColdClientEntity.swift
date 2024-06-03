//
//  ContactDetailsContactPersonColdClientEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 03.02.2024.
//

import Foundation
import CoreData

class ContactDetailsContactPersonColdClientEntity: NSManagedObject {
    
    class func findOrCreate(_ contactDetailsContactPersonColdClient: ContactDetailsContactPersonColdClient, context: NSManagedObjectContext) throws -> ContactDetailsContactPersonColdClientEntity? {
        
        let request: NSFetchRequest<ContactDetailsContactPersonColdClientEntity> = ContactDetailsContactPersonColdClientEntity.fetchRequest()
        let predicateOwneUUID = NSPredicate(format: "owner_uuid like %@", contactDetailsContactPersonColdClient.owner_uuid)
        let predicateKind = NSPredicate(format: "kind like %@", contactDetailsContactPersonColdClient.kind)
        let predicatePresentation = NSPredicate(format: "presentation like %@", contactDetailsContactPersonColdClient.presentation)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateOwneUUID, predicateKind, predicatePresentation])
        request.predicate = compoundPredicate
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                assert(result.count == 1, "Duplicates in ContactPersonPartnerEntity")
                return result[0]
            }
            
            if let contactPersonColdClientEntity = try ContactPersonColdClientEntity.find(uuid: contactDetailsContactPersonColdClient.owner_uuid, context: context) {
                
                let entity = ContactDetailsContactPersonColdClientEntity(context: context)
                entity.kind = contactDetailsContactPersonColdClient.kind
                entity.presentation = contactDetailsContactPersonColdClient.presentation
                entity.owner_uuid = contactDetailsContactPersonColdClient.owner_uuid
                entity.contactPersonColdClient = contactPersonColdClientEntity
                
                return entity
            }
            
        } catch {
            throw error
        }
        
        return nil
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [ContactDetailsContactPersonColdClientEntity] {
        
        let request: NSFetchRequest<ContactDetailsContactPersonColdClientEntity> = ContactDetailsContactPersonColdClientEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(owner_uuid: String, kind: String, presentation: String, context: NSManagedObjectContext) throws -> ContactDetailsContactPersonColdClientEntity? {
        
        let request: NSFetchRequest<ContactDetailsContactPersonColdClientEntity> = ContactDetailsContactPersonColdClientEntity.fetchRequest()
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
    
    class func findByOwnerUUID(owner_uuid: String, context: NSManagedObjectContext) throws -> [ContactDetailsContactPersonColdClientEntity] {
        
        let request: NSFetchRequest<ContactDetailsContactPersonColdClientEntity> = ContactDetailsContactPersonColdClientEntity.fetchRequest()
        request.predicate = NSPredicate(format: "owner_uuid like %@", owner_uuid)
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
