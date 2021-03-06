//
//  MapCell.swift
//  Events
//
//  Created by Orlando Amorim on 29/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import SDWebImage

class MapCell: UIView {

    @IBOutlet weak var mapImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set(_ event: Event) {
        let keysFile = Bundle.main.path(forResource: "Keys", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: keysFile!)
        if event.latitude != "" && event.longitude != "" {
            if let apiKey = dictionary?["googleMapsApiKey"] as? String {
                let url = URL(string: "https://maps.googleapis.com/maps/api/staticmap?" +
                    "center=\(event.latitude),\(event.longitude)" +
                    "&zoom=17" +
                    "&scale=2" +
                    "&size=400x180" +
                    "&markers=label:%7C\(event.latitude),\(event.longitude)" +
                    "&key=\(apiKey)")
                mapImageView.setShowActivityIndicator(true)
                mapImageView.setIndicatorStyle(.gray)
                mapImageView.sd_setImage(with: url)
                
            }
        }
    }
}
