//
//  MLImage.swift
//  ImageAway
//
//  Created by Rajesh Kumar Yadav on 3/26/18.
//  Copyright © 2018 Rajesh Kumar Yadav. All rights reserved.
//

import Foundation
import UIKit

class MLImage {
    var image:UIImage
    var tag: String?
    var probability:Double = 0
    init(image:UIImage) {
        self.image = image
    }
    
    func set(tag:String?, probability:Double=0) {
        self.tag = tag
        self.probability = probability
    }
}
