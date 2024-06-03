//
//  ContactDetailsColdClientEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 31.01.2024.
//

import Foundation
import CoreData

class ContactDetailsColdClientEntity: NSManagedObject {
    
    class func findOrCreate(_ contactDetailsColdClient: ContactDetailsColdClient, context: NSManagedObjectContext) throws -> ContactDetailsColdClientEntity? {
        
        let request: NSFetchRequest<ContactDetailsColdClientEntity> = ContactDetailsColdClientEntity.fetchRequest()
        let predicateOwneUUID = NSPredicate(format: "owner_uuid like %@", contactDetailsColdClient.owner_uuid)
        let predicateKind = NSPredicate(format: "kind like %@", contactDetailsColdClient.kind)
        let predicatePresentation = NSPredicate(format: "presentation like %@", contactDetailsColdClient.presentation)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateOwneUUID, predicateKind, predicatePresentation])
        request.predicate = compoundPredicate
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                assert(result.count == 1, "Duplicates in ContactPersonPartnerEntity")
                return result[0]
            }
            
            if let coldClientEntity = try ColdClientEntity.find(uuid: contactDetailsColdClient.owner_uuid, context: context) {
                
                let entity = ContactDetailsColdClientEntity(context: context)
                entity.kind = contactDetailsColdClient.kind
                entity.presentation = contactDetailsColdClient.presentation
                entity.owner_uuid = contactDetailsColdClient.owner_uuid
                entity.coldClient = coldClientEntity
                
                return entity
            }
            
        } catch {
            throw error
        }
        
        return nil
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [ContactDetailsColdClientEntity] {
        
        let request: NSFetchRequest<ContactDetailsColdClientEntity> = ContactDetailsColdClientEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(owner_uuid: String, kind: String, presentation: String, context: NSManagedObjectContext) throws -> ContactDetailsColdClientEntity? {
        
        let request: NSFetchRequest<ContactDetailsColdClientEntity> = ContactDetailsColdClientEntity.fetchRequest()
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
    
    class func findByOwnerUUID(owner_uuid: String, context: NSManagedObjectContext) throws -> [ContactDetailsColdClientEntity] {
        
        let request: NSFetchRequest<ContactDetailsColdClientEntity> = ContactDetailsColdClientEntity.fetchRequest()
        request.predicate = NSPredicate(format: "owner_uuid like %@", owner_uuid)
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
