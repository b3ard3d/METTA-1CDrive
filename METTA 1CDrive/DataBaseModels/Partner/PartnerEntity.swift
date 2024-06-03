//
//  PartnerEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 26.12.2023.
//

import Foundation
import CoreData

class PartnerEntity: NSManagedObject {
    
    class func findOrCreate(_ partner: Partner, context: NSManagedObjectContext) throws -> PartnerEntity {
        
        if let partnerEntity = try? PartnerEntity.find(uuid: partner.uuid, context: context) {
            return partnerEntity
        } else {
            let partnerEntity = PartnerEntity(context: context)
            partnerEntity.uuid = partner.uuid
            partnerEntity.name = partner.name
            return partnerEntity
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [PartnerEntity] {
        
        let request: NSFetchRequest<PartnerEntity> = PartnerEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> PartnerEntity? {
        
        let request: NSFetchRequest<PartnerEntity> = PartnerEntity.fetchRequest()
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
    
    class func findByName(name: String, context: NSManagedObjectContext) throws -> PartnerEntity? {
        
        let request: NSFetchRequest<PartnerEntity> = PartnerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name like %@", name)
        
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
