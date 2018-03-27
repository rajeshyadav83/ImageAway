//
//  CollectionViewController.swift
//  ImageAway
//
//  Created by Rajesh Kumar Yadav on 3/26/18.
//  Copyright © 2018 Rajesh Kumar Yadav. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    var listing_data:[MLImage]?
    var mlDataHelper:MLDataHelper?
    var cellWidth:CGFloat = 1.0
    var cellHeight:CGFloat = 1.0
    var filters:[[String]]?
    var selectedIndex = 0
    var filtered_data:[MLImage]?
    fileprivate var filterController:FilterMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCellSize()
        if let data = listing_data{
            filters = mlDataHelper?.filters(listing_data: data)
            print("filters = \(filters)")
        }
        inititalizeFilterView()
    }
    
    private func updateCellSize(){
        if selectedIndex == 0{
            cellWidth = UIScreen.main.bounds.size.width/5
            cellHeight = cellWidth
        }
        else {
           
            cellWidth = UIScreen.main.bounds.size.width
            cellHeight = (cellWidth*2)/3
        }
    }
    
    private func inititalizeFilterView(){
        let barButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CollectionViewController.showFilterView))
        self.navigationItem.setRightBarButton(barButtonItem, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        filterController = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterMenuViewController
        filterController.filters = filters
        filterController.delegate = self
    }
    
    @objc private func showFilterView(){
        filterController.modalPresentationStyle = .popover
        filterController.preferredContentSize = CGSize(width: 160, height: 44*filters!.count)
        filterController.popoverPresentationController!.popoverBackgroundViewClass =  PopOverBackgroundView.self
        filterController.selectedIndex = selectedIndex
        
        let popover = filterController.popoverPresentationController
        // set the size you wan to display
        popover?.permittedArrowDirections = .up
        
        popover!.delegate = self
        popover!.sourceView = self.view
        
        // position of the popover where it's showed
        
        popover!.sourceRect = CGRect(x: self.view.frame.size.width-25,y: 64,width: 0,height: 0)
        
        self.present(filterController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedIndex == 0{
            return listing_data?.count ?? 0
        }
        return filtered_data?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        let imageView = cell.viewWithTag(99) as? UIImageView
        if selectedIndex == 0{
            imageView?.image = listing_data?[indexPath.row].image
        }
        else{
            imageView?.image = filtered_data?[indexPath.row].image
        }
        return cell
    }
}

extension CollectionViewController : FilterMenuDelegate{
    func filterDidSelect(_ index: Int) {
        selectedIndex = index
        if selectedIndex != 0{
            filtered_data = mlDataHelper?.sort(listing_data: listing_data!, with: filters![index-1])
        }
        updateCellSize()
        collectionView?.reloadData()
    }
}

extension CollectionViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension CollectionViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: cellWidth, height: cellHeight)
    }

}
