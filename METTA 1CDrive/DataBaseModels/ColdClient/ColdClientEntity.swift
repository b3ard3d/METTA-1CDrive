//
//  ColdClientEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 11.01.2024.
//

import Foundation
import CoreData

class ColdClientEntity: NSManagedObject {
    
    class func findOrCreate(_ coldClient: ColdClient, context: NSManagedObjectContext) throws -> ColdClientEntity {
        
        if let coldClientEntity = try? ColdClientEntity.find(uuid: coldClient.uuid, context: context) {
            return coldClientEntity
        } else {
            let coldClientEntity = ColdClientEntity(context: context)
            coldClientEntity.uuid = coldClient.uuid
            coldClientEntity.name = coldClient.name
            return coldClientEntity
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [ColdClientEntity] {
        
        let request: NSFetchRequest<ColdClientEntity> = ColdClientEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> ColdClientEntity? {
        
        let request: NSFetchRequest<ColdClientEntity> = ColdClientEntity.fetchRequest()
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
