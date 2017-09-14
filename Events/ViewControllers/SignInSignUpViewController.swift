//
//  LSViewController.swift
//  Events
//
//  Created by Orlando Amorim on 05/09/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage
import Eureka

// SignIn | SignUp
class SignInSignUpViewController: FormViewController {
    
    enum OauthType {
        case signIn
        case signUp
    }
    
    let type: OauthType = .signIn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        self.title = type == .signIn ? Events.localizable.oauth.signIn.localized : Events.localizable.oauth.signUp.localized
        self.tableView.separatorColor = EventsTheme.linkColor
        
        navigationOptions = .Disabled
    }
    
    private func setupValues() {

    }
    
    private func setupForm() {
        
        EmailFloatLabelRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            cell.textLabel?.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = .white
            })
        }
        
        PasswordFloatLabelRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            cell.textLabel?.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = .white
            })
        }
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = .red
        }
        
        
        form +++ Section()
        
            <<< EmailFloatLabelRow(Events.localizable.oauth.mail.localized) {
                $0.title = $0.tag
                $0.value = "factos@factos.com"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChange
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< PasswordFloatLabelRow(Events.localizable.oauth.password.localized) {
                $0.title = $0.tag
                $0.value = "12345678"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.validationOptions = .validatesOnChange
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                                $0.cell.textLabel?.textColor = .red
                                
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
        
            <<< PasswordFloatLabelRow(Events.localizable.oauth.passwordConfirmation.localized) {
                $0.title = $0.tag
                $0.value = "12345678"
                $0.hidden = type != .signIn ? false : true
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.validationOptions = .validatesOnChange
                $0.add(rule: RuleEqualsToRow(form: form, tag: Events.localizable.oauth.password.localized))
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                                $0.cell.textLabel?.textColor = .red
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
                }
        
            +++ Section()
            
            <<< ButtonRow() {
                $0.title = type == .signIn ? Events.localizable.oauth.signIn.localized : Events.localizable.oauth.signUp.localized
            }.cellSetup({ (cell, row) in
                cell.tintColor = EventsTheme.linkColor
            }).onCellSelection { cell, row in
                if row.section?.form?.validate().count == 0 {
                    switch self.type {
                    case .signIn:   self.signIn()
                    case .signUp:   self.signUp()
                    }
                }
            }
    }
    
    private func signIn() {
        guard let email = form.rowBy(tag: Events.localizable.oauth.mail.localized) as? EmailFloatLabelRow else { return }
        guard let password = form.rowBy(tag: Events.localizable.oauth.password.localized) as? PasswordFloatLabelRow else { return }

        let user = User()
        user.email = email.value!
        user.password = password.value!
        
        OauthNetworkAdapter.signIn(user, success: {
            if let nvc = self.navigationController {
                nvc.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }, error: { (error) in
            print(error)
        }) { (moyaError) in
            print(moyaError)
        }
    }
    
    private func signUp() {
        guard let email = form.rowBy(tag: Events.localizable.oauth.mail.localized) as? EmailFloatLabelRow else { return }
        guard let password = form.rowBy(tag: Events.localizable.oauth.password.localized) as? PasswordFloatLabelRow else { return }
        
        let user = User()
        user.email = email.value!
        user.password = password.value!
        print(user)
        OauthNetworkAdapter.signIn(creating: user, success: { 
            if let nvc = self.navigationController {
                nvc.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }, error: { (error) in
            print(error)
        }) { (moyaError) in
            print(moyaError)
        }
    }
}
