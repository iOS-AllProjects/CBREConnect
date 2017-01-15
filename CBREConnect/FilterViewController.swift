//
//  FilterViewController.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/20/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var filterDayButton: UIButton!
    @IBOutlet weak var filterMonthButton: UIButton!
    @IBOutlet weak var filterDatePicker: UIPickerView!
    @IBOutlet weak var filterDateLabel: UILabel!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    //uipicker
    var pickerData = [String]()
    var days = [String]()
    let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    //uicollection
    let tags = ["Tech", "Design", "Humor", "Travel", "Music", "Writing", "Social Media", "Life", "Education", "Edtech", "Education Reform", "Photography", "Startup", "Poetry", "Women In Tech", "Female Founders", "Business", "Fiction", "Love", "Food", "Sports"]
    var sizingCell: TagCell? //will calculate cell width based on text length
    var interests = [Interest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for index in 1...NSDate().getNumOfDays(){
            days.append(String(index))
        }
        pickerData = filterDayButton.isSelected ? days : months
        
        
        //collection
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.filterCollectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
        
        for name in tags {
            let tag = Interest()
            tag.name = name
            self.interests.append(tag)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearFiltersButtonTapped(_ sender: Any) {
        filterDateLabel.text = ""
    }
    
    @IBAction func applyFiltersButtonTapped(_ sender: Any) {
        
    }
    @IBAction func clearFilterDateLabelButtonTapped(_ sender: Any) {
        filterDateLabel.text = ""
        deselectAllItems()
    }
    @IBAction func dayAndMonthFilterButtonsTapped(_ sender: UIButton) {
        filterDayButton.isSelected = false
        filterMonthButton.isSelected = false
        
        //
        //clear borders by removing the sublayer
        if (filterDayButton.layer.sublayers?.count)! > 1{
            filterDayButton.layer.sublayers?.remove(at: 0)
        }
        if (filterMonthButton.layer.sublayers?.count)! > 1{
            filterMonthButton.layer.sublayers?.remove(at: 0)
        }
        
        sender.isSelected = true
        sender.addBorder(side: .Bottom, color: UIColor.white, width: 2.0)
        updateUI()
    }
    
    func updateUI(){
        self.pickerData = filterDayButton.isSelected ? days : months
        filterDatePicker.reloadAllComponents()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FilterViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.filterDateLabel.text = filterDayButton.isSelected == true ? pickerData[row] + " of \(NSDate().toString(format: "MMMM"))" : pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
        interests[indexPath.row].selected = !interests[indexPath.row].selected
        self.filterCollectionView.reloadData()
    }
    
    func configureCell(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        let tag = interests[indexPath.row]
        cell.tagTitle.text = tag.name
        cell.backgroundColor = tag.selected ? greenHexColor.hexStringToUIColor() : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
    }
    //TODO: deselect all cells
    func deselectAllItems() {
        //filterCollectionView?.selectItem(at: nil, animated: true, scrollPosition: [])
        for indexPath in filterCollectionView.indexPathsForSelectedItems ?? [] {
            filterCollectionView.deselectItem(at: indexPath, animated: false)
            filterCollectionView?.cellForItem(at: indexPath)?.backgroundColor =  UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
     }
    }
}

