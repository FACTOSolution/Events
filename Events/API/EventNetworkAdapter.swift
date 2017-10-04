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
    //Page counter
    static private var page: Int = 1
    
    static func getEvent(paginated: Bool = true, success successCallback: @escaping (_ lastPage: Bool) -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        page = paginated == true ? page : 1
        provider.request(EventsAPI.getEvents(on: page , order: OrderBy(date: .asc, value: .none))) { (result) in
            switch result {
            case .success(let response):
                // 1:
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        let eventsJson = try response.mapJSON()
                        let events: [Event] = Mapper<Event>().mapArray(JSONArray: eventsJson as! [[String : Any]])
                        try! realm.write {
                            if page == 1 {
                                realm.delete(realm.objects(Event.self))
                                realm.delete(realm.objects(Image.self))
                                //SDImageCache.shared().clearMemory()
                                //SDImageCache.shared().clearDisk()
                            }
                            for event in events {
                                realm.add(event, update: true)
                            }
                        }
                        events.count > 0 ? successCallback(false) : successCallback(true)
                        page = (paginated == true && events.count > 0) ? (page + 1) : page
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
    
    static func create(_ event: Event, with oauthHeader: OauthHeader, success successCallback: @escaping () -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        provider.request(EventsAPI.createEvent(event, oauthHeader)) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    print(response)
                    do {
                        let eventJson = try response.mapJSON()
                        print(eventJson)
                        if let event = Mapper<Event>().map(JSON: eventJson as! [String : Any]) {
                            print(event)
                            successCallback()
                        } else {
                            let error = NSError(domain: response.description, code: response.statusCode, userInfo:[NSLocalizedDescriptionKey: "Parsing Error"])
                            errorCallback(error)
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
    
}
