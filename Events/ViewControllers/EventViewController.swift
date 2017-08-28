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
    var event: Event? { didSet{ setupForm() } }

    var titleView: UIScrollView = UIScrollView()
    var contentView: UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.separatorColor = EventsTheme.textColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupForm() {
        TextAreaRow.defaultCellSetup = { cell, row in
            cell.backgroundColor = UIColor.clear
            cell.textView.backgroundColor = UIColor.clear
        }
        
    
       form +++ Section() {
            let imageImputs: [SDWebImageSource] =
                [SDWebImageSource(url: URL(string: "https://simg.minhateca.com.br/29b7da040214fe652630df4032e1a02e90cb9479?url=http%3A%2F%2Fi62.tinypic.com%2F2mw9kr9.jpg")!, placeholder: Events.Images.eventPlaceholder.image),
                 SDWebImageSource(url: URL(string: "https://avatars0.githubusercontent.com/u/25615186?v=3&s=200.jpg")!, placeholder: Events.Images.eventPlaceholder.image)]
        
            var header = HeaderFooterView<ImageSlideShow>(.nibFile(name: "ImageSlideShow", bundle: nil))
            header.onSetupView = { (view, section) -> () in
                
                view.delegate = self as ImageSlideShowDelegate
                view.slideshow.setImageInputs(imageImputs)
                
            }
            $0.header = header
        
            var footer = HeaderFooterView<EventEureka>(.nibFile(name: "EventEureka", bundle: nil))
            footer.onSetupView = { (view, section) -> () in
                view.set(self.event!)
            }
        
            $0.footer = footer
        }
        
//        +++ Section() {
//            var header = HeaderFooterView<EventEureka>(.nibFile(name: "EventEureka", bundle: nil))
//            header.onSetupView = { (view, section) -> () in
//                view.set(self.event!)
//            }
//            $0.header = header
//        }
        +++ Section(Events.Localizable.FormFields.description.localized)

        <<< TextAreaRow() {
            $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
            $0.value = event!._description
            $0.disabled = true
            $0.deselect(animated: true)
            }.cellSetup{ (cell, row) in
                cell.separatorInset = UIEdgeInsets(top: 0, left: 2000, bottom: 0, right: 0)
        }
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

