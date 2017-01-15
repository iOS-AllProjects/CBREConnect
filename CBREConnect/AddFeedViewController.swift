//
//  AddFeedViewController.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/20/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class AddFeedViewController: UIViewController {

    @IBOutlet weak var challengeButton: UIButton! {didSet {
        self.challengeButton.addBorder(side: .Bottom, color: UIColor.white, width: 2.0)}}
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var storyButton: UIButton!
    
    @IBOutlet weak var titleTextField: BorderFloatLabelTextField!
    @IBOutlet weak var descriptionTextView: BorderTextView!
    @IBOutlet weak var dateTextField: BorderFloatLabelTextField!
    @IBOutlet weak var locationTextField: BorderFloatLabelTextField!
 
    @IBOutlet weak var topicCollectionView: UICollectionView!
    @IBOutlet weak var categoryTextField: BorderFloatLabelTextField!
    
    let tags = ["Tech", "Design", "Humor", "Travel", "Music", "Writing", "Social Media", "Life", "Education", "Edtech", "Education Reform", "Photography", "Startup", "Poetry", "Women In Tech", "Female Founders", "Business", "Fiction", "Love", "Food", "Sports"]
    var sizingCell: TagCell? //will calculate cell width based on text length
    var interests = [Interest]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //collection
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.topicCollectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
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
    
    @IBAction func selectFeedTypeButtonsTapped(_ sender: UIButton) {
        challengeButton.isSelected = false
        eventButton.isSelected = false
        storyButton.isSelected = false
        
        if (challengeButton.layer.sublayers?.count)! > 1{
            challengeButton.layer.sublayers?.remove(at: 0)
        }
        if (eventButton.layer.sublayers?.count)! > 1{
            eventButton.layer.sublayers?.remove(at: 0)
        }
        if (storyButton.layer.sublayers?.count)! > 1{
            storyButton.layer.sublayers?.remove(at: 0)
        }
        
        sender.isSelected = true
        sender.addBorder(side: .Bottom, color: UIColor.white, width: 2.0)
    }
    
    @IBAction func saveFeedButtonTapped(_ sender: Any) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Keyboard Functions
    func registerToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    func keyboardWillHide(_ notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.frame.origin.y -= changeInHeight
        })
    }


}

extension AddFeedViewController: UICollectionViewDataSource, UICollectionViewDelegate{
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
        self.topicCollectionView.reloadData()
    }
    
    func configureCell(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        let tag = interests[indexPath.row]
        cell.tagTitle.text = tag.name
        cell.backgroundColor = tag.selected ? greenHexColor.hexStringToUIColor() : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
}
}

extension AddFeedViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == locationTextField || textField == categoryTextField{
            registerToKeyboardNotifications()
        }
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.backgroundColor = greenHexColor.hexStringToUIColor()
        datePickerView.setValue(UIColor.white, forKeyPath: "textColor")
        dateTextField.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == locationTextField || textField == categoryTextField{
            deregisterFromKeyboardNotifications()
        }
        return true
    }
}

extension AddFeedViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

