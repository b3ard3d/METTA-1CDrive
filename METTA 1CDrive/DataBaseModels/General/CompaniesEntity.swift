//
//  CompaniesEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 21.04.2024.
//

import Foundation
import CoreData

class CompaniesEntity: NSManagedObject {
    
    class func findOrCreate(_ companies: Companies, context: NSManagedObjectContext) throws -> CompaniesEntity {
        
        if let companiesEntity = try? CompaniesEntity.find(uuid: companies.uuid, context: context) {
            return companiesEntity
        } else {
            let companiesEntity = CompaniesEntity(context: context)
            companiesEntity.uuid = companies.uuid
            companiesEntity.name = companies.name
            companiesEntity.tin = companies.tin
            companiesEntity.kpp = companies.kpp
            return companiesEntity
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [CompaniesEntity] {
        
        let request: NSFetchRequest<CompaniesEntity> = CompaniesEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> CompaniesEntity? {
        
        let request: NSFetchRequest<CompaniesEntity> = CompaniesEntity.fetchRequest()
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
