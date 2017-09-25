//
//  Model.swift/Users/orlandoamorim/Library/Mobile Documents/com~apple~CloudDocs/.Trash/Event.swift
//  Events
//
//  Created by Orlando Amorim on 24/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import CoreLocation

//Academico e Cultural
class Event: Object, Mappable {
    dynamic var id = 0
    dynamic var ownerId = 0
    dynamic var name = ""
    dynamic var _description = ""
    dynamic var contact = ""
    dynamic var value: Double = 0.0
    dynamic var address = ""
    dynamic var startDate = Date()
    dynamic var endDate: Date? = nil
    dynamic var created = Date()
    dynamic var updated = Date()
    dynamic var published = false
    var images = List<Image>()
    dynamic var type = ""
    dynamic var latitude = ""
    dynamic var longitude = ""
    
    enum EventStatus: Int { case approved = 0; case waiting = 1; case recused = 2; case reported = 3; }
    private dynamic var privateStatus: Int = EventStatus.approved.rawValue
    var status: EventStatus {
        get { return EventStatus(rawValue: privateStatus)! }
        set { privateStatus = newValue.rawValue }
    }

    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name            <- map["name"]
        _description    <- map["description"]
        contact         <- map["contact"]
        value           <- (map["value"], ValueTransform())
        address         <- map["address"]
        startDate       <- (map["date"], DateFormatterTransform())
        endDate         <- (map["endDate"], DateFormatterTransform())
        type            <- map["type"]
        latitude        <- map["lat"]
        longitude       <- map["long"]
        
        if map.mappingType == .fromJSON {
            id          <- map["event_id"]
            ownerId     <- map["user"]
            images      <- (map["images"], ListImageTransform())
            published   <- map["published"]
            created     <- (map["created_at"], DateFormatterTransform())
            updated     <- (map["updated_at"], DateFormatterTransform())
            
        } else {
            ownerId >>> map["user_id"]
            images  >>> (map["images_attributes"], ListImageTransform())
        }
        
        
        // Preview
        if let uImage = map.JSON["PreviewImg1"] as? UIImage {
            let image = Image()
            image.preview = uImage
            images.append(image)
        }
        
        if let uImage = map.JSON["PreviewImg2"] as? UIImage {
            let image = Image()
            image.preview = uImage
            images.append(image)
        }
        
        if let uImage = map.JSON["PreviewImg3"] as? UIImage {
            let image = Image()
            image.preview = uImage
            images.append(image)
        }

        //Location
        
        if let location = map.JSON["Location"] as? CLLocation {
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
        }
    }
}
