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
        case login
        case singup
    }
    
    let type: LSType = .login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        self.title = Events.localizable.tabBar.settings.localized
    }
    
    private func setupValues() {

    }
    
    private func setupForm() {
        
        form +++ Section()
        
            <<< PasswordFloatLabelRow() {
                $0.title = Events.localizable.login.mail.localized
            }
            
            <<< PasswordFloatLabelRow() {
                $0.title = Events.localizable.login.password.localized
            }
    }
    
    
}
