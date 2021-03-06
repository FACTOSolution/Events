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
    case createEvent(Event, OauthHeader)
    case updateEvent(Event, OauthHeader)
    case getEvent(id: Int)
    case getEvents(on: Int , order: OrderBy)
    case signIn(User)
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
            return "/event/add"
        case .updateEvent:
            return "/event"
        case .getEvent(let id):
            return "/event/\(id)"
        case .getEvents:
            return "/event"
        case .signIn:
            return "/auth/sign_in"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser, .getAllUsers, .getEvent:
            return .get
        case .createUser, .createEvent, .getEvents, .signIn:
            return .post
        case .updateUser, .updateEvent:
            return .put
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .createUser(let user), .updateUser(let user):
            var parameters = [String: Any]()
            parameters["email"] = user.email
            parameters["password"] = user.password
            parameters["password_confirmation"] = user.password
            
            parameters["name"] = user.name
            parameters["nickname"] = user.username
            parameters["image"] = user.image
            print(parameters)
            return parameters
        case .createEvent(let event,_), .updateEvent(let event,_):
            var parameters = [String: Any]()
            parameters["event"] = event.toJSON()
            return parameters
        case .getEvents(let page, let orderBy):
            var parameters = [String: Any]()
            
            parameters["page"] = page > 0 ? page : 1
            
            if orderBy.date != .none {
                parameters["date"] = orderBy.date.rawValue
            }
            
            if orderBy.value != .none {
                parameters["value"] = orderBy.value.rawValue
            }
            print(parameters)
            return parameters
        case .signIn(let user):
            var parameters = [String: Any]()
            parameters["email"] = user.email
            parameters["password"] = user.password
            print(parameters)
            return parameters
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getUser, .getAllUsers, .getEvent:
            return URLEncoding.default // Send parameters in URL for GET, DELETE and HEAD. For other HTTP methods, parameters will be sent in request body
        case .updateUser, .updateEvent:
            return URLEncoding.queryString // Always sends parameters in URL, regardless of which HTTP method is used
        case .createUser, .signIn, .getEvents:
            return JSONEncoding.default // Send parameters as JSON in request body
        case .createEvent:
            return JSONEncoding.prettyPrinted // Send parameters as JSON in request body
        }
    }
    
    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .createEvent, .updateEvent:
            return .requestCompositeParameters(bodyParameters: parameters!, bodyEncoding: parameterEncoding, urlParameters: headers!)
        case .createUser, .updateUser, .getEvents, .signIn:
            return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .createEvent(_, let oauthHeader), .updateEvent(_, let oauthHeader):
            var headers = [String: String]()
            headers["Access-Token"] = oauthHeader.accessToken
            headers["Token-Type"]   = oauthHeader.tokenType
            headers["Client"]       = oauthHeader.client
            headers["Expiry"]       = oauthHeader.expiry
            headers["Uid"]          = oauthHeader.uid
            headers["Content-Type"] = "application/json; charset=utf-8"
            return headers
            
        default:
            return ["Content-Type": "application/json; charset=utf-8"]
        }
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
