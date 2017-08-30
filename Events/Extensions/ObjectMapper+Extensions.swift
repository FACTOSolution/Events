//
//  ObjectMapper+Extensions.swift
//  Events
//
//  Created by Orlando Amorim on 27/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

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

public class ListImageTransform: TransformType {

    public typealias Object = List<Image>
    public typealias JSON = [String]
    
    init() {}
    
    public func transformFromJSON(_ value: Any?) -> List<Image>? {
        let listImage = List<Image>()
        guard let items = value as? [String] else { return listImage }
        for item in items {
            let image = Image()
            image.url = item
            listImage.append(image)
        }
        return listImage
    }
    public func transformToJSON(_ value: List<Image>?) -> [String]? {
        guard let listImage = value else { return nil }
        var arrayImage:[String] = [String]()
        for image in listImage {
            arrayImage.append(image.url)
        }
        return arrayImage
    }
}

public class ValueTransform: TransformType {
    
    public typealias Object = Double
    public typealias JSON = String
    
    init() {}

    public func transformFromJSON(_ value: Any?) -> Double? {
        if let valueString = value as? String {
            return Double(valueString)
        }
        return nil
    }
    public func transformToJSON(_ value: Double?) -> String? {
        if let value = value {
            return String(value)
        }
        return nil
    }
    
}
