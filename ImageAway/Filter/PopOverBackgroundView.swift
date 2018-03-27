//
//  PopOverBackgroundView.swift
//  SpringTable
//
//  Created by Rajesh Yadav on 4/13/15.
//  Copyright (c) 2015 TravelMob. All rights reserved.
//

import UIKit

// Predefined arrow image width and height
let ARROW_WIDTH:CGFloat = 35.0
let ARROW_HEIGHT:CGFloat = 19.0

// Predefined content insets
let TOP_CONTENT_INSET:CGFloat = 0.0
let LEFT_CONTENT_INSET:CGFloat = 0.0
let BOTTOM_CONTENT_INSET:CGFloat = 0.0
let RIGHT_CONTENT_INSET:CGFloat = 0.0

class PopOverBackgroundView: UIPopoverBackgroundView {
    
    var arrowImageView: UIImageView?
    var popoverBackgroundImageView: UIImageView?
    var arrowLeftConstraint: NSLayoutConstraint?
    var _arrowOffset: CGFloat = 0
    var _arrowDirection:UIPopoverArrowDirection = .up
    var dynamicConstraints = [NSLayoutConstraint]()
    override var arrowOffset: CGFloat {
        
        get{
            return _arrowOffset
        }
        
        set{
            _arrowOffset = newValue
            self.updateArrowLayoutConstraint()

        }
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        
        get {
            return _arrowDirection
        }
        
        set {
            _arrowDirection = newValue
            updateLayout()
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         setup()
    }
    
    fileprivate func arrowImage() ->UIImage?{
        switch _arrowDirection {
        case UIPopoverArrowDirection.up:
            return UIImage(named: "dropdown_arrow_up")
        case UIPopoverArrowDirection.down:
            return UIImage(named: "dropdown_arrow_down")
        default:
            return UIImage(named: "dropdown_arrow_up")
        }
    }
    
    fileprivate func setup(){
        self.layer.shadowColor = UIColor.clear.cgColor
        let bkgImage = UIImage(named: "dropdown_background")?.resizableImage(withCapInsets: UIEdgeInsetsMake(4, 4, 4, 4))
        popoverBackgroundImageView = UIImageView(image: bkgImage)
        popoverBackgroundImageView!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(popoverBackgroundImageView!)
        arrowImageView = UIImageView()
        self.addSubview(arrowImageView!)
        arrowImageView!.translatesAutoresizingMaskIntoConstraints = false
        popoverBackgroundImageView!.fillSuperView(.width)
        self.bringSubview(toFront: arrowImageView!)
        
        updateLayout()
    }
    
    fileprivate func updateLayout(){
        
        self.removeConstraints(dynamicConstraints)
        dynamicConstraints.removeAll(keepingCapacity: false)
        
        let image = arrowImage()
        arrowImageView?.image = image
        let constraints = arrowImageView!.makeSize(image!.size)
        dynamicConstraints += constraints

        arrowLeftConstraint = arrowImageView!.align(NSLayoutAttribute.left, padding: self.frame.size.width-10-image!.size.width, toSuperViewWithLayoutRelation: .equal)
        if let constraint = arrowLeftConstraint{
            dynamicConstraints.append(constraint)
        }
        
        if _arrowDirection == .down {
            if let constraint = arrowImageView!.align(NSLayoutAttribute.bottom){
                dynamicConstraints.append(constraint)
            }
            if let constraint = popoverBackgroundImageView!.place(.top, toView: arrowImageView!, onCommonSuperView: self, padding: -2.0, withlayoutRelation: .equal){
                dynamicConstraints.append(constraint)
            }
            if let constraint = popoverBackgroundImageView!.align(NSLayoutAttribute.top){
                dynamicConstraints.append(constraint)
            }
        }
        else {
            if let constraint = arrowImageView!.align(NSLayoutAttribute.top){
                dynamicConstraints.append(constraint)
            }
            if let constraint = popoverBackgroundImageView!.place(.bottom, toView: arrowImageView!, onCommonSuperView: self, padding: -2.0, withlayoutRelation: .equal){
                dynamicConstraints.append(constraint)
            }
            if let constraint = popoverBackgroundImageView!.align(NSLayoutAttribute.bottom){
                dynamicConstraints.append(constraint)
            }
        }
    }
    
    fileprivate func updateArrowLayoutConstraint(){
        if arrowLeftConstraint == nil{
            return
        }
        
        arrowLeftConstraint!.constant = (self.frame.size.width - arrowImageView!.frame.size.width)/2 + _arrowOffset
        
        self.layoutIfNeeded()
        
    }
    
    override static func arrowBase() -> CGFloat{
        return ARROW_WIDTH
    }
    
    /* Describes the distance between each edge of the background view and the corresponding edge of its content view (i.e. if it were strictly a rectangle).
    */
    override static func contentViewInsets() -> UIEdgeInsets{
        return UIEdgeInsetsMake(TOP_CONTENT_INSET, LEFT_CONTENT_INSET, BOTTOM_CONTENT_INSET, RIGHT_CONTENT_INSET);
    }
    
    
     override static func arrowHeight() -> CGFloat{
        return ARROW_HEIGHT
    }
}
