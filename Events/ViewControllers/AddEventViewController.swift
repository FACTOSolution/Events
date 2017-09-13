//
//  AddEventViewController.swift
//  Events
//
//  Created by Orlando Amorim on 13/09/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Eureka

class AddEventViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    private func setupForm() {
        TextAreaRow.defaultCellSetup = { cell, row in
            cell.textView.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textView.textColor = UIColor.white
            })
        }
        
        TextRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            cell.textLabel?.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = .white
            })
        }
        
        DecimalRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            cell.textLabel?.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = .white
            })
        }
        
        DateTimeInlineRow.defaultCellSetup = { cell, row in
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.detailTextLabel?.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.detailTextLabel?.textColor = .white
            })
        }
        
        form +++ Section()
        
        <<< NameRow() { $0.title = Events.localizable.formFields.name.localized }
        
        +++ Section()
        
        <<< DateTimeInlineRow(Events.localizable.formFields.startDate.localized) {
            $0.title = $0.tag
        }
            
        <<< SwitchRow("EndDate") {
            $0.title = Events.localizable.formFields.endDate.localized
            $0.value = false
        }
        
        <<< DateTimeInlineRow(Events.localizable.formFields.endDate.localized){
            $0.title = $0.tag
            $0.hidden = "$EndDate == false"
        }
        
        +++ Section(Events.localizable.formFields.description.localized)
        
        <<< TextAreaRow() {
            $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
        }
        
        <<< DecimalRow(){
            $0.useFormatterDuringInput = true
            $0.title = Events.localizable.formFields.value.localized
            let formatter = CurrencyFormatter()
            formatter.locale = .current
            formatter.numberStyle = .currency
            $0.formatter = formatter
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.money.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }.cellUpdate({ (cell, row) in
                cell.imageView?.tintColor = EventsTheme.linkColor
            })
        
        +++ Section()
            
        <<< TextRow() {
            $0.title = Events.localizable.formFields.address.localized
            $0.disabled = true
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.marker.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }.cellUpdate({ (cell, row) in
                cell.imageView?.tintColor = EventsTheme.linkColor
            })
        
        <<< LocationRow() {
            $0.title = Events.localizable.formFields.location.localized
        }

    }
    
    class CurrencyFormatter : NumberFormatter, FormatterProtocol {
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
            guard obj != nil else { return }
            var str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if !string.isEmpty, numberStyle == .currency && !string.contains(currencySymbol) {
                // Check if the currency symbol is at the last index
                if let formattedNumber = self.string(from: 1),
                    formattedNumber.substring(from: formattedNumber.index(before: formattedNumber.endIndex)) == currencySymbol {
                    // This means the user has deleted the currency symbol. We cut the last number and then add the symbol automatically
                    str = str.substring(to: str.index(before: str.endIndex))
                }
            }
            obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
        }
        
        func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
            return textInput.position(from: position, offset:((newValue?.characters.count ?? 0) - (oldValue?.characters.count ?? 0))) ?? position
        }
    }
}
