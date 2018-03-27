//
//  UIViewAutoLayoutExtension.swift
//  main
//
//  Created by TravelMob on 4/7/15.
//  Copyright (c) 2015 TravelMob. All rights reserved.
//

import UIKit

public extension UIView{
    
    // MARK: View Frame Methods
    @discardableResult public func makeSize(_ size:CGFloat, forAttribute:NSLayoutAttribute, withLayoutRelation layoutRelation: NSLayoutRelation = .equal) -> NSLayoutConstraint{
        let constraint = NSLayoutConstraint.sizeConstraintWith(attribute: forAttribute, forView: self, withLayoutRelation: layoutRelation, size: size)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func makeSize(_ size:CGSize, withLayoutRelation layoutRelation: NSLayoutRelation = .equal) -> [NSLayoutConstraint]{
        let constraints = NSLayoutConstraint.sizeConstraint(forView: self, withLayoutRelation: layoutRelation, size: size)
        self.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult public func makeWidthAndHeightRatio(_ multiplier:CGFloat = 1.0) -> NSLayoutConstraint{
        let constraint = NSLayoutConstraint.widthAndHeightConstraint(forView: self,multiplier:multiplier)
        self.superview?.addConstraint(constraint)
        return constraint
    }
    
    // MARK: Super View Alignment Methods
    
    @discardableResult public func fillSuperView(_ attribute:NSLayoutAttribute, withPadding padding: CGFloat = 0) -> [NSLayoutConstraint]?{
        let constraints = NSLayoutConstraint.fillSuperViewConstraintsWith(attribute: attribute, forView: self, withPadding: padding)
        if constraints != nil{
            self.superview!.addConstraints(constraints!)
        }
        return constraints
    }
    
    @discardableResult public func fillSuperView(_ padding: CGFloat = 0) -> [NSLayoutConstraint]?{
        let constraints = NSLayoutConstraint.fillSuperViewConstraints(forView: self, withPadding: padding)
        if constraints != nil{
            self.superview!.addConstraints(constraints!)
        }
        return constraints
    }
    
    @discardableResult public func placeAtCenter() -> [NSLayoutConstraint]?{
        let constraints = NSLayoutConstraint.centerConstraints(forView: self)
        if constraints != nil{
            self.superview!.addConstraints(constraints!)
        }
        return constraints
    }
    
    @discardableResult public func align(_ attribute:NSLayoutAttribute, padding:CGFloat = 0,toSuperViewWithLayoutRelation layoutRelation: NSLayoutRelation = .equal) -> NSLayoutConstraint?{
        var constraint: NSLayoutConstraint?
        if let superView = self.superview{
           constraint = NSLayoutConstraint.alignConstraint(forView: self, withAttribute: attribute, toView: superView, withPadding: padding,andLayoutRelation:layoutRelation)
            superView.addConstraint(constraint!)
        }
        return constraint
    }
    
     // MARK: View -> View Alignment Constraints
    
    @discardableResult public func align(_ attribute:NSLayoutAttribute, toView:UIView,onCommonSuperView:UIView, padding:CGFloat = 0, withlayoutRelation relation: NSLayoutRelation = .equal) -> NSLayoutConstraint{
          let  constraint = NSLayoutConstraint.alignConstraint(forView: self, withAttribute: attribute, toView: toView, withPadding: padding,andLayoutRelation:relation)
            onCommonSuperView.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func place(_ attribute:NSLayoutAttribute,toView:UIView,onCommonSuperView:UIView, padding:CGFloat = 0, withlayoutRelation relation: NSLayoutRelation = .equal) -> NSLayoutConstraint?{
        
        var constraint: NSLayoutConstraint?
        switch(attribute){
        case .top:
            constraint = NSLayoutConstraint.placeTopConstraint(forView: self, toView: toView, withPadding: padding, andLayoutRelation: relation)
        case .left:
            constraint = NSLayoutConstraint.placeLeftConstraint(forView: self, toView: toView, withPadding: padding, andLayoutRelation: relation)
        case .bottom:
            constraint = NSLayoutConstraint.placeBottomConstraint(forView: self, toView: toView, withPadding: padding, andLayoutRelation: relation)
        case .right:
            constraint = NSLayoutConstraint.placeRightConstraint(forView: self, toView: toView, withPadding: padding, andLayoutRelation: relation)
        default:
            break

        }
        if constraint != nil{
            onCommonSuperView.addConstraint(constraint!)
        }
        
        return constraint
    }
    
    @discardableResult public func makeSize(_ attribute:NSLayoutAttribute, times:CGFloat, toView view:UIView?=nil,onCommonSuperView:UIView?=nil,padding:CGFloat = 0) ->NSLayoutConstraint{
        let constraint = NSLayoutConstraint.sizeConstraint(forView: self, withAttribute: attribute, toView: (view == nil ? self.superview! : view!), padding: padding, multiplier: times)
        if onCommonSuperView != nil {
            onCommonSuperView!.addConstraint(constraint)
        }
        else {
            self.superview?.addConstraint(constraint)
        }
        return constraint
    }
    
    // NOTE: common super view calls this with its subviews
    @discardableResult public func makeEqual(_ attribute:NSLayoutAttribute,forViews:[UIView]) -> [NSLayoutConstraint]?{
        let constraints = NSLayoutConstraint.equalSizeConstraints(forViews: forViews, withAttribute: attribute)
        if constraints != nil{
            self.addConstraints(constraints!)
        }
        return constraints
    }
    
    public func activateConstraints(){
        NSLayoutConstraint.activate(self.constraints)
    }
    
    public func deactivateConstraints(){
        NSLayoutConstraint.deactivate(self.constraints)
    }
}
