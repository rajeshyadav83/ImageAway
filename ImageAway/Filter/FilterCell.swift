//
//  FilterCell.swift
//  ImageAway
//
//  Created by Anshu Kumari on 26/3/18.
//  Copyright © 2018 Rajesh Kumar Yadav. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    
    @IBOutlet weak var filterTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    fileprivate func updateColors(){
        filterTitle.textColor = UIColor.blue
        filterTitle.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    func update(_ filterName:String){
        filterTitle.text = filterName
    }
}
