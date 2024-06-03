//
//  TermsOfSaleEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 09.05.2024.
//

import Foundation
import CoreData

class TermsOfSaleEntity: NSManagedObject {
    
    class func findOrCreate(_ termsOfSale: TermsOfSale, context: NSManagedObjectContext) throws -> TermsOfSaleEntity {
        
        if let termsOfSaleEntity = try? TermsOfSaleEntity.find(uuid: termsOfSale.uuid, context: context) {
            return termsOfSaleEntity
        } else {
            let termsOfSaleEntity = TermsOfSaleEntity(context: context)
            termsOfSaleEntity.uuid = termsOfSale.uuid
            termsOfSaleEntity.name = termsOfSale.name
            termsOfSaleEntity.effective_date = termsOfSale.effective_date
            termsOfSaleEntity.expiration_date = termsOfSale.expiration_date
            termsOfSaleEntity.contracts_are_used = termsOfSale.contracts_are_used
            termsOfSaleEntity.supply_orders_separately = termsOfSale.supply_orders_separately
            return termsOfSaleEntity
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [TermsOfSaleEntity] {
        
        let request: NSFetchRequest<TermsOfSaleEntity> = TermsOfSaleEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> TermsOfSaleEntity? {
        
        let request: NSFetchRequest<TermsOfSaleEntity> = TermsOfSaleEntity.fetchRequest()
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
    
    class func findByUUIDCompaniesAndUUIDCounterparties(uuidCompanies: String, uuidCounterparties:String, context: NSManagedObjectContext) throws -> [TermsOfSaleEntity] {
        
        let request: NSFetchRequest<TermsOfSaleEntity> = TermsOfSaleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uuidCompanies like %@", uuidCompanies)
        request.predicate = NSPredicate(format: "uuidCounterparties like %@", uuidCounterparties)
        
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}

