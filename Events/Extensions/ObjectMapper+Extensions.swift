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
    public typealias JSON = [[String : Any]]
    
    init() {}
    
    public func transformFromJSON(_ value: Any?) -> List<Image>? {
        guard let items = value as? [[String : Any]] else { return nil }
        let mapperImages: [Image] = Mapper<Image>().mapArray(JSONArray: items)
        let realmImages = List<Image>()
        for image in mapperImages {
            realmImages.append(image)
        }
        return realmImages
    }
    public func transformToJSON(_ value: List<Image>?) -> [[String : Any]]? {
        guard let listImage = value else { return nil }
        guard listImage.count > 0 else { return nil }
        return Mapper<Image>().toJSONArray( Array(listImage))
    }
}

public class ListImageTransformJson: TransformType {
    
    public typealias Object = List<Image>
    public typealias JSON = [String]
    
    init() {}
    
    public func transformFromJSON(_ value: Any?) -> List<Image>? {
        guard let items = value as? [[String : Any]] else { return nil }
        let mapperImages: [Image] = Mapper<Image>().mapArray(JSONArray: items)
        let realmImages = List<Image>()
        for image in mapperImages {
            realmImages.append(image)
        }
        return realmImages
    }
    public func transformToJSON(_ value: List<Image>?) -> [String]? {
        guard let listImage = value else { return nil }
        guard listImage.count > 0 else { return nil }
        return listImage.map{ $0.url }
    }
}

public class ValueTransform: TransformType {
    
    public typealias Object = Double
    public typealias JSON = String
    
    init() {}

    public func transformFromJSON(_ value: Any?) -> Double? {
        if let valueString = value as? String {
            return Double(valueString)
        }else if let value = value as? Double {
            return value
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
