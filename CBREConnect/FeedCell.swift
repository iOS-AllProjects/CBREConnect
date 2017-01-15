//
//  FeedCell.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/19/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import Foundation
import UIKit

class FeedCell: UITableViewCell{
    
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var feedDescription: UILabel!
    @IBOutlet weak var feedBackground: UIView!
    @IBOutlet weak var feedBackgroundImage: UIImageView!
    @IBOutlet weak var feedTags: UICollectionView!
    @IBOutlet weak var feedFavouriteButton: UIButton!
    
    var feedTagsLabels : [String] = [] {didSet {  DispatchQueue.main.async { self.feedTags.reloadData() }}}
    var sizingCell: TagCell?
 
    var feed: Feed? {didSet { updateUI() }}
    
    func updateUI(){
        guard let feed = feed else { return }
        feedTagsLabels.removeAll()
        feedTitle.text = feed.title
        feedDescription.text = feed.description
        feedTagsLabels.append(feed.type)
        feedTagsLabels.append(feed.category)
        feedTagsLabels.append(feed.topic)
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.feedTags.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
    }
    
    @IBAction func addToFavouritesButtonTapped(_ sender: UIButton) {
        sender.isSelected =  !(sender.isSelected)
        sender.setImage(UIImage(named: "Heart_Red_Icon"), for: .selected)
        sender.setImage(UIImage(named: "Heart_Icon"), for: .normal)
    }
}
extension FeedCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedTagsLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        self.configureCell(cell: cell, forIndexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        self.configureCell(cell: self.sizingCell!, forIndexPath: indexPath)
        return self.sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    func configureCell(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        let tag = feedTagsLabels[indexPath.row]
        cell.tagTitle.text = tag.description
    }
}
