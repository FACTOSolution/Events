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
        
    // Image Names
    enum Images: String, ImageRepresentable {
        case academic                   = "Academic"
        case cultural                   = "Cultural"
        case settings                   = "Settings"
        case eventPlaceholder           = "EventPlaceholder"
        case userPlaceholder            = "UserPlaceholder"
        case profile                    = "Profile"
        case money                      = "Money"
        case marker                     = "Marker"
        case ticket                     = "Tickets"
        case addTickets                 = "AddTickets"
        case ticketAccepted             = "TicketAccepted"
        case ticketWaitingForApproving  = "TicketWaitingForApproving"
        case ticketDenied               = "TicketDenied"
        case signOut                    = "SignOut"
        case calendar                   = "Calendar"
        case map                        = "Map"
        case preview                    = "Preview"
        case contact                    = "Contact"
    }
    
    // Localizable Strings
    enum localizable {
        
        // Common Names
        enum common: String, LocalizeRepresentable {
            case event      = "common.event"
            case user       = "common.user"
        }
        
        enum eventType: String, LocalizeRepresentable {
            case Academic   = "eventType.academic"
            case Cultural   = "eventType.cultural"
            
            static let all = [Academic.localized, Cultural.localized] as [String]
        }
        
        enum eventStatus: String, LocalizeRepresentable {
            case add                    = "eventStatus.add"
            case update                 = "eventStatus.update"
            case delete                 = "eventStatus.delete"
            case accepted               = "eventStatus.accepted"
            case waitingForApproving    = "eventStatus.waitingForApproving"
            case denied                 = "eventStatus.denied"
        }
        
        // Common Names
        enum tabBar: String, LocalizeRepresentable {
            case events     = "tabBar.events"
            case profile    = "tabBar.profile"
            case settings   = "tabBar.settings"
        }
        
        enum oauth: String, LocalizeRepresentable {
            case mail                   = "oauth.mail"
            case password               = "oauth.password"
            case passwordConfirmation   = "oauth.passwordConfirmation"
            case userName               = "oauth.userName"
            case signIn                 = "oauth.signIn"
            case signUp                 = "oauth.signUp"
            case signOut                = "oauth.signOut"
            case welcome                = "oauth.welcome"
            case terms                  = "oauth.terms"
            case termsOfUse             = "oauth.termsOfUse"
            case privacyPolicy          = "oauth.privacyPolicy"
        }
        
        enum oauthAlerts: String, LocalizeRepresentable {
            case password               = "oauthAlert.password"
            case passwordConfirmation   = "oauthAlert.passwordConfirmation"
            case userName               = "oauthAlert.userName"
            case mail                   = "oauthAlert.mail"
            case emailPasswordError     = "oauthAlert.emailPasswordError"
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
            case location       = "formFields.location"
            case image          = "formFields.image"
            case preview        = "formFields.preview"
            case type           = "formFields.type"
            case contact        = "formFields.contact"
        }
        
        enum formAlerts: String, LocalizeRepresentable {
            case image              = "formAlert.image"
            case name               = "formAlert.name"
            case description        = "formAlert.description"
            case descriptionLimit   = "formAlert.descriptionLimit"
            case address            = "formAlert.address"
            case contact            = "formAlert.contact"
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
