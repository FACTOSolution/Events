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
    @objc dynamic var id = 0
    @objc dynamic var eventId = 0
    @objc dynamic var url = "http://lorempixel.com/300/300"
    var preview: UIImage? =  nil

    override public static func primaryKey() -> String? {
        return "id"
    }
    
    override public static func ignoredProperties() -> [String] {
        return ["preview"]
    }
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        if map.mappingType == .fromJSON {
            id      <- map["id"]
            eventId <- map["event_id"]
            url     <- map["image_url"]
            
        } else {
            url  >>> map["image_url"]
        }
    }
}
