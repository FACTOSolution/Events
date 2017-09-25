//
//  EventViewController.swift
//  Events
//
//  Created by Orlando Amorim on 27/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Eureka
import ImageSlideshow
import RealmSwift
import SDWebImage

class EventViewController: FormViewController {
    
    let realm = try! Realm()
    var event: Event? {
        didSet{
            setupForm()
            setupButtons()
            title = event!.name
            user = realm.objects(User.self).filter("id == %@", event!.ownerId).first
            load(user: event!.ownerId)
        }
    }
    
    var user: User? {
        didSet{
            let row = form.rowBy(tag: "CreatedBy") as! UserRow
            row.value = self.user
            row.updateCell()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = EventsTheme.linkColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        
        ImageRow.defaultCellSetup = { cell, row in
            cell.textLabel?.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = .white
            })
        }
    
       form +++ Section() {
            var header = HeaderFooterView<ImageSlideShow>(.nibFile(name: "ImageSlideShow", bundle: nil))
            header.onSetupView = { (view, section) -> () in
                view.delegate = self as ImageSlideShowDelegate
                view.set(self.event!.images)
            }
            $0.header = header
        }
        
        +++ Section()
        
        <<< DateTimeInlineRow(Events.localizable.formFields.startDate.localized) {
            $0.title = $0.tag
            $0.value = event!.startDate
            $0.disabled = true
        }.cellSetup { cell, row in
            cell.imageView?.image = Events.Images.calendar.image
            cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
            cell.tintColor = UIColor.white
        }

        <<< DateTimeInlineRow(Events.localizable.formFields.endDate.localized){
            $0.title = $0.tag
            $0.value = event!.endDate
            $0.disabled = true
            $0.hidden = event!.endDate == nil ? true : false
        }.cellSetup { cell, row in
            cell.imageView?.image = Events.Images.calendar.image
            cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
            cell.tintColor = UIColor.white
        }
        
        +++ Section(Events.localizable.formFields.description.localized)
        
        <<< TextAreaRow() {
            $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
            $0.value = event!._description
            $0.disabled = true
            $0.deselect(animated: true)
        }

        <<< TextRow() {
            $0.title = Events.localizable.formFields.value.localized
            $0.value = Events.localizable.formFields.free.localized
            $0.hidden = event!.value == 00.00 ? false : true
            $0.disabled = true
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.money.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }.cellUpdate({ (cell, row) in
                cell.textField.textColor = row.isDisabled ? .gray : .red
            })
        
        <<< DecimalRow(){
            $0.useFormatterDuringInput = true
            $0.title = Events.localizable.formFields.value.localized
            $0.value = event!.value
            let formatter = CurrencyFormatter()
            formatter.locale = .current
            formatter.numberStyle = .currency
            $0.formatter = formatter
            $0.hidden = event!.value == 00.00 ? true : false
            $0.disabled = true
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.money.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }
        
        
        +++ Section() {
            var footer = HeaderFooterView<MapCell>(.nibFile(name: "MapCell", bundle: nil))
            footer.onSetupView = { (view, section) -> () in
                view.set(self.event!)
            }
            
            $0.footer = footer
        }
        
        <<< TextRow() {
            $0.title = Events.localizable.formFields.address.localized
            $0.value = event!.address
            $0.disabled = true
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.marker.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }.cellUpdate({ (cell, row) in
                cell.imageView?.tintColor = EventsTheme.linkColor
            })
        
        +++ Section()
        
        +++ Section()
        <<< TextRow() {
            $0.title = Events.localizable.formFields.contact.localized
            $0.value = event!.contact
            $0.disabled = true
            }.cellSetup { cell, row in
                cell.imageView?.image = Events.Images.contact.image
                cell.imageView?.image = cell.imageView?.image!.withRenderingMode(.alwaysTemplate)
                cell.tintColor = UIColor.white
            }.cellUpdate({ (cell, row) in
                cell.imageView?.tintColor = EventsTheme.linkColor
            })
        
        +++ Section(Events.localizable.formFields.createdBy.localized)
        
        <<< UserRow("CreatedBy")
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
    
    private func setupButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Events.Images(rawValue: event!.type)?.image, style: .plain, target: nil, action: nil)
    }
    
    private func load(user id: Int) {
        UserNetworkAdapter.getUser(with: self.event!.ownerId, success: {
            self.user = self.realm.objects(User.self).filter("id == %@", self.event!.ownerId).first
        }, error: { (error) in
            print(error)
        }) { (moyaError) in
            print(moyaError)
        }
    }
}

extension EventViewController: ImageSlideShowDelegate {
    
    func slideShowTapped(cell: ImageSlideShow) {
        cell.slideshow.presentFullScreenController(from: self)
    }
}
