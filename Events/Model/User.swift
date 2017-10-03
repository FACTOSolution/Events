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

    @objc dynamic var id = 0
    @objc dynamic var uid = 0
    @objc dynamic var name = ""
    @objc dynamic var username = ""
    @objc dynamic var email = ""
    @objc dynamic var provider = ""
    @objc dynamic var image = ""
    @objc dynamic var created = Date()
    @objc dynamic var updated = Date()
    
    @objc dynamic var verified = false
    @objc dynamic var logged = false
    @objc dynamic var password = ""
    @objc dynamic var oauthHeader: OauthHeader?
    
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
