//
//  EventsAPI.swift
//  Events
//
//  Created by Orlando Amorim on 24/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Moya

enum EventsAPI {
    case createUser(User)
    case updateUser(User)
    case getUser(id: Int)
    case getAllUsers
    case createEvent(Event)
    case updateEvent(Event)
    case getEvent(id: Int)
    case getEvents(OrderBy)
}

struct OrderBy {
    enum Date: String {
        case asc    = "asc"
        case desc   = "desc"
        case none   = "none"
    }
    
    enum Value: String {
        case asc    = "asc"
        case desc   = "desc"
        case none   = "none"
    }
    
    let date: Date
    let value: Value
}

// MARK: - TargetType Protocol Implementation
extension EventsAPI: TargetType {
    var baseURL: URL { return URL(string: "https://still-reaches-96571.herokuapp.com")! }
    var path: String {
        switch self {
        case .createUser:
            return "/auth"
        case .updateUser(let user):
            return "/users/\(user.id)"
        case .getUser(let id):
            return "/users/\(id)"
        case .getAllUsers:
            return "/users"
        case .createEvent:
            return "/event"
        case .updateEvent(let event):
            return "/event/\(event.id)"
        case .getEvent(let id):
            return "/event/\(id)"
        case .getEvents:
            return "/event"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getUser, .getAllUsers, .getEvent:
            return .get
        case .createUser, .createEvent, .getEvents:
            return .post
        case .updateUser, .updateEvent:
            return .put
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .getUser, .getAllUsers, .getEvent:
            return nil
        case .createUser(let user), .updateUser(let user):
            var parameters = [String: Any]()
            parameters["email"] = user.email
            parameters["password"] = user.password
            parameters["password_confirmation"] = user.passwordConfirmation
            
            parameters["name"] = user.name
            parameters["nickname"] = user.nickname
            parameters["image"] = user.image
            print(parameters)
            return parameters
        case .createEvent(let event), .updateEvent(let event):
            var parameters = [String: Any]()
            parameters["id"] = event.id
            parameters["name"] = event.name
            parameters["user_id"] = event.ownerId
            parameters["description"] = event.description
            parameters["contact"] = event.contact
            parameters["value_in_real"] = event.value
            parameters["address"] = event.address
            parameters["startDate"] = event.startDate
            parameters["endDate"] = event.endDate
            parameters["created_at"] = event.created
            parameters["updated_at"] = event.updated
            parameters["published"] = event.published
            parameters["type"] = event.type
            print(parameters)
            return parameters
            
        case .getEvents(let orderBy):
            var parameters = [String: Any]()
            
            if orderBy.date != .none {
                parameters["date"] = orderBy.date.rawValue
            }
            
            if orderBy.value != .none {
                parameters["value"] = orderBy.value.rawValue
            }
            
            return parameters
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getUser, .getAllUsers, .getEvent, .getEvents:
            return URLEncoding.default // Send parameters in URL for GET, DELETE and HEAD. For other HTTP methods, parameters will be sent in request body
        case .updateUser, .updateEvent:
            return URLEncoding.queryString // Always sends parameters in URL, regardless of which HTTP method is used
        case .createUser, .createEvent:
            return JSONEncoding.default // Send parameters as JSON in request body
        }
    }
    
    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .createUser, .updateUser, .getUser, .getAllUsers, .createEvent, .updateEvent, .getEvent, .getEvents:
            return .request
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json; charset=utf-8"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
