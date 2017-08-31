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

class EventViewController: FormViewController {
    
    let realm = try! Realm()
    var event: Event? {
        didSet{
            setupForm()
            setupButtons()
            title = event!.name
        }
    }

    var titleView: UIScrollView = UIScrollView()
    var contentView: UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.separatorColor = EventsTheme.linkColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupForm() {
        let font = UIFont(name: "Avenir-Black", size: 23.0)
        
        NameRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = .white
                cell.textField.textAlignment = .center
                cell.textField.minimumFontSize = 14
                cell.textField.font = font
            })
        }
        
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
    
       form +++ Section() {
            var imageImputs: [SDWebImageSource] = [SDWebImageSource]()

            for image in event!.images {
                imageImputs.append(SDWebImageSource(urlString: image.url, placeholder: Events.Images.eventPlaceholder.image)!)
            }
        
        if imageImputs.count == 0 { imageImputs.append(SDWebImageSource(urlString: "https://avatars2.githubusercontent.com/u/25615186?v=4&s=200.png", placeholder: Events.Images.eventPlaceholder.image)!)}
        
            var header = HeaderFooterView<ImageSlideShow>(.nibFile(name: "ImageSlideShow", bundle: nil))
            header.onSetupView = { (view, section) -> () in
                
                view.delegate = self as ImageSlideShowDelegate
                view.slideshow.setImageInputs(imageImputs)
            }
        
            $0.header = header
        }
        
//        <<< NameRow () {
//            $0.value = event!.name
//            $0.disabled = true
//        }
        
        +++ Section()
        
        <<< DateTimeInlineRow(Events.Localizable.FormFields.startDate.localized) {
            $0.title = $0.tag
            $0.value = event!.startDate
            $0.disabled = true

            }

        <<< DateTimeInlineRow(Events.Localizable.FormFields.endDate.localized){
            $0.title = $0.tag
            $0.value = event!.endDate
            $0.disabled = true
            $0.hidden = event!.endDate == nil ? true : false
        }
        
        +++ Section(Events.Localizable.FormFields.description.localized)
        
        <<< TextAreaRow() {
            $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
            $0.value = event!._description
            $0.disabled = true
            $0.deselect(animated: true)
            }

        <<< TextRow() {
            $0.title = Events.Localizable.FormFields.value.localized
            $0.value = Events.Localizable.FormFields.free.localized
            $0.hidden = event!.value == 00.00 ? false : true
            $0.disabled = true
            }.cellUpdate({ (cell, row) in
                print(row.isDisabled)
                cell.textField.textColor = row.isDisabled ? .gray : .red
            })
        
        <<< DecimalRow(){
            $0.useFormatterDuringInput = true
            $0.title = Events.Localizable.FormFields.value.localized
            $0.value = event!.value
            let formatter = CurrencyFormatter()
            formatter.locale = .current
            formatter.numberStyle = .currency
            $0.formatter = formatter
            $0.hidden = event!.value == 00.00 ? true : false
            $0.disabled = true
        }
        
        
        +++ Section() {
            var footer = HeaderFooterView<MapCell>(.nibFile(name: "MapCell", bundle: nil))
            footer.onSetupView = { (view, section) -> () in
                view.set(self.event!)
            }
            
            $0.footer = footer
        }
        
        <<< TextRow() {
            $0.title = Events.Localizable.FormFields.address.localized
            $0.value = event!.address
            $0.disabled = true
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
    
    private func setupButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Events.Images(rawValue: event!.type)?.image, style: .plain, target: nil, action: nil)
    }
    
}

extension EventViewController: ImageSlideShowDelegate {
    
    func slideShowTapped(cell: ImageSlideShow) {
        //cell.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        cell.slideshow.presentFullScreenController(from: self)

    }
    
}

extension UITableViewCell {
    
    var isSeparatorHidden: Bool {
        get {
            return self.separatorInset.right != 0
        }
        set {
            if newValue {
                self.separatorInset = UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)
            } else {
                self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
        }
    }
    
}
