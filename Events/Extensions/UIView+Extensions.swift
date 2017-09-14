//
//  UIView+Extensions.swift
//  Events
//
//  Created by Orlando Amorim on 27/08/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadowView() {
        //Remove previous shadow views
        superview?.viewWithTag(119900)?.removeFromSuperview()
        
        //Create new shadow view with frame
        let shadowView = UIView(frame: frame)
        shadowView.tag = 119900
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        shadowView.layer.masksToBounds = false
        
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true
        
        superview?.insertSubview(shadowView, belowSubview: self)
    }
    
    var recursiveSubviews: [UIView] {
        var subviews = self.subviews.flatMap({$0})
        subviews.forEach { subviews.append(contentsOf: $0.recursiveSubviews) }
        return subviews
    }
}

extension UIAlertController {
    
    private struct AssociatedKeys {
        static var blurStyleKey = "UIAlertController.blurStyleKey"
    }
    
    public var blurStyle: UIBlurEffectStyle {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.blurStyleKey) as? UIBlurEffectStyle ?? .extraLight
        } set (style) {
            objc_setAssociatedObject(self, &AssociatedKeys.blurStyleKey, style, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    public var cancelButtonColor: UIColor? {
        return blurStyle == .dark ? UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0) : nil
    }
    
    private var visualEffectView: UIVisualEffectView? {
        if let presentationController = presentationController, presentationController.responds(to: Selector(("popoverView"))), let view = presentationController.value(forKey: "popoverView") as? UIView // We're on an iPad and visual effect view is in a different place.
        {
            return view.recursiveSubviews.flatMap({$0 as? UIVisualEffectView}).first
        }
        
        return view.recursiveSubviews.flatMap({$0 as? UIVisualEffectView}).first
    }
    
    private var cancelActionView: UIView? {
        return view.recursiveSubviews.flatMap({$0 as? UILabel}).first(where: {$0.text == "Cancel"})?.superview?.superview
    }
    
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, blurStyle: UIBlurEffectStyle) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        self.blurStyle = blurStyle
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        visualEffectView?.effect = UIBlurEffect(style: blurStyle)
        cancelActionView?.backgroundColor = cancelButtonColor
    }
}
