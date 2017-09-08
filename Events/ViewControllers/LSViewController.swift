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

// LogIn | SignUp
class LSViewController: FormViewController {
    
    enum LSType {
        case logIn
        case singUp
    }
    
    let type: LSType = .singUp
    
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
        self.title = type == .logIn ? Events.localizable.login.logIn.localized : Events.localizable.login.signUp.localized
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
        
            <<< EmailFloatLabelRow(Events.localizable.login.mail.localized) {
                $0.title = $0.tag
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
            
            <<< PasswordFloatLabelRow(Events.localizable.login.password.localized) {
                $0.title = $0.tag
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
        
            <<< PasswordFloatLabelRow(Events.localizable.login.passwordConfirmation.localized) {
                $0.title = $0.tag
                $0.hidden = type != .logIn ? false : true
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.validationOptions = .validatesOnChange
                $0.add(rule: RuleEqualsToRow(form: form, tag: Events.localizable.login.password.localized))
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
                $0.title = type == .logIn ? Events.localizable.login.logIn.localized : Events.localizable.login.signUp.localized
            }
            .onCellSelection { cell, row in
                if row.section?.form?.validate().count == 0 {
                    switch self.type {
                    case .logIn:    self.logIn()
                    case .singUp:   self.singUp()
                    }
                }
            }
    }
    
    private func logIn() {
        guard let email = form.rowBy(tag: Events.localizable.login.mail.localized) as? EmailFloatLabelRow else { return }
        guard let password = form.rowBy(tag: Events.localizable.login.password.localized) as? PasswordFloatLabelRow else { return }

        let user = User()
        user.email = email.value!
        user.password = password.value!
    }
    
    private func singUp() {
        guard let email = form.rowBy(tag: Events.localizable.login.mail.localized) as? EmailFloatLabelRow else { return }
        guard let password = form.rowBy(tag: Events.localizable.login.password.localized) as? PasswordFloatLabelRow else { return }
        guard let passwordConfirmation = form.rowBy(tag: Events.localizable.login.passwordConfirmation.localized) as? PasswordFloatLabelRow else { return }
        
        let user = User()
        user.email = email.value!
        user.password = password.value!
        user.passwordConfirmation = passwordConfirmation.value!
        user.nickname = "lololo"
        user.name = "PEDRO"

        UserNetworkAdapter.create(user, error: { (error) in
            print(error)
        }) { (moyaError) in
            print(moyaError)
        }
    }
}
