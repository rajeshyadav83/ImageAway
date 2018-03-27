//
//  LayoutConstraintExtension.swift
//  main
//
//  Created by TravelMob on 4/7/15.
//  Copyright (c) 2015 TravelMob. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint{
    
    // MARK: View Frame Constraints
    
   public  class func sizeConstraintWith(attribute: NSLayoutAttribute,forView: UIView, withLayoutRelation layoutRelation:NSLayoutRelation,size:CGFloat) -> NSLayoutConstraint{
        return self.init(item: forView, attribute: attribute, relatedBy:layoutRelation, toItem: nil, attribute: attribute, multiplier: 1.0, constant: size)
    }
    
    public class func sizeConstraint(forView: UIView, withLayoutRelation layoutRelation:NSLayoutRelation,size:CGSize) -> [NSLayoutConstraint]{
        let widthContraint = self.sizeConstraintWith( attribute: .width,forView: forView, withLayoutRelation: layoutRelation, size: size.width)
        let heightContraint = self.sizeConstraintWith( attribute: .height,forView: forView, withLayoutRelation: layoutRelation, size: size.height)
        var constraints = [NSLayoutConstraint]()
        constraints.append(widthContraint)
        constraints.append(heightContraint)
        return constraints
    }
    
    public class func widthAndHeightConstraint(forView: UIView, multiplier:CGFloat = 1.0) -> NSLayoutConstraint{
        return self.init(item: forView, attribute: .height, relatedBy: .equal, toItem: forView , attribute: .width, multiplier: (1/multiplier), constant: 0)
    }
    
    
    // MARK: Super View Alignment Methods
    
    public class func centerConstraints(forView: UIView) -> [NSLayoutConstraint]?{
        
        if let superView = forView.superview{
            let constraintY = self.alignConstraint(forView: forView, withAttribute: .centerY, toView: superView, withPadding: 0,andLayoutRelation:.equal)
            let constraintX = self.alignConstraint(forView: forView, withAttribute: .centerX, toView: superView, withPadding: 0,andLayoutRelation:.equal)
            var constraints = [NSLayoutConstraint]()
            constraints.append(constraintX)
            constraints.append(constraintY)

            return constraints
        }
        
        return nil
    }
    
    public class func fillSuperViewConstraintsWith(attribute: NSLayoutAttribute,forView: UIView,  withPadding padding: CGFloat) ->[NSLayoutConstraint]?{
        
        switch(attribute){
        case .height:
            return self.constraints(withVisualFormat: "V:|-padding-[forView]-padding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["padding":padding], views: ["forView":forView])
        case .width:
            return self.constraints(withVisualFormat: "|-padding-[forView]-padding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["padding":padding], views: ["forView":forView])
        default:
            return nil
            
            
        }
    }
    
    public class func fillSuperViewConstraints(forView: UIView , withPadding padding:CGFloat) -> [NSLayoutConstraint]?{
        
        let constraintWidth = self.fillSuperViewConstraintsWith(attribute: .width,forView: forView, withPadding: padding)
        let constraintHeight = self.fillSuperViewConstraintsWith( attribute: .height,forView: forView, withPadding: padding)
        var constraints = [NSLayoutConstraint]()
        if(constraintWidth != nil)
        {
            constraints+=constraintWidth!
        }
        if(constraintHeight != nil)
        {
            constraints+=constraintHeight!
        }
        
        return constraints.count>0 ? constraints:nil
    }
    
    
    // MARK: View -> View Alignment Constraints
    
    public class func alignConstraint(forView: UIView, withAttribute: NSLayoutAttribute, toView: UIView ,withPadding padding:CGFloat, andLayoutRelation:NSLayoutRelation) -> NSLayoutConstraint{
        return self.init(item: forView, attribute: withAttribute, relatedBy: andLayoutRelation, toItem: toView, attribute: withAttribute, multiplier: 1.0, constant: padding)
        
    }
    
    public class func placeTopConstraint(forView: UIView, toView: UIView ,withPadding padding:CGFloat, andLayoutRelation:NSLayoutRelation) -> NSLayoutConstraint{
        return self.init(item: forView, attribute:.bottom, relatedBy: andLayoutRelation, toItem: toView, attribute: .top, multiplier: 1.0, constant: -padding)
    }
    
    public class func placeLeftConstraint(forView: UIView, toView: UIView ,withPadding padding:CGFloat, andLayoutRelation:NSLayoutRelation) -> NSLayoutConstraint{
        return self.init(item: forView, attribute:.right, relatedBy: andLayoutRelation, toItem: toView, attribute: .left, multiplier: 1.0, constant: -padding)
    }
    
    public class func placeBottomConstraint(forView: UIView, toView: UIView ,withPadding padding:CGFloat, andLayoutRelation:NSLayoutRelation) -> NSLayoutConstraint{
        return self.init(item: forView, attribute:.top, relatedBy: andLayoutRelation, toItem: toView, attribute: .bottom, multiplier: 1.0, constant: padding)
    }
    
    public class func placeRightConstraint(forView: UIView, toView: UIView ,withPadding padding:CGFloat, andLayoutRelation:NSLayoutRelation) -> NSLayoutConstraint{
        return self.init(item: forView, attribute:.left, relatedBy: andLayoutRelation, toItem: toView, attribute: .right, multiplier: 1.0, constant: padding)
    }
    
    public class func sizeConstraint(forView: UIView,withAttribute: NSLayoutAttribute, toView:UIView,padding:CGFloat, multiplier:CGFloat) -> NSLayoutConstraint{
        return self.init(item: forView, attribute: withAttribute, relatedBy:.equal, toItem: toView, attribute: withAttribute, multiplier: multiplier, constant: padding)
    }
    
    public class func equalSizeConstraints(forViews: [UIView],withAttribute: NSLayoutAttribute) ->[NSLayoutConstraint]?{
        
        var constraints = [NSLayoutConstraint]()
        var prevView: UIView!
        for view in forViews{
            if prevView != nil{
              let newConstraints = self.init(item: prevView, attribute:withAttribute, relatedBy:.equal, toItem: view, attribute:withAttribute, multiplier: 1.0, constant:0)
                constraints.append(newConstraints)
            }
            prevView = view
        }
        
        return constraints.count>0 ? constraints:nil
    }
}
