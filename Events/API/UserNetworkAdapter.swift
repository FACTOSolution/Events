//
//  UserNetworkAdapter.swift
//  Events
//
//  Created by Orlando Amorim on 30/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RealmSwift

struct UserNetworkAdapter {
    // Get the default Provider
    static let provider = MoyaProvider<EventsAPI>()
    // Get the default Realm
    static let realm = try! Realm()
    
    static func getAllUsers(error errorCallback: @escaping (Swift.Error) -> Void,
                            failure failureCallback: @escaping (MoyaError) -> Void) {
        provider.request(EventsAPI.getAllUsers) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        let usersJson = try response.mapJSON()
                        let users: [User] = Mapper<User>().mapArray(JSONArray: usersJson as! [[String : Any]])
                        try! realm.write {
                            realm.delete(realm.objects(User.self))
                            for user in users {
                                realm.add(user, update: true)
                            }
                        }
                    }catch {
                        errorCallback(error)
                    }
                } else {
                    let error = NSError(domain: response.description, code: response.statusCode, userInfo:[NSLocalizedDescriptionKey: "Parsing Users Error"])
                    errorCallback(error)
                }
            case .failure(let error):
                failureCallback(error)
            }
        }
    }
    
    static func getUser(with id: Int, error errorCallback: @escaping (Swift.Error) -> Void,
                        failure failureCallback: @escaping (MoyaError) -> Void) {
        provider.request(EventsAPI.getUser(id: id)) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        let userJson = try response.mapJSON()
                        print(userJson)
                        if let user = Mapper<User>().map(JSON: userJson as! [String : Any]) {
                            try! realm.write {
                                realm.add(user, update: true)
                            }
                        }
                    }catch {
                        errorCallback(error)
                    }
                } else {
                    let error = NSError(domain: response.description, code: response.statusCode, userInfo:[NSLocalizedDescriptionKey: "Parsing Error"])
                    errorCallback(error)
                }
            case .failure(let error):
                failureCallback(error)
            }
        }
    }
    
    static func create(_ user: User, error errorCallback: @escaping (Swift.Error) -> Void,
                        failure failureCallback: @escaping (MoyaError) -> Void) {
        provider.request(EventsAPI.createUser(user)) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        let userJson = try response.mapJSON()
                        print(userJson)
                    }catch {
                        errorCallback(error)
                    }
                } else {
                    let error = NSError(domain: response.debugDescription, code: response.statusCode, userInfo:[NSLocalizedDescriptionKey: "Parsing Error"] )
                    errorCallback(error)
                }
            case .failure(let error):
                failureCallback(error)
            }
        }
    
    }
}
