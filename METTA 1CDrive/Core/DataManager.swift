//
//  DataManager.swift
//  salesManager
//
//  Created by Роман Кокорев on 26.12.2023.
//

import Foundation

class DataManager {
    let coreDataManager = CoreDataManager.shared
    let networkManager = NetworkManager()
    
    //MARK: Partners
    
    func getAllPartners(_ complitionHander: @escaping ([Partner]) -> Void) {
        coreDataManager.getAllPartners { (partners) in
            if partners.count > 0 {
                complitionHander(partners)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogPartners { (partners) in
                    self.coreDataManager.savePartner(partners: partners) {
                        complitionHander(partners)
                    }
                }
            }
        }
    }
    
    func getAllContactPersonPartners(partnerUUID: String, complitionHander: @escaping ([ContactPersonPartner]) -> Void) {
        coreDataManager.getAllContactPersonPartner { (contactPersonPartner) in
            if contactPersonPartner.count > 0 {
                complitionHander(contactPersonPartner)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogContactPersonsPartners(partnerUUID: partnerUUID) { (contactPersonPartners) in
                    self.coreDataManager.saveContactPersonPartner(contactPersonPartners: contactPersonPartners) {
                        complitionHander(contactPersonPartners)
                    }
                }
            }
        }
    }
    
    func getContactPersonPartnersByOwnerUUID(owner_uuid: String, complitionHander: @escaping ([ContactPersonPartner]) -> Void) {
        coreDataManager.getContactPersonPartnerByOwnerUUID(owner_uuid: owner_uuid, complitionHandler: { (contactPersonPartner) in
            if contactPersonPartner.count > 0 {
                complitionHander(contactPersonPartner)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogContactPersonsPartners(partnerUUID: owner_uuid) { (contactPersonPartners) in
                    self.coreDataManager.saveContactPersonPartner(contactPersonPartners: contactPersonPartners) {
                        complitionHander(contactPersonPartners)
                    }
                }
            }
        })
    }
    
    func getContactDetailsPartnersByOwnerUUID(owner_uuid: String, complitionHander: @escaping ([ContactDetailsPartner]) -> Void) {
        coreDataManager.getContactDetailsPartnerByOwnerUUID(owner_uuid: owner_uuid, complitionHandler: { (contactDetailsPartner) in
            if contactDetailsPartner.count > 0 {
                complitionHander(contactDetailsPartner)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getContactDetailsPartners(partnerUUID: owner_uuid, complitionHandler: { (contactDetailsPartners) in
                    self.coreDataManager.saveContactDetailsPartner(contactDetailsPartners: contactDetailsPartners) {
                        complitionHander(contactDetailsPartners)
                    }
                })
            }
        })
    }
    
    func getContactDetailsContactPersonPartnersByOwnerUUID(owner_uuid: String, complitionHander: @escaping ([ContactDetailsContactPersonPartner]) -> Void) {
        coreDataManager.getContactDetailsContactPersonPartnerByOwnerUUID(owner_uuid: owner_uuid, complitionHandler: { (contactDetailsContactPersonPartner) in
            if contactDetailsContactPersonPartner.count > 0 {
                complitionHander(contactDetailsContactPersonPartner)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getContactDetailsContactPersonPartners(contactPersonPartnerUUID: owner_uuid, complitionHandler: { (contactDetailsContactPersonPartner) in
                    self.coreDataManager.saveContactDetailsContactPersonPartner(contactDetailsContactPersonPartners: contactDetailsContactPersonPartner) {
                        complitionHander(contactDetailsContactPersonPartner)
                    }
                })
            }
        })
    }
    
    //MARK: ColdClients
    
    func getAllColdClients(_ complitionHander: @escaping ([ColdClient]) -> Void) {
        coreDataManager.getAllColdClients { (coldClients) in
            if coldClients.count > 0 {
                complitionHander(coldClients)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogColdClients { (coldClients) in
                    self.coreDataManager.saveColdClient(coldClients: coldClients) {
                        complitionHander(coldClients)
                    }
                }
            }
        }
    }
    
    func getAllContactPersonColdClients(coldClientUUID: String, complitionHander: @escaping ([ContactPersonColdClient]) -> Void) {
        coreDataManager.getAllContactPersonColdClient { (contactPersonColdClient) in
            if contactPersonColdClient.count > 0 {
                complitionHander(contactPersonColdClient)
            } else {
                //функция загрузки из интернета
                self.networkManager.getCatalogContactPersonsColdClients(coldClientUUID: coldClientUUID) { (contactPersonColdClients) in
                    self.coreDataManager.saveContactPersonColdClient(contactPersonColdClients: contactPersonColdClients) {
                        complitionHander(contactPersonColdClients)
                    }
                }
            }
        }
    }
    
    func getContactPersonColdClientsByOwnerUUID(owner_uuid: String, complitionHander: @escaping ([ContactPersonColdClient]) -> Void) {
        coreDataManager.getContactPersonColdClientByOwnerUUID(owner_uuid: owner_uuid, complitionHandler: { (contactPersonColdClient) in
            if contactPersonColdClient.count > 0 {
                complitionHander(contactPersonColdClient)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogContactPersonsColdClients(coldClientUUID: owner_uuid) { (contactPersonColdClients) in
                    self.coreDataManager.saveContactPersonColdClient(contactPersonColdClients: contactPersonColdClients) {
                        complitionHander(contactPersonColdClients)
                    }
                }
            }
        })
    }
    
    func getContactDetailsColdClientsByOwnerUUID(owner_uuid: String, complitionHander: @escaping ([ContactDetailsColdClient]) -> Void) {
        coreDataManager.getContactDetailsColdClientByOwnerUUID(owner_uuid: owner_uuid, complitionHandler: { (contactDetailsColdClient) in
            if contactDetailsColdClient.count > 0 {
                complitionHander(contactDetailsColdClient)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getContactDetailsColdClients(coldClientUUID: owner_uuid, complitionHandler: { (contactDetailsColdClients) in
                    self.coreDataManager.saveContactDetailsColdClient(contactDetailsColdClients: contactDetailsColdClients) {
                        complitionHander(contactDetailsColdClients)
                    }
                })
            }
        })
    }
    
    func getContactDetailsContactPersonColdClientsByOwnerUUID(owner_uuid: String, complitionHander: @escaping ([ContactDetailsContactPersonColdClient]) -> Void) {
        coreDataManager.getContactDetailsContactPersonColdClientByOwnerUUID(owner_uuid: owner_uuid, complitionHandler: { (contactDetailsContactPersonColdClient) in
            if contactDetailsContactPersonColdClient.count > 0 {
                complitionHander(contactDetailsContactPersonColdClient)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getContactDetailsContactPersonColdClients(contactPersonColdClientUUID: owner_uuid, complitionHandler: { (contactDetailsContactPersonColdClient) in
                    self.coreDataManager.saveContactDetailsContactPersonColdClient(contactDetailsContactPersonColdClients: contactDetailsContactPersonColdClient) {
                        complitionHander(contactDetailsContactPersonColdClient)
                    }
                })
            }
        })
    }
    
    //MARK: DocumentMeeting
    
    func getAllPurposeOfContacts(_ complitionHander: @escaping ([PurposeOfContact]) -> Void) {
        coreDataManager.getAllPurposeOfContact { (purposeOfContact) in
            if purposeOfContact.count > 0 {
                complitionHander(purposeOfContact)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogPurposeOfContact { (purposeOfContacts) in
                    self.coreDataManager.savePurposeOfContact(purposeOfContacts: purposeOfContacts) {
                        complitionHander(purposeOfContacts)
                    }
                }
            }
        }
    }
    
    func getAllStatusOfMeetings(_ complitionHander: @escaping ([StatusOfMeeting]) -> Void) {
        coreDataManager.getAllStatusOfMeeting { (statusOfMeeting) in
            if statusOfMeeting.count > 0 {
                complitionHander(statusOfMeeting)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogStatusOfMeeting { (statusOfMeetings) in
                    self.coreDataManager.saveStatusOfMeeting(statusOfMeetings: statusOfMeetings) {
                        complitionHander(statusOfMeetings)
                    }
                }
            }
        }
    }
    
    func getAllStatusOfClients(_ complitionHander: @escaping ([StatusOfClient]) -> Void) {
        coreDataManager.getAllStatusOfClient { (statusOfClient) in
            if statusOfClient.count > 0 {
                complitionHander(statusOfClient)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogStatusOfClient { (statusOfClients) in
                    self.coreDataManager.saveStatusOfClient(statusOfClients: statusOfClients) {
                        complitionHander(statusOfClients)
                    }
                }
            }
        }
    }
    
    //MARK: DocumentOrder
    
    func getAllCompanies(_ complitionHander: @escaping ([Companies]) -> Void) {
        coreDataManager.getAllCompanies { (companies) in
            if companies.count > 0 {
                complitionHander(companies)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogCompanies { (companies) in
                    self.coreDataManager.saveCompanies(companies: companies) {
                        complitionHander(companies)
                    }
                }
            }
        }
    }
    
    func getAllCounterparties(uuid: String, complitionHander: @escaping ([Counterparties]) -> Void) {
        coreDataManager.getCounterpartiesByOwnerUUID(owner_uuid: uuid) { (counterparties) in
            if counterparties.count > 0 {
                complitionHander(counterparties)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogCounterparties(uuid: uuid) { (counterparties) in
                    self.coreDataManager.saveCounterparties(counterparties: counterparties) {
                        complitionHander(counterparties)
                    }
                }
            }
        }
    }
    
    func getCounterpartiesByOwnerUUID(owner_uuid: String, complitionHander: @escaping ([Counterparties]) -> Void) {
        coreDataManager.getCounterpartiesByOwnerUUID(owner_uuid: owner_uuid, complitionHandler: { (counterparties) in
            if counterparties.count > 0 {
                complitionHander(counterparties)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getCatalogCounterparties(uuid: owner_uuid) { (counterparties) in
                    self.coreDataManager.saveCounterparties(counterparties: counterparties) {
                        complitionHander(counterparties)
                    }
                }
            }
        })
    }
    
    func getTermsOfSale(owner_uuid: String, uuidCompanies: String, uuidCounterparties: String, complitionHander: @escaping ([TermsOfSale]) -> Void) {
        coreDataManager.getTermsOfSaleByUUIDCompaniesAndUUIDCounterparties(uuidCompanies: uuidCompanies, uuidCounterparties: uuidCounterparties, complitionHandler: { (termsOfSale) in
            if termsOfSale.count > 0 {
                complitionHander(termsOfSale)
            } else {
                
                //функция загрузки из интернета
                self.networkManager.getTermsOfSaleByUUIDCompaniesAndUUIDCounterparties(owner_uuid: owner_uuid, uuidCompanies: uuidCompanies, uuidCounterparties: uuidCounterparties) { (termsOfSale) in
                    self.coreDataManager.saveTermsOfSale(termsOfSale: termsOfSale) {
                        complitionHander(termsOfSale)
                    }
                }
            }
        })
    }
    
    
}
