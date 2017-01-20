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
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: Life Cycle
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeKeyboardObservers()
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

extension RegisterViewController: UIGestureRecognizerDelegate{
    @IBAction func uploadPhoto(_ sender: UITapGestureRecognizer) {
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

}

extension RegisterViewController: ManageKeyboard{
    var layoutConstraintsToAdjust: [NSLayoutConstraint] {
        return [scrollViewBottomConstraint]
    }
    
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()

            return false
        }
        return true
    }
}

