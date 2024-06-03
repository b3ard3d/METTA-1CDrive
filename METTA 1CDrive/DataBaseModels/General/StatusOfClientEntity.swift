//
//  StatusOfClientEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.03.2024.
//

import Foundation
import CoreData

class StatusOfClientEntity: NSManagedObject {
    
    class func findOrCreate(_ statusOfClient: StatusOfClient, context: NSManagedObjectContext) throws -> StatusOfClientEntity {
        
        if let statusOfClientEntity = try? StatusOfClientEntity.find(uuid: statusOfClient.uuid, context: context) {
            return statusOfClientEntity
        } else {
            let statusOfClientEntity = StatusOfClientEntity(context: context)
            statusOfClientEntity.uuid = statusOfClient.uuid
            statusOfClientEntity.name = statusOfClient.name
            return statusOfClientEntity
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [StatusOfClientEntity] {
        
        let request: NSFetchRequest<StatusOfClientEntity> = StatusOfClientEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> StatusOfClientEntity? {
        
        let request: NSFetchRequest<StatusOfClientEntity> = StatusOfClientEntity.fetchRequest()
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
