//
//  FilterMenuViewController.swift
//  ImageAway
//
//  Created by Anshu Kumari on 26/3/18.
//  Copyright © 2018 Rajesh Kumar Yadav. All rights reserved.
//

import Foundation
import UIKit

protocol FilterMenuDelegate:class{
    func filterDidSelect(_ index:Int)
}

class FilterMenuViewController: UITableViewController {
    var selectedIndex:Int!
    var filters:[[String]]?
    weak var delegate:FilterMenuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filters?.insert(["All"], at: 0)
        if selectedIndex == nil { selectedIndex = 0 }
        self.view.backgroundColor = UIColor.clear
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 30
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return filters?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterViewCell", for: indexPath) as! FilterCell
        if let filter_name = filters?[indexPath.row].first{
            cell.update(filter_name)
        }
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
        delegate?.filterDidSelect(selectedIndex)
        self.dismiss(animated: true, completion: nil)
    }
}
