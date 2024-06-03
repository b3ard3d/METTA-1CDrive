//
//  CounterpartiesEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 09.05.2024.
//

import Foundation
import CoreData

class CounterpartiesEntity: NSManagedObject {
    
    class func findOrCreate(_ counterparties: Counterparties, context: NSManagedObjectContext) throws -> CounterpartiesEntity {
        
        if let counterpartiesEntity = try? CounterpartiesEntity.find(uuid: counterparties.uuid, context: context) {
            return counterpartiesEntity
        } else {
            let counterpartiesEntity = CounterpartiesEntity(context: context)
            counterpartiesEntity.uuid = counterparties.uuid
            counterpartiesEntity.name = counterparties.name
            counterpartiesEntity.tin = counterparties.tin
            counterpartiesEntity.kpp = counterparties.kpp
            counterpartiesEntity.owner_uuid = counterparties.owner_uuid
            return counterpartiesEntity
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [CounterpartiesEntity] {
        
        let request: NSFetchRequest<CounterpartiesEntity> = CounterpartiesEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> CounterpartiesEntity? {
        
        let request: NSFetchRequest<CounterpartiesEntity> = CounterpartiesEntity.fetchRequest()
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
    
    class func findByOwnerUUID(owner_uuid: String, context: NSManagedObjectContext) throws -> [CounterpartiesEntity] {
        
        let request: NSFetchRequest<CounterpartiesEntity> = CounterpartiesEntity.fetchRequest()
        request.predicate = NSPredicate(format: "owner_uuid like %@", owner_uuid)
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func findUUIDByName(name: String, context: NSManagedObjectContext) throws -> [CounterpartiesEntity] {
        
        let request: NSFetchRequest<CounterpartiesEntity> = CounterpartiesEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name like %@", name)
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
