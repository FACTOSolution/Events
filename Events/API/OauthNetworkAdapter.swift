//
//  Oauth.swift
//  Events
//
//  Created by Orlando Amorim on 08/09/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RealmSwift

struct OauthNetworkAdapter {
    // Get the default Provider
    static let provider = MoyaProvider<EventsAPI>()
    // Get the default Realm
    static let realm = try! Realm()

    
    static func signIn(_ user: User, success successCallback: @escaping () -> Void, error errorCallback: @escaping (Swift.Error) -> Void,
                       failure failureCallback: @escaping (MoyaError) -> Void) {
        provider.request(EventsAPI.signIn(user)) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        let oauthJson = try response.mapJSON()
                        print(oauthJson)
                        if let oauthDictionary = Mapper<User>().mapDictionary(JSON: oauthJson as! [String : [String : Any]]) {
                            if let user = oauthDictionary["data"] {
                                //User is logged
                                user.logged = true
                                //Adding header fields to User
                                user.oauthHeader = Mapper<OauthHeader>().map(JSON: response.response?.allHeaderFields as! [String : Any])
                                try! realm.write {
                                    realm.add(user, update: true)
                                }
                                successCallback()
                            }
                        }
                    }catch {
                        errorCallback(error)
                    }
                } else {
                    print(response)
                    let error = NSError(domain: response.debugDescription, code: response.statusCode, userInfo:[NSLocalizedDescriptionKey: "Parsing Error"] )
                    errorCallback(error)
                }
            case .failure(let error):
                failureCallback(error)
            }
        }
    }
    
    
    
    static func signIn(creating user: User, success successCallback: @escaping () -> Void, error errorCallback: @escaping (Swift.Error) -> Void,
                       failure failureCallback: @escaping (MoyaError) -> Void) {
        //1: Creating User
        UserNetworkAdapter.create(user, success: {
            //2: Sign In the user
            provider.request(EventsAPI.signIn(user)) { (result) in
                switch result {
                case .success(let response):
                    if response.statusCode >= 200 && response.statusCode <= 300 {
                        do {
                            let oauthJson = try response.mapJSON()
                            
                            if let oauthDictionary = Mapper<User>().mapDictionary(JSON: oauthJson as! [String : [String : Any]]) {
                                if let user = oauthDictionary["data"] {
                                    //User is logged
                                    user.logged = true
                                    //Adding header fields to User
                                    user.oauthHeader = Mapper<OauthHeader>().map(JSON: response.response?.allHeaderFields as! [String : Any])
                                
                                    try! realm.write {
                                        realm.add(user, update: true)
                                    }
                                    successCallback()
                                }
                            }
                        }catch {
                            errorCallback(error)
                        }
                    } else {
                        print(response)
                        let error = NSError(domain: response.debugDescription, code: response.statusCode, userInfo:[NSLocalizedDescriptionKey: "Parsing User SignIn Error"] )
                        errorCallback(error)
                    }
                case .failure(let error):
                    failureCallback(error)
                }
            }
            
        }, error: { (error) in
            errorCallback(error)
        }) { (moyaError) in
            failureCallback(moyaError)
        }
    }
    
    static func signOut(_ user: User) {
        //User is logged
        try! realm.write {
            if let oauthHeader = user.oauthHeader {
                realm.delete(oauthHeader)
            }
            realm.delete(user)
        }
    }
    
}
