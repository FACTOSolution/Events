//
//  User.swift
//  Events
//
//  Created by Orlando Amorim on 24/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class User : Object, Mappable {

    dynamic var id = 0
    dynamic var uid = 0
    dynamic var name = ""
    dynamic var username = ""
    dynamic var email = ""
    dynamic var provider = ""
    dynamic var image = ""
    dynamic var created = Date()
    dynamic var updated = Date()
    
    dynamic var verified = false
    dynamic var logged = false
    dynamic var password = ""
    dynamic var oauthHeader: OauthHeader?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        uid         <- map["uid"]
        name        <- map["name"]
        username    <- map["nickname"]
        email       <- map["email"]
        provider    <- map["provider"]
        image       <- map["image"]
        created     <- (map["created_at"], DateFormatterTransform())
        created     <- (map["updated_at"], DateFormatterTransform())
        verified    <- map["verified"]
    }
}
