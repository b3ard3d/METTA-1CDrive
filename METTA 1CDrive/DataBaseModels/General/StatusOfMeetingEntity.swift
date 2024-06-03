//
//  StatusOfMeetingEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.03.2024.
//

import Foundation
import CoreData

class StatusOfMeetingEntity: NSManagedObject {
    
    class func findOrCreate(_ statusOfMeeting: StatusOfMeeting, context: NSManagedObjectContext) throws -> StatusOfMeetingEntity {
        
        if let statusOfMeetingEntity = try? StatusOfMeetingEntity.find(uuid: statusOfMeeting.uuid, context: context) {
            return statusOfMeetingEntity
        } else {
            let statusOfMeetingEntity = StatusOfMeetingEntity(context: context)
            statusOfMeetingEntity.uuid = statusOfMeeting.uuid
            statusOfMeetingEntity.name = statusOfMeeting.name
            return statusOfMeetingEntity
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [StatusOfMeetingEntity] {
        
        let request: NSFetchRequest<StatusOfMeetingEntity> = StatusOfMeetingEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> StatusOfMeetingEntity? {
        
        let request: NSFetchRequest<StatusOfMeetingEntity> = StatusOfMeetingEntity.fetchRequest()
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
