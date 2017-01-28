//
//  ProfileViewController.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/21/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileWebsiteLabel: UILabel!
    @IBOutlet weak var profileAboutTextView: UITextView!
    @IBOutlet weak var profileFollowButton: UIButton!
    @IBOutlet weak var editProfile: UIBarButtonItem!
    
    @IBOutlet weak var editInterests: UIButton!
    @IBOutlet weak var editDescription: UIButton!
    @IBOutlet weak var profileTagsCollectionView: UICollectionView!
    var user: Bool = false
    var users = [User(name: "Honeypot", email: "hello@honeypot.io", website: "www.honeypot.io", photo: "Sample_StartUp_Logo", description: "Honeypot is a developer-focused job platform, on a mission to get every developer a great job. We believe developers should have all the information they need to choose a job they love: whether that’s based on a cutting-edge tech stack, an inspiring team or just good old-fashioned salary", interests: ["Tech", "Design", "Humor", "Travel", "Music", "Writing", "Social Media", "Life", "Education", "Edtech"])]
    
    var tags = ["Education Reform", "Photography", "Startup", "Poetry", "Women In Tech", "Female Founders", "Business", "Fiction", "Love", "Food", "Sports"]
    var sizingCell: TagCell? //will calculate cell width based on text length
    var interests = [Interest]()
    
    @IBOutlet weak var revealMenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        //activate side menu
        revealMenu.target = self.revealViewController()
        revealMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //get rid of navigation bar bottom border
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        if user == false{
        tags = users[0].interests
        profileImageView.image = UIImage(named: users[0].photo)
        profileNameLabel.text = users[0].name
        profileWebsiteLabel.text = users[0].webiste
        profileAboutTextView.text = users[0].description
        } else{
            self.navigationItem.rightBarButtonItem = nil
            editInterests.isEnabled = false
            editInterests.isHidden = true
            editDescription.isHidden = true
            editDescription.isEnabled = false
            profileFollowButton.isEnabled = true
            profileFollowButton.isHidden = false
        }
        //Load Collection View
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.profileTagsCollectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
        
        for name in tags {
            let tag = Interest()
            tag.name = name
            self.interests.append(tag)
        }

    }
    @IBAction func editBarButtonTapped(_ sender: Any) {
        callActionSheet()
    }
    
    @IBAction func editAboutTextView(_ sender: Any) {
        profileAboutTextView.isEditable = !profileAboutTextView.isEditable
    }
    @IBAction func editTags(_ sender: Any) {
        profileTagsCollectionView.isUserInteractionEnabled = !profileTagsCollectionView.isUserInteractionEnabled
    }
    @IBAction func followButtonTapped(_ sender: Any) {
        profileFollowButton.isSelected = !profileFollowButton.isSelected
        profileFollowButton.setTitle("Follow", for: .normal)
        profileFollowButton.setTitle("Unfollow", for: .selected)
    }
    
    func callActionSheet(){
        let actionSheet = UIAlertController(title: "Edit Profile", message: "Choose from the following", preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default){ action in
            self.fromSource(source: .photoLibrary)
        }
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default){ action in
            self.fromSource(source: .camera)
        }
        let editNameAction = UIAlertAction(title: "Edit Name", style: .default) { action in
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "Some default text"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = (alert?.textFields![0])! as UITextField
                self.profileNameLabel.text = textField.text
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        let editWebsiteAction = UIAlertAction(title: "Edit Website", style: .default) { action in
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "Some default text"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = (alert?.textFields![0])! as UITextField
                self.profileWebsiteLabel.text = textField.text
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(editNameAction)
        actionSheet.addAction(editWebsiteAction)
        actionSheet.addAction(cancelAction)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        self.present(actionSheet, animated: true, completion: nil)
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

// MARK: UImagePicker Delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = image.scaleUIImageToSize(size: CGSize(width: 80, height: 80))
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func fromSource(source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let picker = UIImagePickerController()
            picker.sourceType = source
            picker.delegate = self
            picker.allowsEditing = false
            present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Not Available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { alertAction in
                alert.dismiss(animated: true, completion: nil)
            })
            present(alert, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate{
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
        self.profileTagsCollectionView.reloadData()
    }
    
    func configureCell(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        let tag = interests[indexPath.row]
        cell.tagTitle.text = tag.name
        cell.backgroundColor = tag.selected ? greenHexColor.hexStringToUIColor() : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
    }
}

extension ProfileViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

