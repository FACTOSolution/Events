//
//  EventEureka.swift
//  Events
//
//  Created by Orlando Amorim on 27/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit

class EventEureka: UIView {

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        typeImageView.backgroundColor = EventsTheme.darkerColor
        typeImageView.contentMode = .scaleAspectFit
        typeImageView.layer.cornerRadius = typeImageView.frame.size.width / 2
        typeImageView.clipsToBounds = true
        typeImageView.layer.borderWidth = 3.0
        typeImageView.layer.borderColor = EventsTheme.linkColor.cgColor
        
        titleLabel.textColor = UIColor.white
    }
    
    public func set(_ event: Event) {
        typeImageView.image = Events.Images(rawValue: event.type)?.image
        titleLabel.text = event.name
    }
}
