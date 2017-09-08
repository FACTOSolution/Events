//
//  EventEureka.swift
//  Events
//
//  Created by Orlando Amorim on 27/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit

class EventUserView: UIView {
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        typeView.backgroundColor = EventsTheme.darkerColor
        typeView.contentMode = .scaleAspectFit
        typeView.layer.cornerRadius = typeView.frame.size.width / 2
        typeView.clipsToBounds = true
        typeView.layer.borderWidth = 2.0
        typeView.layer.borderColor = EventsTheme.linkColor.cgColor
        lineView.backgroundColor = EventsTheme.linkColor
        titleLabel.textColor = UIColor.white
    }
    
    public func set(_ event: Event) {
        typeImageView.image = Events.Images(rawValue: event.type)?.image
        titleLabel.text = event.name
    }
    
    @nonobjc
    public func set(_ user: User) {
        typeImageView.sd_setImage(with: URL(string: user.image), placeholderImage: Events.Images.userPlaceholder.image, options: [.progressiveDownload, .refreshCached])
        titleLabel.text = user.name
        
    }
}

