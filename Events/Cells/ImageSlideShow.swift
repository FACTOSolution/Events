//
//  ImageSlideShow.swift
//  Events
//
//  Created by Orlando Amorim on 27/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import ImageSlideshow
import RealmSwift

protocol ImageSlideShowDelegate {
    func slideShowTapped(cell: ImageSlideShow)
}

class ImageSlideShow: UIView {
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    var delegate: ImageSlideShowDelegate?
    var imageImputs: [SDWebImageSource] = [SDWebImageSource]()
    var previewImputs: [ImageSource] = [ImageSource]()

    
    @objc func cellTapped(sender: AnyObject) {
        delegate?.slideShowTapped(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.backgroundColor = EventsTheme.darkerColor
        slideshow.slideshowInterval = 3.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
        slideshow.pageControl.pageIndicatorTintColor = UIColor(red: 43.0/255.0, green: 163.0/255.0, blue: 67.0/255.0, alpha: 1.0)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        slideshow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ImageSlideShow.cellTapped)))
    }
    
    func set(_ images: List<Image>) {
        //slideshow.setImageInputs(imageImputs)
        guard slideshow.images.count == 0 else { return }
        for image in images {
            if image.url != "" {
                imageImputs.append(SDWebImageSource(urlString: image.url, placeholder: Events.Images.eventPlaceholder.image)!)
            } else if let image =  image.preview {
                previewImputs.append(ImageSource(image: image))
            }
        }

        if imageImputs.count > 0 { slideshow.setImageInputs(imageImputs)
        } else if previewImputs.count > 0 { slideshow.setImageInputs(previewImputs) }
        
        

    }
}
