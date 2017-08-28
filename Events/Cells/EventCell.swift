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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, HH:mm"
        return dateFormatter
    }()
    
    public func set(_ event: Event) {
        titleLabel.text = event.name
        infoLabel.text = dateFormatter.string(from: event.date)
        infoLabel.text = infoLabel.text! + " • " + event.address
        
        let url = URL(string: "https://lh5.googleusercontent.com/p-1GrbrKuqEKFWY_edQ5lfiByz_Y4T-EwF8sKgdObpUKoAqJW1X59W3O86uf9en_c-pRPoiVWc3PGgg=w2560-h1298")!
        coverImageView.sd_setImage(with: url, placeholderImage: Events.Images.eventPlaceholder.image, options: SDWebImageOptions.progressiveDownload)
        
    }
}
class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor, UIColor(red: 0.161, green: 0.208, blue: 0.235, alpha: 1).cgColor]
    }
}
