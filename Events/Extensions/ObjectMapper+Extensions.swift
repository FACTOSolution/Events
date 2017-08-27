//
//  ObjectMapper+Extensions.swift
//  Events
//
//  Created by Orlando Amorim on 27/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import ObjectMapper

public class DateFormatterTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    init() {}
    
    public func transformFromJSON(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            return self.dateFormatter.date(from: dateString)
        }
        return nil
    }
    public func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return self.dateFormatter.string(from: date)
        }
        return nil
    }
}
