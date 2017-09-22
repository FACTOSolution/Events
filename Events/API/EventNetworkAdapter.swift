//
//  File.swift
//  Events
//
//  Created by Orlando Amorim on 24/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RealmSwift
import SDWebImage

struct EventNetworkAdapter {
    // Get the default Provider
    static let provider = MoyaProvider<EventsAPI>()
    // Get the default Realm
    static let realm = try! Realm()

    static func getAllEvents(error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        provider.request(EventsAPI.getEvents(OrderBy(date: .asc, value: .none))) { (result) in
            switch result {
            case .success(let response):
                // 1:
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        let eventsJson = try response.mapJSON()
                        let events: [Event] = Mapper<Event>().mapArray(JSONArray: eventsJson as! [[String : Any]])
                        try! realm.write {
                            realm.delete(realm.objects(Event.self))
                            realm.delete(realm.objects(Image.self))
                            //SDImageCache.shared().clearMemory()
                            //SDImageCache.shared().clearDisk()
                            for event in events {
                                realm.add(event, update: true)
                            }
                        }
                    }catch {
                        errorCallback(error)
                    }
                } else {
                    let error = NSError(domain: response.description, code: response.statusCode, userInfo:[NSLocalizedDescriptionKey: "Parsing Error"])
                    print(response)
                    errorCallback(error)
                }
            case .failure(let error):
                failureCallback(error)
            }
        }
    }
    
    static func getEvent(with id: Int, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        provider.request(EventsAPI.getEvent(id: id)) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        let eventsJson = try response.mapJSON()
                        let events: [Event] = Mapper<Event>().mapArray(JSONArray: eventsJson as! [[String : Any]])
                        
                        try! realm.write {
                            let rEvents = realm.objects(Event.self)
                            let rImage = realm.objects(Image.self)
                            realm.delete(rEvents)
                            realm.delete(rImage)
                            for event in events {
                                realm.add(event, update: true)
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
    
    static func create(_ event: Event,with oauthHeader: OauthHeader, success successCallback: @escaping () -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        provider.request(EventsAPI.createEvent(event, oauthHeader)) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        let event = try response.mapJSON()
                        print(event)
                        successCallback()
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
    
}
