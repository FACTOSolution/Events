//
//  Enums+Extensions.swift
//  Events
//
//  Created by Orlando Amorim on 22/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit

// MARK: - Project Constants
enum Events {
    
    //Events Types
    enum Types: String {
        case academic = "Academic"
        case cultural = "Cultural"
        
        func localized() -> String {
            switch self {
                case .academic: return localizable.common.academic.localized
                case .cultural: return localizable.common.cultural.localized
            }
        }
    }
    
    // Image Names
    enum Images: String, ImageRepresentable {
        case academic               = "Academic"
        case cultural               = "Cultural"
        case eventPlaceholder       = "EventPlaceholder"
        case userPlaceholder        = "UserPlaceholder"
        case userPlaceholderForm    = "userPlaceholderForm"
    }
    
    // Localizable Strings
    enum localizable {
        
        // Common Names
        enum common: String, LocalizeRepresentable {
            case event      = "common.event"
            case user       = "common.user"
            case academic   = "common.academic"
            case cultural   = "common.cultural"
        }
        
        // Common Names
        enum tabBar: String, LocalizeRepresentable {
            case events     = "tabBar.events"
            case settings   = "tabBar.settings"
        }
        
        enum login: String, LocalizeRepresentable {
            case mail       = "login.mail"
            case password   = "login.password"
            case userName   = "login.userName"
            case logIn      = "login.logIn"
            case signUp     = "login.signUp"
            case welcome    = "login.welcome"
            case terms      = "login.terms"
        }
        
        // Alert Types
        enum alertType: String, LocalizeRepresentable {
            case change     = "alertType.change"
            case error      = "alertType.error"
            case delete     = "alertType.delete"
            case wait       = "alertType.wait"
            case add        = "alertType.add"
            case update     = "alertType.update"
            case cancel     = "alertType.cancel"
            case createdAt  = "alertType.createdAt"
            case ok         = "alertType.ok"
        }
        
        enum formFields: String, LocalizeRepresentable {
            case name           = "formFields.name"
            case birthday       = "formFields.birthday"
            case gender         = "formFields.gender"
            case ethnic         = "formFields.ethnic"
            case mail           = "formFields.mail"
            case phoneNumber    = "formFields.phoneNumber"
            case about          = "formFields.about"
            case description    = "formFields.description"
            case startDate      = "formFields.startDate"
            case endDate        = "formFields.endDate"
            case value          = "formFields.value"
            case createdBy      = "formFields.createdBy"
            case report         = "formFields.report"
            case address        = "formFields.address"
            case free           = "formFields.free"
        }
        
        enum camera: String, LocalizeRepresentable {
            case camera             = "camera.camera"
            case photoLibrary       = "camera.photoLibrary"
            case savedPhotosAlbum   = "camera.savedPhotosAlbum"
        }
        
        enum tableView: String, LocalizeRepresentable {
            case pullToRefresh  = "tableView.pullToRefresh"
        }
    }

}


// MARK: - Representable Protocols
protocol ImageRepresentable: RawRepresentable {
    var image: UIImage? { get }
}

protocol LocalizeRepresentable: RawRepresentable {
    var localized: String { get }
}


// MARK: - Representable Protocols Extensions
extension ImageRepresentable where RawValue == String {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}

extension LocalizeRepresentable where RawValue == String {
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
