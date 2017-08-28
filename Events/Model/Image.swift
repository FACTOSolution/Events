//
//  Image.swift
//  Events
//
//  Created by Orlando Amorim on 27/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import RealmSwift

public class Image: Object {
    dynamic var url = ""
    
    override public static func primaryKey() -> String? {
        return "url"
    }
    
}
