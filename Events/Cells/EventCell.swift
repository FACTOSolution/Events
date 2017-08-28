//
//  EventTableViewCell.swift
//  Events
//
//  Created by Orlando Amorim on 25/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import SDWebImage

class EventCell: UITableViewCell {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var infoLabel : UILabel!
    @IBOutlet var coverImageView : UIImageView!
    @IBOutlet var typeImageView : UIImageView!

    let event:Event? = nil
    
    var gradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        coverImageView.layer.cornerRadius = 4.0
        coverImageView.layer.masksToBounds = true
        
        typeImageView.layer.cornerRadius = 4.0
        typeImageView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        coverImageView.addShadowView()
    }
    
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, HH:mm"
        return dateFormatter
    }()
    
    public func set(_ event: Event) {
        typeImageView.image = Events.Images(rawValue: event.type)?.image
        titleLabel.text = event.name
        infoLabel.text = dateFormatter.string(from: event.date)
        infoLabel.text = infoLabel.text! + " • " + event.address
        if let image = event.images.first?.url {
            coverImageView.sd_setImage(with: URL(string: image)!, placeholderImage: Events.Images.eventPlaceholder.image, options: SDWebImageOptions.progressiveDownload)
        } else {
            coverImageView.image = Events.Images.eventPlaceholder.image
        }
    }
}
class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor, EventsTheme.darkerColor.cgColor]
    }
}
