//
//  CoreDataManager.swift
//  salesManager
//
//  Created by Роман Кокорев on 26.12.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DataBase1CDrive")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func delAllRecords(in entity: String) -> Void {
        let viewContext = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            print("There was an error")
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAllAndCreateNewDB() {
        let context = persistentContainer.viewContext
        // Получить ссылку на файл хранилища постоянных данных
        let store = context.persistentStoreCoordinator?.persistentStores.first
        let storeURL = store?.url
        
        // Удалить хранилище из координатора и файл из файловой системы
        do {
            try context.persistentStoreCoordinator?.remove(store!)
            try FileManager.default.removeItem(at: storeURL!)
        } catch {
            // Обработать ошибку
            print("Error delete DB")
        }
        // Добавить новое хранилище в координатор
        do {
            try context.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            // Обработать ошибку
            print("Error create DB")
        }
    }
    
    //MARK: Partners
    
    func getAllPartners(_ complitionHandler: @escaping ([Partner]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let partnerEntities = try? PartnerEntity.all(viewContext)
            let dbPartners = partnerEntities?.map({ Partner(entity: $0)})
            
            complitionHandler(dbPartners ?? [])
        }
    }
    
    func getPartnerByName(name: String) async -> Partner {
        let viewContext = persistentContainer.viewContext
        return await viewContext.perform {
            let partnerEntities = try? PartnerEntity.findByName(name: name, context: viewContext)
            let dbPartners = Partner(entity: partnerEntities ?? PartnerEntity.init())
            return dbPartners
        }
    }
    
    func getAllContactPersonPartner(_ complitionHandler: @escaping ([ContactPersonPartner]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let contactPersonPartnerEntities = try? ContactPersonPartnerEntity.all(viewContext)
            let dbContactPersonPartner = contactPersonPartnerEntities?.map({ ContactPersonPartner(entity: $0)})
            
            complitionHandler(dbContactPersonPartner ?? [])
        }
    }
    
    func getContactPersonPartnerByOwnerUUID(owner_uuid: String, complitionHandler: @escaping ([ContactPersonPartner]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let contactPersonPartnerEntities = try? ContactPersonPartnerEntity.findByOwnerUUID(owner_uuid: owner_uuid, context: viewContext)
            let dbContactPersonPartner = contactPersonPartnerEntities?.map({ ContactPersonPartner(entity: $0)})
            
            complitionHandler(dbContactPersonPartner ?? [])
        }
    }
    
    func getContactDetailsPartnerByOwnerUUID(owner_uuid: String, complitionHandler: @escaping ([ContactDetailsPartner]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let contactDetailsPartnerEntity = try? ContactDetailsPartnerEntity.findByOwnerUUID(owner_uuid: owner_uuid, context: viewContext)
            let dbContactDetailsPartner = contactDetailsPartnerEntity?.map({ ContactDetailsPartner(entity: $0)})
            
            complitionHandler(dbContactDetailsPartner ?? [])
        }
    }
    
    func getContactDetailsContactPersonPartnerByOwnerUUID(owner_uuid: String, complitionHandler: @escaping ([ContactDetailsContactPersonPartner]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let contactDetailsContactPersonPartnerEntity = try? ContactDetailsContactPersonPartnerEntity.findByOwnerUUID(owner_uuid: owner_uuid, context: viewContext)
            let dbContactDetailsContactPersonPartner = contactDetailsContactPersonPartnerEntity?.map({ ContactDetailsContactPersonPartner(entity: $0)})
            
            complitionHandler(dbContactDetailsContactPersonPartner ?? [])
        }
    }
    
    func delContactDetailsPartnerByOwnerUUID(owner_uuid: String) -> Void {
        let viewContext = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<ContactDetailsPartnerEntity>(entityName: "ContactDetailsPartnerEntity")
        deleteFetch.predicate = NSPredicate(format: "owner_uuid like %@", owner_uuid)
        
        do {
            let objects = try viewContext.fetch(deleteFetch)
            // Проходим по массиву и удаляем каждый объект
            for object in objects {
                viewContext.delete(object)
            }
            // Сохраняем изменения
            try viewContext.save()
        } catch let error as NSError {
            // Обрабатываем ошибку
            print(error.localizedDescription)
        }
    }
    
    func savePartner(partners: [Partner], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for partner in partners {
                _ = try? PartnerEntity.findOrCreate(partner, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func saveContactPersonPartner(contactPersonPartners: [ContactPersonPartner], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for contactPersonPartner in contactPersonPartners {
                _ = try? ContactPersonPartnerEntity.findOrCreate(contactPersonPartner, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func saveContactDetailsPartner(contactDetailsPartners: [ContactDetailsPartner], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for contactDetailsPartner in contactDetailsPartners {
                _ = try? ContactDetailsPartnerEntity.findOrCreate(contactDetailsPartner, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func saveContactDetailsContactPersonPartner(contactDetailsContactPersonPartners: [ContactDetailsContactPersonPartner], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for contactDetailsContactPersonPartner in contactDetailsContactPersonPartners {
                _ = try? ContactDetailsContactPersonPartnerEntity.findOrCreate(contactDetailsContactPersonPartner, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func deleteAllPartner() {
        let context = persistentContainer.viewContext
        // Создать запрос на выборку объектов User
        let fetchRequest = NSFetchRequest<PartnerEntity>(entityName: "PartnerEntity")
        // Добавить условие поиска по имени
        //fetchRequest.predicate = NSPredicate(format: "name == %@", "Alice")
        // Выполнить запрос и получить массив результатов
        do {
            let partners = try context.fetch(fetchRequest)
            // Проверить, что массив не пустой
            //if let user = users.first {
            // Удалить объект из контекста
            for partner in partners {
                context.delete(partner)
            }
            // Сохранить контекст
            try context.save()
            //}
        } catch {
            // Обработать ошибку
        }
    }
    
    //MARK: ColdClients
    
    func getAllColdClients(_ complitionHandler: @escaping ([ColdClient]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let coldClientsEntities = try? ColdClientEntity.all(viewContext)
            let dbColdClients = coldClientsEntities?.map({ ColdClient(entity: $0)})
            
            complitionHandler(dbColdClients ?? [])
        }
    }
    
    func getAllContactPersonColdClient(_ complitionHandler: @escaping ([ContactPersonColdClient]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let contactPersonColdClientEntities = try? ContactPersonColdClientEntity.all(viewContext)
            let dbContactPersonColdClient = contactPersonColdClientEntities?.map({ ContactPersonColdClient(entity: $0)})
            
            complitionHandler(dbContactPersonColdClient ?? [])
        }
    }
    
    func getContactPersonColdClientByOwnerUUID(owner_uuid: String, complitionHandler: @escaping ([ContactPersonColdClient]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let contactPersonColdClientEntities = try? ContactPersonColdClientEntity.findByOwnerUUID(owner_uuid: owner_uuid, context: viewContext)
            let dbContactPersonColdClient = contactPersonColdClientEntities?.map({ ContactPersonColdClient(entity: $0)})
            
            complitionHandler(dbContactPersonColdClient ?? [])
        }
    }
    
    func getContactDetailsColdClientByOwnerUUID(owner_uuid: String, complitionHandler: @escaping ([ContactDetailsColdClient]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let contactDetailsColdClientEntity = try? ContactDetailsColdClientEntity.findByOwnerUUID(owner_uuid: owner_uuid, context: viewContext)
            let dbContactDetailsColdClient = contactDetailsColdClientEntity?.map({ ContactDetailsColdClient(entity: $0)})
            
            complitionHandler(dbContactDetailsColdClient ?? [])
        }
    }
    
    func getContactDetailsContactPersonColdClientByOwnerUUID(owner_uuid: String, complitionHandler: @escaping ([ContactDetailsContactPersonColdClient]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let contactDetailsContactPersonColdClientEntity = try? ContactDetailsContactPersonColdClientEntity.findByOwnerUUID(owner_uuid: owner_uuid, context: viewContext)
            let dbContactDetailsContactPersonColdClient = contactDetailsContactPersonColdClientEntity?.map({ ContactDetailsContactPersonColdClient(entity: $0)})
            
            complitionHandler(dbContactDetailsContactPersonColdClient ?? [])
        }
    }
    
    func delContactDetailsColdClientByOwnerUUID(owner_uuid: String) -> Void {
        let viewContext = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<ContactDetailsColdClientEntity>(entityName: "ContactDetailsColdClientEntity")
        deleteFetch.predicate = NSPredicate(format: "owner_uuid like %@", owner_uuid)
        
        do {
            let objects = try viewContext.fetch(deleteFetch)
            // Проходим по массиву и удаляем каждый объект
            for object in objects {
                viewContext.delete(object)
            }
            // Сохраняем изменения
            try viewContext.save()
        } catch let error as NSError {
            // Обрабатываем ошибку
            print(error.localizedDescription)
        }
    }
    
    func saveColdClient(coldClients: [ColdClient], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for coldClient in coldClients {
                _ = try? ColdClientEntity.findOrCreate(coldClient, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func saveContactPersonColdClient(contactPersonColdClients: [ContactPersonColdClient], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for contactPersonColdClient in contactPersonColdClients {
                _ = try? ContactPersonColdClientEntity.findOrCreate(contactPersonColdClient, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func saveContactDetailsColdClient(contactDetailsColdClients: [ContactDetailsColdClient], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for contactDetailsColdClient in contactDetailsColdClients {
                _ = try? ContactDetailsColdClientEntity.findOrCreate(contactDetailsColdClient, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func saveContactDetailsContactPersonColdClient(contactDetailsContactPersonColdClients: [ContactDetailsContactPersonColdClient], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for contactDetailsContactPersonColdClient in contactDetailsContactPersonColdClients {
                _ = try? ContactDetailsContactPersonColdClientEntity.findOrCreate(contactDetailsContactPersonColdClient, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func deleteAllColdClient() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ColdClientEntity>(entityName: "ColdClientEntity")
        do {
            let coldClients = try context.fetch(fetchRequest)
            for coldClient in coldClients {
                context.delete(coldClient)
            }
            try context.save()
        } catch {
            // Обработать ошибку
        }
    }
    
    //MARK: DocumentMeeting
    
    func getAllPurposeOfContact(_ complitionHandler: @escaping ([PurposeOfContact]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let purposeOfContactEntities = try? PurposeOfContactEntity.all(viewContext)
            let dbPurposeOfContact = purposeOfContactEntities?.map({ PurposeOfContact(entity: $0)})
            
            complitionHandler(dbPurposeOfContact ?? [])
        }
    }
    
    func getAllStatusOfMeeting(_ complitionHandler: @escaping ([StatusOfMeeting]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let statusOfMeetingEntity = try? StatusOfMeetingEntity.all(viewContext)
            let dbStatusOfMeeting = statusOfMeetingEntity?.map({ StatusOfMeeting(entity: $0)})
            
            complitionHandler(dbStatusOfMeeting ?? [])
        }
    }
    
    func getAllStatusOfClient(_ complitionHandler: @escaping ([StatusOfClient]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let statusOfClientEntity = try? StatusOfClientEntity.all(viewContext)
            let dbStatusOfClient = statusOfClientEntity?.map({ StatusOfClient(entity: $0)})
            
            complitionHandler(dbStatusOfClient ?? [])
        }
    }
    
    func savePurposeOfContact(purposeOfContacts: [PurposeOfContact], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for purposeOfContact in purposeOfContacts {
                _ = try? PurposeOfContactEntity.findOrCreate(purposeOfContact, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func saveStatusOfMeeting(statusOfMeetings: [StatusOfMeeting], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for statusOfMeeting in statusOfMeetings {
                _ = try? StatusOfMeetingEntity.findOrCreate(statusOfMeeting, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func saveStatusOfClient(statusOfClients: [StatusOfClient], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for statusOfClient in statusOfClients {
                _ = try? StatusOfClientEntity.findOrCreate(statusOfClient, context: viewContext)
            }
            
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func deleteAllPurposeOfContact() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PurposeOfContactEntity>(entityName: "PurposeOfContactEntity")
        do {
            let purposeOfContacts = try context.fetch(fetchRequest)
            for purposeOfContact in purposeOfContacts {
                context.delete(purposeOfContact)
            }
            try context.save()
        } catch {
            // Обработать ошибку
        }
    }
    
    //MARK: DocumentOrder
    
    func getAllCompanies(_ complitionHandler: @escaping ([Companies]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let companiesEntities = try? CompaniesEntity.all(viewContext)
            let dbCompanies = companiesEntities?.map({ Companies(entity: $0)})
            
            complitionHandler(dbCompanies ?? [])
        }
    }
    
    func saveCompanies(companies: [Companies], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for companie in companies {
                _ = try? CompaniesEntity.findOrCreate(companie, context: viewContext)
            }
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func getAllCounterparties(_ complitionHandler: @escaping ([Counterparties]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let counterpartiesEntities = try? CounterpartiesEntity.all(viewContext)
            let dbCounterparties = counterpartiesEntities?.map({ Counterparties(entity: $0)})
            
            complitionHandler(dbCounterparties ?? [])
        }
    }
    
    func getCounterpartiesByOwnerUUID(owner_uuid: String, complitionHandler: @escaping ([Counterparties]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let counterpartiesEntity = try? CounterpartiesEntity.findByOwnerUUID(owner_uuid: owner_uuid, context: viewContext)
            let dbCounterparties = counterpartiesEntity?.map({ Counterparties(entity: $0)})
            
            complitionHandler(dbCounterparties ?? [])
        }
    }
    
    func saveCounterparties(counterparties: [Counterparties], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for counterpartie in counterparties {
                _ = try? CounterpartiesEntity.findOrCreate(counterpartie, context: viewContext)
            }
            try? viewContext.save()
            complitionHandler()
        }
    }
    
    func getTermsOfSaleByUUIDCompaniesAndUUIDCounterparties(uuidCompanies: String, uuidCounterparties: String, complitionHandler: @escaping ([TermsOfSale]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let termsOfSaleEntity = try? TermsOfSaleEntity.findByUUIDCompaniesAndUUIDCounterparties(uuidCompanies: uuidCompanies, uuidCounterparties: uuidCounterparties, context: viewContext)
            let dbTermsOfSale = termsOfSaleEntity?.map({ TermsOfSale(entity: $0)})
            
            complitionHandler(dbTermsOfSale ?? [])
        }
    }
    
 /*   func getTermsOfSale(uuidCompanies: String, uuidCounterparties: String, complitionHandler: @escaping ([TermsOfSale]) -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let termsOfSaleEntities = try? TermsOfSaleEntity.all(viewContext)
            let dbTermsOfSale = termsOfSaleEntities?.map({ TermsOfSale(entity: $0)})
            
            complitionHandler(dbTermsOfSale ?? [])
        }
    }   */
    
    func saveTermsOfSale(termsOfSale: [TermsOfSale], complitionHandler: @escaping () -> Void) {
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            for termOfSale in termsOfSale {
                _ = try? TermsOfSaleEntity.findOrCreate(termOfSale, context: viewContext)
            }
            try? viewContext.save()
            complitionHandler()
        }
    }
    
}
