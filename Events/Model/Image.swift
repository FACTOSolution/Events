//
//  Image.swift
//  Events
//
//  Created by Orlando Amorim on 27/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

public class Image: Object, Mappable {
    dynamic var id = 0
    dynamic var eventId = 0
    dynamic var url = ""

    override public static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        id      <- map["id"]
        eventId <- map["event_id"]
        url     <- map["image_url"]
    }
}