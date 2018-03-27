//
//  ViewController.swift
//  ImageAway
//
//  Created by Rajesh Kumar Yadav on 3/26/18.
//  Copyright © 2018 Rajesh Kumar Yadav. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var mlDataHelper:MLDataHelper!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mlDataHelper = MLDataHelper.initialize()
        tableView.rowHeight = (UIScreen.main.bounds.size.width*2)/3
        self.title = "Listings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mlDataHelper.listing_data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listingCell", for: indexPath)
        let imageView = cell.viewWithTag(99) as! UIImageView
        imageView.image = mlDataHelper.listing_data[indexPath.section][indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Awesome villa in Bali" : "Honeymoon in Bali"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, segue.identifier == "imagecollectionview"{
            if let vc = segue.destination as? CollectionViewController, let data_index = tableView.indexPath(for: cell){
                vc.mlDataHelper = mlDataHelper
                vc.listing_data = mlDataHelper.listing_data[data_index.section]
                vc.title = data_index.section == 0 ? "Awesome villa in Bali" : "Honeymoon in Bali"
            }
        }
       
    }
}

