//
//  NetworkManager.swift
//  salesManager
//
//  Created by Роман Кокорев on 26.12.2023.
//

import UIKit

class NetworkManager {
    
    enum HTTPMethod: String {
        case POST
        case PUT
        case GET
        case DELETE
    }
    
    enum APIs: String {
        case CheckConnection
        case CatalogPartners
        case CatalogColdClients
        case CatalogContactPersonsPartners
        case CatalogContactPersonsColdClients
        case ContactDetailsPartners
        case ContactDetailsColdClients
        case ContactDetailsContactPersonsPartners
        case ContactDetailsContactPersonsColdClients
        case CreateColdClients
        case CreateContactDetailsPartners
        case CreateContactDetailsContactPersonsPartners
        case CreateContactDetailsColdClients
        case CreateContactDetailsContactPersonsColdClients
        case CreateContactPersonsPartners
        case CreateContactPersonsColdClients
        case CatalogPurposeOfContact
        case CatalogStatusOfMeeting
        case CatalogStatusOfClient
        case CreateAppointment
        case CatalogCompanies
        case CatalogCounterparties
        case CatalogTermsOfSale
    }
    
    enum Headers: String {
        case ContentLengh = "Content-Lengdh"
        case ContentType = "Content-Type"
        case Path = "application/json"
        case Authorization = "Authorization"
    }
    
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.setValue(Headers.Path.rawValue, forHTTPHeaderField: Headers.ContentType.rawValue)
        let login = UserDefaults.standard.string(forKey: "userLogin") ?? ""
        let password = UserDefaults.standard.string(forKey: "userPassword") ?? ""
        let loginPassword = "\(login):\(password)"
        let loginPasswordData = loginPassword.data(using: .utf8)!
        let base64LoginPassword = loginPasswordData.base64EncodedString()
        request.setValue("Basic \(base64LoginPassword)", forHTTPHeaderField: Headers.Authorization.rawValue)
        print(request)
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
    
    func getCheckConnetc(loginTest: String, passwordTest: String, complitionHandler: @escaping (Int) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CheckConnection.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.GET.rawValue
            request.setValue(Headers.Path.rawValue, forHTTPHeaderField: Headers.ContentType.rawValue)
            let loginPassword = "\(loginTest):\(passwordTest)"
            let loginPasswordData = loginPassword.data(using: .utf8)!
            let base64LoginPassword = loginPasswordData.base64EncodedString()
            request.setValue("Basic \(base64LoginPassword)", forHTTPHeaderField: Headers.Authorization.rawValue)
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    
                    if let error = error {
                        print("Error received requesting data: \(error.localizedDescription)")
                        complitionHandler(0)
                    }
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        print(response.statusCode )
                        print(loginPassword)
                        complitionHandler(response.statusCode)
                    }
                }
            }.resume()
        }
    }
    
    //MARK: Partners
    
    func getCatalogPartners(complitionHandler: @escaping ([Partner]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CatalogPartners.rawValue) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let partners = try JSONDecoder().decode([Partner].self, from: data)
                        complitionHandler(partners)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getCatalogContactPersonsPartners(partnerUUID: String, complitionHandler: @escaping ([ContactPersonPartner]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CatalogContactPersonsPartners.rawValue + "/" + partnerUUID) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        var contactPersonPartners = try JSONDecoder().decode([ContactPersonPartner].self, from: data)
                        for i in 0..<contactPersonPartners.count {
                            contactPersonPartners[i].owner_uuid = partnerUUID
                        }
                        complitionHandler(contactPersonPartners)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getContactDetailsPartners(partnerUUID: String, complitionHandler: @escaping ([ContactDetailsPartner]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.ContactDetailsPartners.rawValue + "/" + partnerUUID) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        var contactDetailsPartners = try JSONDecoder().decode([ContactDetailsPartner].self, from: data)
                        for i in 0..<contactDetailsPartners.count {
                            contactDetailsPartners[i].owner_uuid = partnerUUID
                        }
                        complitionHandler(contactDetailsPartners)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getContactDetailsContactPersonPartners(contactPersonPartnerUUID: String, complitionHandler: @escaping ([ContactDetailsContactPersonPartner]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.ContactDetailsContactPersonsPartners.rawValue + "/" + contactPersonPartnerUUID) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        var contactDetailsContactPersonPartners = try JSONDecoder().decode([ContactDetailsContactPersonPartner].self, from: data)
                        for i in 0..<contactDetailsContactPersonPartners.count {
                            contactDetailsContactPersonPartners[i].owner_uuid = contactPersonPartnerUUID
                        }
                        complitionHandler(contactDetailsContactPersonPartners)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getContactPersonPartnerBy(partner: Partner, complitionHandler: @escaping ([ContactPersonPartner]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        guard let url = URL(string: baseURL + APIs.CatalogPartners.rawValue) else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "partner", value: "\(partner)")]
        
        guard let queryURL = components?.url else { return }
        
        request(url: queryURL) { (result) in
            switch result {
            case .success(let data):
                do {
                    let contactPerson = try JSONDecoder().decode([ContactPersonPartner].self, from: data)
                    complitionHandler(contactPerson)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    complitionHandler([])
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                complitionHandler([])
            }
        }
    }
    
    func postCreateContactPersonsPartners(jsonData: Data, complitionHandler: @escaping (String) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CreateContactPersonsPartners.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            let login = UserDefaults.standard.string(forKey: "userLogin") ?? ""
            let password = UserDefaults.standard.string(forKey: "userPassword") ?? ""
            let loginPassword = "\(login):\(password)"
            let loginPasswordData = loginPassword.data(using: .utf8)!
            let base64LoginPassword = loginPasswordData.base64EncodedString()
            request.setValue("Basic \(base64LoginPassword)", forHTTPHeaderField: Headers.Authorization.rawValue)
            request.httpBody = jsonData
            request.setValue(Headers.Path.rawValue, forHTTPHeaderField: Headers.ContentType.rawValue)
            print(request)
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error received requesting data: \(error.localizedDescription)")
                        complitionHandler("")
                    }
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        if let data = data {
                            // Преобразуем данные в строку с кодировкой UTF-8
                            if let stringUUID = String(data: data, encoding: .utf8) {
                                // Выводим строку в консоль
                                complitionHandler(stringUUID)
                                print("String: \(stringUUID)")
                                print(response.statusCode)
                            } else {
                                // Выводим сообщение, если не удалось преобразовать данные в строку
                                print("Unable to convert data to string")
                                complitionHandler("")
                            }
                        } else {
                            // Выводим сообщение, если нет данных
                            print("No data received")
                            complitionHandler("")
                        }
                    }
                }
            }.resume()
        }
    }
    
    func postCreateContactDetailsPartners(jsonData: Data, complitionHandler: @escaping (String) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CreateContactDetailsPartners.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            let login = UserDefaults.standard.string(forKey: "userLogin") ?? ""
            let password = UserDefaults.standard.string(forKey: "userPassword") ?? ""
            let loginPassword = "\(login):\(password)"
            let loginPasswordData = loginPassword.data(using: .utf8)!
            let base64LoginPassword = loginPasswordData.base64EncodedString()
            request.setValue("Basic \(base64LoginPassword)", forHTTPHeaderField: Headers.Authorization.rawValue)
            request.httpBody = jsonData
            request.setValue(Headers.Path.rawValue, forHTTPHeaderField: Headers.ContentType.rawValue)
            print(request)
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error received requesting data: \(error.localizedDescription)")
                        complitionHandler("")
                    }
                    //if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let response = response as? HTTPURLResponse {
                        print(response.statusCode)
                        complitionHandler(String(response.statusCode))
                    }
                }
            }.resume()
        }
    }
    
    func postCreateContactDetailsContactPersonsPartners(jsonData: Data, complitionHandler: @escaping (String) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CreateContactDetailsContactPersonsPartners.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            let login = UserDefaults.standard.string(forKey: "userLogin") ?? ""
            let password = UserDefaults.standard.string(forKey: "userPassword") ?? ""
            let loginPassword = "\(login):\(password)"
            let loginPasswordData = loginPassword.data(using: .utf8)!
            let base64LoginPassword = loginPasswordData.base64EncodedString()
            request.setValue("Basic \(base64LoginPassword)", forHTTPHeaderField: Headers.Authorization.rawValue)
            request.httpBody = jsonData
            request.setValue(Headers.Path.rawValue, forHTTPHeaderField: Headers.ContentType.rawValue)
            print(request)
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error received requesting data: \(error.localizedDescription)")
                        complitionHandler("")
                    }
                    if let response = response as? HTTPURLResponse {
                        print(response.statusCode)
                        complitionHandler(String(response.statusCode))
                    }
                }
            }.resume()
        }
    }
    
    //MARK: ColdClients
    
    func getCatalogColdClients(complitionHandler: @escaping ([ColdClient]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CatalogColdClients.rawValue) {
            print(url)
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let coldClients = try JSONDecoder().decode([ColdClient].self, from: data)
                        complitionHandler(coldClients)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getCatalogContactPersonsColdClients(coldClientUUID: String, complitionHandler: @escaping ([ContactPersonColdClient]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CatalogContactPersonsColdClients.rawValue + "/" + coldClientUUID) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        var contactPersonColdClients = try JSONDecoder().decode([ContactPersonColdClient].self, from: data)
                        for i in 0..<contactPersonColdClients.count {
                            contactPersonColdClients[i].owner_uuid = coldClientUUID
                        }
                        complitionHandler(contactPersonColdClients)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getContactDetailsColdClients(coldClientUUID: String, complitionHandler: @escaping ([ContactDetailsColdClient]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.ContactDetailsColdClients.rawValue + "/" + coldClientUUID) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        var contactDetailsColdClients = try JSONDecoder().decode([ContactDetailsColdClient].self, from: data)
                        for i in 0..<contactDetailsColdClients.count {
                            contactDetailsColdClients[i].owner_uuid = coldClientUUID
                        }
                        complitionHandler(contactDetailsColdClients)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getContactDetailsContactPersonColdClients(contactPersonColdClientUUID: String, complitionHandler: @escaping ([ContactDetailsContactPersonColdClient]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.ContactDetailsContactPersonsColdClients.rawValue + "/" + contactPersonColdClientUUID) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        var contactDetailsContactPersonColdClients = try JSONDecoder().decode([ContactDetailsContactPersonColdClient].self, from: data)
                        for i in 0..<contactDetailsContactPersonColdClients.count {
                            contactDetailsContactPersonColdClients[i].owner_uuid = contactPersonColdClientUUID
                        }
                        complitionHandler(contactDetailsContactPersonColdClients)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getContactPersonColdClientBy(coldClient: ColdClient, complitionHandler: @escaping ([ContactPersonColdClient]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        guard let url = URL(string: baseURL + APIs.CatalogPartners.rawValue) else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "coldClient", value: "\(coldClient)")]
        
        guard let queryURL = components?.url else { return }
        
        request(url: queryURL) { (result) in
            switch result {
            case .success(let data):
                do {
                    let contactPerson = try JSONDecoder().decode([ContactPersonColdClient].self, from: data)
                    complitionHandler(contactPerson)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    complitionHandler([])
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                complitionHandler([])
            }
        }
    }
    
    func postCreateColdClient(nameColdClient: String, jsonData: Data, complitionHandler: @escaping (String) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CreateColdClients.rawValue + "/" + nameColdClient) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            let login = UserDefaults.standard.string(forKey: "userLogin") ?? ""
            let password = UserDefaults.standard.string(forKey: "userPassword") ?? ""
            let loginPassword = "\(login):\(password)"
            let loginPasswordData = loginPassword.data(using: .utf8)!
            let base64LoginPassword = loginPasswordData.base64EncodedString()
            request.setValue("Basic \(base64LoginPassword)", forHTTPHeaderField: Headers.Authorization.rawValue)
            request.httpBody = jsonData
            request.setValue(Headers.Path.rawValue, forHTTPHeaderField: Headers.ContentType.rawValue)
            print(request)
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error received requesting data: \(error.localizedDescription)")
                        complitionHandler("")
                    }
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                      
                        if let data = data {
                            // Преобразуем данные в строку с кодировкой UTF-8
                            if let stringUUID = String(data: data, encoding: .utf8) {
                                // Выводим строку в консоль
                                complitionHandler(stringUUID)
                                print("String: \(stringUUID)")
                                print(response.statusCode)
                            } else {
                                // Выводим сообщение, если не удалось преобразовать данные в строку
                                print("Unable to convert data to string")
                                complitionHandler("")
                            }
                        } else {
                            // Выводим сообщение, если нет данных
                            print("No data received")
                            complitionHandler("")
                        }
                    }
                }
            }.resume()
        }
    }
    
    func postCreateContactPersonsColdClients(jsonData: Data, complitionHandler: @escaping (String) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CreateContactPersonsColdClients.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            let login = UserDefaults.standard.string(forKey: "userLogin") ?? ""
            let password = UserDefaults.standard.string(forKey: "userPassword") ?? ""
            let loginPassword = "\(login):\(password)"
            let loginPasswordData = loginPassword.data(using: .utf8)!
            let base64LoginPassword = loginPasswordData.base64EncodedString()
            request.setValue("Basic \(base64LoginPassword)", forHTTPHeaderField: Headers.Authorization.rawValue)
            request.httpBody = jsonData
            request.setValue(Headers.Path.rawValue, forHTTPHeaderField: Headers.ContentType.rawValue)
            print(request)
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error received requesting data: \(error.localizedDescription)")
                        complitionHandler("")
                    }
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    //if let response = response as? HTTPURLResponse {
                        if let data = data {
                            // Преобразуем данные в строку с кодировкой UTF-8
                            if let stringUUID = String(data: data, encoding: .utf8) {
                                // Выводим строку в консоль
                                complitionHandler(stringUUID)
                                print("String: \(stringUUID)")
                                print(response.statusCode)
                            } else {
                                // Выводим сообщение, если не удалось преобразовать данные в строку
                                print("Unable to convert data to string")
                                complitionHandler("")
                            }
                        } else {
                            // Выводим сообщение, если нет данных
                            print("No data received")
                            complitionHandler("")
                        }
                    }
                }
            }.resume()
        }
    }
    
    func postCreateContactDetailsColdClients(jsonData: Data, complitionHandler: @escaping (String) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CreateContactDetailsColdClients.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            let login = UserDefaults.standard.string(forKey: "userLogin") ?? ""
            let password = UserDefaults.standard.string(forKey: "userPassword") ?? ""
            let loginPassword = "\(login):\(password)"
            let loginPasswordData = loginPassword.data(using: .utf8)!
            let base64LoginPassword = loginPasswordData.base64EncodedString()
            request.setValue("Basic \(base64LoginPassword)", forHTTPHeaderField: Headers.Authorization.rawValue)
            request.httpBody = jsonData
            request.setValue(Headers.Path.rawValue, forHTTPHeaderField: Headers.ContentType.rawValue)
            print(request)
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error received requesting data: \(error.localizedDescription)")
                        complitionHandler("")
                    }
                    if let response = response as? HTTPURLResponse {
                        print(response.statusCode)
                        complitionHandler(String(response.statusCode))
                    }
                }
            }.resume()
        }
    }
    
    func postCreateContactDetailsContactPersonsColdClients(jsonData: Data, complitionHandler: @escaping (String) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CreateContactDetailsContactPersonsColdClients.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            let login = UserDefaults.standard.string(forKey: "userLogin") ?? ""
            let password = UserDefaults.standard.string(forKey: "userPassword") ?? ""
            let loginPassword = "\(login):\(password)"
            let loginPasswordData = loginPassword.data(using: .utf8)!
            let base64LoginPassword = loginPasswordData.base64EncodedString()
            request.setValue("Basic \(base64LoginPassword)", forHTTPHeaderField: Headers.Authorization.rawValue)
            request.httpBody = jsonData
            request.setValue(Headers.Path.rawValue, forHTTPHeaderField: Headers.ContentType.rawValue)
            print(request)
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error received requesting data: \(error.localizedDescription)")
                        complitionHandler("")
                    }
                    if let response = response as? HTTPURLResponse {
                        print(response.statusCode)
                        complitionHandler(String(response.statusCode))
                    }
                }
            }.resume()
        }
    }
    
    //MARK: DocumentMeeting
    
    func postCreateDocumentMeeting(jsonData: Data, complitionHandler: @escaping (Int) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CreateAppointment.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            let login = UserDefaults.standard.string(forKey: "userLogin") ?? ""
            let password = UserDefaults.standard.string(forKey: "userPassword") ?? ""
            let loginPassword = "\(login):\(password)"
            let loginPasswordData = loginPassword.data(using: .utf8)!
            let base64LoginPassword = loginPasswordData.base64EncodedString()
            request.setValue("Basic \(base64LoginPassword)", forHTTPHeaderField: Headers.Authorization.rawValue)
            request.httpBody = jsonData
            request.setValue(Headers.Path.rawValue, forHTTPHeaderField: Headers.ContentType.rawValue)
            print(request)
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error received requesting data: \(error.localizedDescription)")
                        complitionHandler(0)
                    }
                    if let response = response as? HTTPURLResponse {
                        complitionHandler(response.statusCode)
                    }
                }
            }.resume()
        }
    }
    
    func getCatalogPurposeOfContact(complitionHandler: @escaping ([PurposeOfContact]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CatalogPurposeOfContact.rawValue) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let purposeOfContacts = try JSONDecoder().decode([PurposeOfContact].self, from: data)
                        complitionHandler(purposeOfContacts)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getCatalogStatusOfMeeting(complitionHandler: @escaping ([StatusOfMeeting]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CatalogStatusOfMeeting.rawValue) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let statusOfMeetings = try JSONDecoder().decode([StatusOfMeeting].self, from: data)
                        complitionHandler(statusOfMeetings)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getCatalogStatusOfClient(complitionHandler: @escaping ([StatusOfClient]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CatalogStatusOfClient.rawValue) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let statusOfClients = try JSONDecoder().decode([StatusOfClient].self, from: data)
                        complitionHandler(statusOfClients)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    //MARK: DocumentOrder
    
    func getCatalogCompanies(complitionHandler: @escaping ([Companies]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CatalogCompanies.rawValue) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let companies = try JSONDecoder().decode([Companies].self, from: data)
                        complitionHandler(companies)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getCatalogCounterparties(uuid: String, complitionHandler: @escaping ([Counterparties]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CatalogCounterparties.rawValue + "/" + uuid) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        var counterparties = try JSONDecoder().decode([Counterparties].self, from: data)
                        for i in 0..<counterparties.count {
                            counterparties[i].owner_uuid = uuid
                        }
                        complitionHandler(counterparties)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    func getTermsOfSaleByUUIDCompaniesAndUUIDCounterparties(owner_uuid: String, uuidCompanies: String, uuidCounterparties: String, complitionHandler: @escaping ([TermsOfSale]) -> Void) {
        let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
        if let url = URL(string: baseURL + APIs.CatalogTermsOfSale.rawValue + "/" + uuidCompanies + "/" + uuidCounterparties) {
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        var termsOfSale = try JSONDecoder().decode([TermsOfSale].self, from: data)
                        for i in 0..<termsOfSale.count {
                            termsOfSale[i].owner_uuid = owner_uuid
                        }
                        complitionHandler(termsOfSale)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
        }
    }
    
    
}

