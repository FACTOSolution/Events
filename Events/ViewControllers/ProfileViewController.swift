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
        setupForm()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.user = try! Realm().objects(User.self).filter("logged == 1").first
        self.form.rowBy(tag: "isLogged")?.baseValue = self.user != nil ? true : false
        self.form.rowBy(tag: "isLogged")?.updateCell()
    }
    
    private func setupUI() {
        self.title = Events.localizable.tabBar.profile.localized
        self.tableView.separatorColor = EventsTheme.linkColor
    }
    
    private func setupForm() {
        
        ButtonRow.defaultCellSetup = { cell, row in
            cell.textLabel?.backgroundColor = UIColor.clear
        }
        
        form
            
            +++ Section() {
                $0.tag = "HeaderEventUserViewSpace"
                $0.hidden = true
            }
            
            <<< SwitchRow("isLogged") { [weak self] in
                $0.title = "Navigation accessory view"
                $0.value = self?.user != nil ? true : false
            }
            
            
        +++ Section() {
            
            var header = HeaderFooterView<EventUserView>(.nibFile(name: "EventUserView", bundle: nil))
            header.onSetupView = { (view, section) -> () in
                if self.user != nil { view.set(self.user!) }
            }
            $0.footer = header
            $0.hidden = "$isLogged == false"
        }
        
        +++ Section() {
            $0.tag = "SingInSection"
            $0.hidden = "$isLogged == true"
        }

            
        <<< ButtonRow("\(Events.localizable.oauth.signUp.localized) | \(Events.localizable.oauth.signIn.localized)") {
            $0.title = $0.tag
            $0.presentationMode = .segueName(segueName: "LoginSignUpSegue", onDismiss: nil)
        }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.profile.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
        }.cellUpdate({ (cell, row) in
            cell.textLabel?.textColor = .white
            cell.imageView?.tintColor = EventsTheme.linkColor
        })
            
        +++ Section() {
            $0.hidden = "$isLogged == false"
        }
            
        <<< ButtonRow(Events.localizable.eventStatus.add.localized) {
            $0.title = $0.tag
            }.onCellSelection { [weak self] (cell, row) in
                self?.addEvent()
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
        
            +++ Section() {
                $0.hidden = "$isLogged == false"
            }
        
        <<< ButtonRow() {
            $0.title = Events.localizable.oauth.signOut.localized
            }.onCellSelection { [weak self] (cell, row) in
                self?.signOut()
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.signOut.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = .white
                cell.textLabel?.textAlignment = .left
                cell.accessoryType = .disclosureIndicator
            })
    }

    func showAlert() {
        
    }
    
    private func addEvent() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)
    }
    
    private func signOut() {
        if let user = self.user {
            OauthNetworkAdapter.signOut(user)
            self.user = try! Realm().objects(User.self).filter("logged == 1").first
            self.form.rowBy(tag: "isLogged")?.baseValue = self.user != nil ? true : false
            self.form.rowBy(tag: "isLogged")?.updateCell()
        }
    }
    
}
