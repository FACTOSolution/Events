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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.    
        //setupForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupForm() {
    
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
        }
        
        +++ Section("Section1")
        <<< TextRow(){ row in
            row.title = "Text Row"
            row.placeholder = "Enter text here"
        }
        <<< PhoneRow(){
            $0.title = "Phone Row"
            $0.placeholder = "And numbers here"
        }
        +++ Section("Section2")
        <<< DateRow(){
            $0.title = "Date Row"
            $0.value = Date(timeIntervalSinceReferenceDate: 0)
        }
    }
}

extension EventViewController: ImageSlideShowDelegate {
    
    func slideShowTapped(cell: ImageSlideShow) {
        //cell.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        cell.slideshow.presentFullScreenController(from: self)

    }
    
}
