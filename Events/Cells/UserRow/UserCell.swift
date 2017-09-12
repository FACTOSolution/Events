//
//  UserCell.swift
//  Events
//
//  Created by Orlando Amorim on 01/09/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import Eureka

final class UserRow: Row<UserCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<UserCell>(nibName: "UserCell")
    }
}

final class UserCell: Cell<User>, CellType {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        super.setup()
        // we do not want our cell to be selected in this case. If you use such a cell in a list then you might want to change this.
        selectionStyle = .none
        
        // configure our profile picture imageView
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        
        // define fonts for our labels
        //nameLabel.font = .systemFont(ofSize: 18)
        
        // set the textColor for our labels
        nameLabel?.textColor = EventsTheme.textColor
        
        
        // specify the desired height for our cell
        height = { return 45 }
        
        // set a light background color for our cell
        backgroundColor = .clear
        
        update()
    }
    
    override func update() {
        super.update()
        
        // we do not want to show the default UITableViewCell's textLabel
        textLabel?.text = nil
        
        // get the value from our row
        guard let user = row.value else { return }
        
        // set the image to the userImageView. You might want to do this with AlamofireImage or another similar framework in a real project
        if user.image != "" {
            let url = URL(string: user.image)
            userImageView.setShowActivityIndicator(true)
            userImageView.setIndicatorStyle(.gray)
            userImageView.sd_setImage(with: url, placeholderImage: Events.Images.profile.image, options: [.progressiveDownload, .refreshCached])
        } else {
            userImageView.image = Events.Images.profile.image
            userImageView.image = userImageView.image!.withRenderingMode(.alwaysTemplate)
            userImageView.tintColor = UIColor.white
        }
        
        // set the texts to the labels
        nameLabel.text = user.name
    }
    
}
