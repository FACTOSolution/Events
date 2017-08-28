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

//Academico e Cultural
class Event: Object, Mappable {
    dynamic var id = 0
    dynamic var ownerId = 0
    dynamic var name = ""
    dynamic var _description = ""
    dynamic var contact = ""
    dynamic var value = ""
    dynamic var address = ""
    dynamic var date = Date()
    dynamic var created = Date()
    dynamic var updated = Date()
    dynamic var published = false
    var images = List<Image>()
    dynamic var type = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["event_id"]
        ownerId <- map["user"]
        name <- map["name"]
        _description <- map["description"]
        contact <- map["contact"]
        value <- map["value"]
        address <- map["address"]
        date <- (map["date"], DateFormatterTransform())
        created <- (map["created_at"], DateFormatterTransform())
        updated <- (map["updated_at"], DateFormatterTransform())
        published <- map["published"]
        images <- (map["image"], ListImageTransform())
        type <- map["type"]
    }
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()

}


//var nicknames: [String] {
//    get {
//        return _backingNickNames.map { $0.stringValue }
//    }
//    set {
//        _backingNickNames.removeAll()
//        _backingNickNames.appendContentsOf(newValue.map({ RealmString(value: [$0]) }))
//    }
//}
//let _backingNickNames = List<RealmString>()


