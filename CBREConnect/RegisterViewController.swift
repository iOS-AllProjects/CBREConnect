//
//  RegisterViewController.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/17/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //Mark: Outlets

    @IBOutlet weak var profilePicture: RoundedImageView!
    @IBOutlet weak var fullNameTextField: BorderFloatLabelTextField!
    @IBOutlet weak var websiteTextField: BorderFloatLabelTextField!
    @IBOutlet weak var aboutMeTextView: BorderTextView!
    
    // MARK: Life Cycle
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        callActionSheet()
    }
    
    func callActionSheet(){
        let actionSheet = UIAlertController(title: "Add a Photo", message: "Upload from the following", preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default){ action in
            self.fromSource(source: .photoLibrary)
        }
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default){ action in
            self.fromSource(source: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(cancelAction)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: Keyboard Functions
    func registerToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePicture.image = image.scaleUIImageToSize(size: CGSize(width: 60, height: 60))
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

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        enableTextView()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        disableTexView()
        return true
    }
}

extension RegisterViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            deregisterFromKeyboardNotifications()
            enableTextFields()
            return false
        }
        return true
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        disableTextFields()
        registerToKeyboardNotifications()
        return true
    }
}

private extension RegisterViewController {
    func enableTextFields(){
        fullNameTextField.isEnabled = true
        websiteTextField.isEnabled = true
    }
    
    func disableTextFields(){
        fullNameTextField.isEnabled = false
        websiteTextField.isEnabled = false
    }
    
    func enableTextView(){
        aboutMeTextView.isEditable = true
    }
    
    func disableTexView(){
        aboutMeTextView.isEditable = false
    }
}

