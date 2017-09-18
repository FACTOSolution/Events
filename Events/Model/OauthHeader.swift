//
//  Oauth.swift
//  Events
//
//  Created by Orlando Amorim on 11/09/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


class OauthHeader : Object, Mappable {
    
    dynamic var accessToken = ""
    dynamic var tokenType = ""
    dynamic var client = ""    
    dynamic var expiry = ""
    dynamic var uid = ""
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    
    public func mapping(map: Map) {
        accessToken <- map["Access-Token"]
        tokenType   <- map["Token-Type"]
        client      <- map["Client"]
        expiry      <- map["Expiry"]
        uid         <- map["Uid"]
    }
}
