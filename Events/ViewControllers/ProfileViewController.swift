//
//  SettingsViewController.swift
//  Events
//
//  Created by Orlando Amorim on 04/09/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class ProfileViewController: FormViewController {
    
    let realm = try! Realm()
    
    var user: User? = try! Realm().objects(User.self).filter("logged == 1").first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = EventsTheme.linkColor
        setupForm()
        setupValues()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
        self.title = Events.localizable.tabBar.profile.localized
    }
    
    private func setupValues() {
        tableView.reloadData()
    }
    
    
    private func setupForm() {
        
        ButtonRow.defaultCellSetup = { cell, row in
            cell.textLabel?.backgroundColor = UIColor.clear
        }
        
        form +++ Section()
            
            
        +++ Section() {
            
            var footer = HeaderFooterView<EventUserView>(.nibFile(name: "EventUserView", bundle: nil))
            footer.onSetupView = { (view, section) -> () in
                if self.user != nil { view.set(self.user!) }
            }
            if user != nil { $0.footer = footer }
        }
        
        <<< ButtonRow() {
            $0.title = "\(Events.localizable.oauth.signUp.localized) | \(Events.localizable.oauth.signIn.localized)"
            $0.presentationMode = .segueName(segueName: "LoginSignUpSegue", onDismiss: nil)
            $0.hidden = user != nil ? true : false
        }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.profile.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
        }.cellUpdate({ (cell, row) in
            cell.textLabel?.textColor = .white
            cell.imageView?.tintColor = EventsTheme.linkColor
        })
        
        +++ Section()
            
        <<< ButtonRow() {
            $0.title = Events.localizable.eventStatus.add.localized
            }.onCellSelection { [weak self] (cell, row) in
                self?.showAlert()
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.addTickets.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = .white
                cell.textLabel?.textAlignment = .left
                cell.accessoryType = .disclosureIndicator
            })
            
        +++ Section()
        <<< ButtonRow() {
            $0.title = Events.localizable.oauth.termsOfUse.localized
            }.onCellSelection { [weak self] (cell, row) in
                self?.showAlert()
            }.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = .white
                cell.textLabel?.textAlignment = .left
                cell.accessoryType = .disclosureIndicator
            })
        
        <<< ButtonRow() { 
            $0.title = Events.localizable.oauth.privacyPolicy.localized
            }.onCellSelection { [weak self] (cell, row) in
                self?.showAlert()
            }.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = .white
                cell.textLabel?.textAlignment = .left
                cell.accessoryType = .disclosureIndicator
            })
    }
    
    
    func showAlert() {
        
    }
    
}
