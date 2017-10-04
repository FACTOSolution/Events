//
//  AddEventViewController.swift
//  Events
//
//  Created by Orlando Amorim on 13/09/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import ObjectMapper
import RealmSwift

class AddEventViewController: FormViewController {

    var user: User? = try! Realm().objects(User.self).filter("logged == 1").first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupForm()
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    private func setUpUI() {
        title = Events.localizable.eventStatus.add.localized
        tableView.separatorColor = EventsTheme.linkColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(create))
        navigationOptions = .Disabled
    }
    
    private func setupForm() {
        NameRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            cell.tintColor = UIColor.white
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = UIColor.white
                cell.textLabel?.textColor = UIColor.white
            })
        }
        
        ActionSheetRow<String>.defaultCellSetup = { cell, row in
            row.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = UIColor.white
            })
        }
        
        TextAreaRow.defaultCellSetup = { cell, row in
            cell.textView.backgroundColor = .clear
            cell.textLabel?.backgroundColor = .clear
            cell.textView.keyboardAppearance = .dark
            row.cellUpdate({ (cell, row) in
                cell.textView.textColor = .white
                cell.textLabel?.textColor = .white
                cell.placeholderLabel?.textColor = .gray
            })
        }
        
        TextRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            cell.textLabel?.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = .white
                cell.textLabel?.textColor = .white
            })
        }
        
        DecimalRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            cell.textLabel?.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = .white
                cell.textLabel?.textColor = UIColor.white
            })
        }
        
        DateTimeInlineRow.defaultCellSetup = { cell, row in
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.detailTextLabel?.backgroundColor = UIColor.clear
            row.minimumDate = Date()
            row.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = UIColor.white
                cell.detailTextLabel?.textColor = .white
            })
        }
        
        DateTimeInlineRow.InlineRow.defaultCellSetup = {cell, inlineRow in
            cell.datePicker.setValue(UIColor.white, forKey: "textColor")
        }
        
        LocationRow.defaultCellSetup = { cell, row in
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.detailTextLabel?.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = UIColor.white
                cell.detailTextLabel?.textColor = .white
            })
        }
        
        SwitchRow.defaultCellSetup = { cell, row in
            row.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = UIColor.white
                cell.detailTextLabel?.textColor = .white
                cell.switchControl.tintColor = EventsTheme.linkColor
                cell.switchControl.onTintColor = EventsTheme.linkColor
            })
        }
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = .red
        }
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = .white
        }
        
        form +++ Section(footer: "• Requerido 1 imagem. \n• As imagens serão adicionadas na ordem em que estão apresentadas.")
            
            <<< ImageRow("PreviewImg1") {
                $0.title = Events.localizable.formFields.image.localized
                $0.placeholderImage = Events.Images.eventPlaceholder.image
                $0.add(rule: RuleRequired(msg:Events.localizable.formAlerts.image.localized))
                $0.validationOptions = .validatesOnChange
                }.onRowValidationChanged({ (cell, row) in
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
                })
            
            <<< ImageRow("PreviewImg2") {
                $0.title = Events.localizable.formFields.image.localized
                $0.placeholderImage = Events.Images.eventPlaceholder.image
            }
            
            <<< ImageRow("PreviewImg3") {
                $0.title = Events.localizable.formFields.image.localized
                $0.placeholderImage = Events.Images.eventPlaceholder.image
            }
            
        +++ Section()
        
            <<< NameRow("name") {
                $0.title = Events.localizable.formFields.name.localized
                $0.add(rule: RuleRequired(msg:Events.localizable.formAlerts.name.localized))
                $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }.onRowValidationChanged({ (cell, row) in
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
                })
        
            
            <<< ActionSheetRow<String>("type") {
                $0.title = Events.localizable.formFields.type.localized
                $0.selectorTitle = Events.localizable.formFields.type.localized
                $0.options = Events.localizable.eventType.all
                $0.value = Events.localizable.eventType.Academic.localized
                $0.add(rule: RuleRequired())
                }
                .onPresent { from, to in
                    to.popoverPresentationController?.permittedArrowDirections = .up
                    to.view.tintColor = EventsTheme.darkerColor
                    //to.blurStyle = .dark
                    to.blurStyle = .light

            }
            
        +++ Section()
        
        <<< DateTimeInlineRow("date") {
            //$0.title = Events.localizable.formFields.startDate.localized
            $0.value = Date()
            $0.add(rule: RuleRequired())
        }.cellSetup { cell, row in
            cell.imageView?.image = Events.Images.calendar.image
            cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
            cell.tintColor = UIColor.white
        }
            
        <<< SwitchRow("EndDate") {
            $0.title = Events.localizable.formFields.endDate.localized
            $0.value = false
            $0.hidden = true
        }
        
        <<< DateTimeInlineRow("endDate"){
            $0.title = Events.localizable.formFields.endDate.localized
            $0.value = Date()
            $0.hidden = "$EndDate == false"
        }.cellSetup { cell, row in
            cell.imageView?.image = Events.Images.calendar.image
            cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
            cell.tintColor = UIColor.white
        }
        
        +++ Section(Events.localizable.formFields.description.localized )
        
        <<< TextAreaRow("description") {
            $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
            $0.placeholder = "Este evento...  • " + Events.localizable.formAlerts.descriptionLimit.localized
            $0.add(rule: RuleMaxLength(maxLength: 350))
            $0.add(rule: RuleRequired(msg:Events.localizable.formAlerts.description.localized))
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
        
        <<< DecimalRow("value"){
            $0.useFormatterDuringInput = true
            $0.title = Events.localizable.formFields.value.localized
            $0.value = 00.00
            $0.add(rule: RuleRequired())
            let formatter = CurrencyFormatter()
            formatter.locale = .current
            formatter.numberStyle = .currency
            $0.formatter = formatter
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.money.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }
        
        +++ Section()
            
        <<< TextRow("address") {
            $0.title = Events.localizable.formFields.address.localized
            $0.add(rule: RuleRequired(msg:Events.localizable.formAlerts.address.localized))
            $0.validationOptions = .validatesOnChange
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.marker.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.textField?.textColor = .red
                }
            }.onRowValidationChanged({ (cell, row) in
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
            })
            
            
        <<< LocationRow("Location") {
            $0.title = Events.localizable.formFields.location.localized
            $0.value = CLLocation(latitude: -5.056265, longitude: -42.790367)
            $0.add(rule: RuleRequired())
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.map.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }
            
            
        +++ Section()
            <<< NameRow("contact") {
                $0.title = Events.localizable.formFields.contact.localized
                $0.add(rule: RuleRequired(msg:Events.localizable.formAlerts.contact.localized))
                $0.validationOptions = .validatesOnChange
                }.cellSetup { cell, row in
                    cell.imageView?.image = Events.Images.contact.image
                    cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                    cell.tintColor = UIColor.white
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }.onRowValidationChanged({ (cell, row) in
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
                })
        
        +++ Section()
        
            <<< ButtonRow() {
                $0.title = Events.localizable.formFields.preview.localized
                }.onCellSelection { [weak self] (cell, row) in
                   if row.section?.form?.validate().count == 0 {
                        self?.preview()
                    }
                }.cellSetup { cell, row in
                    cell.imageView?.image = Events.Images.preview.image
                    cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                    cell.tintColor = UIColor.white
                }.cellUpdate({ (cell, row) in
                    cell.textLabel?.textColor = .white
                    cell.textLabel?.textAlignment = .left
                    cell.accessoryType = .disclosureIndicator
                })

    }
    
    class CurrencyFormatter : NumberFormatter, FormatterProtocol {
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
            guard obj != nil else { return }
            var str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if !string.isEmpty, numberStyle == .currency && !string.contains(currencySymbol) {
                // Check if the currency symbol is at the last index
                if let formattedNumber = self.string(from: 1),
                    String(formattedNumber[formattedNumber.index(before: formattedNumber.endIndex)...]) == currencySymbol{
                    // This means the user has deleted the currency symbol. We cut the last number and then add the symbol automatically
                    str = String(str[..<str.index(before: str.endIndex)])
                }
            }
            obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
        }
        
        func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
            return textInput.position(from: position, offset:((newValue?.characters.count ?? 0) - (oldValue?.characters.count ?? 0))) ?? position
        }
    }
    
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func create() {
        if let event = getEvent(), let user = user {
            EventNetworkAdapter.create(event, with: user.oauthHeader!, success: { 
                self.dismiss(animated: true, completion: nil)
            }, error: { (error) in
                print(error)
            }, failure: { (moyaError) in
                print(moyaError)
            })
        }

    }
    
    private func getEvent() -> Event? {
        let values : Dictionary! = form.values()
        let event = Mapper<Event>().map(JSON: values as Any as! [String : Any])
        if let user = user {
            event?.ownerId = user.id
        }
        return event
    }
    
    private func preview() {
        
        let eventvc = self.storyboard!.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        eventvc.event = getEvent()
        self.navigationController?.pushViewController(eventvc, animated: true)
    }
    
}
