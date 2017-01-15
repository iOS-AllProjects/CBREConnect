//
//  LoginViewController.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/16/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var signInButton: UIButton! {didSet {
        self.signInButton.addBorder(side: .Bottom, color: UIColor.white, width: 2.0)}}
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var personButton: RoundedButton!
    @IBOutlet weak var startUpButton: RoundedButton!
    @IBOutlet weak var corporateButton: RoundedButton!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var startUpLabel: UILabel!
    @IBOutlet weak var corporateLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var emailTextField: BorderFloatLabelTextField!
    @IBOutlet weak var passwordTextField: BorderFloatLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //update the UI based on the use selection
    func updateUI(){
        if signInButton.isSelected == true{
            personButton.isEnabled = false
            startUpButton.isEnabled = false
            corporateButton.isEnabled = false
            personLabel.fadeOut()
            startUpLabel.fadeOut()
            corporateLabel.fadeOut()
            personButton.fadeOut()
            startUpButton.fadeOut()
            corporateButton.fadeOut()
            proceedButton.setTitle("LOGIN", for: .normal)
            forgotPasswordButton.isEnabled = true
            forgotPasswordButton.fadeIn()
        } else{
            personButton.isEnabled = true
            startUpButton.isEnabled = true
            corporateButton.isEnabled = true
            personLabel.fadeIn()
            startUpLabel.fadeIn()
            corporateLabel.fadeIn()
            personButton.fadeIn()
            startUpButton.fadeIn()
            corporateButton.fadeIn()
            proceedButton.setTitle("REGISTER", for: .normal)
            forgotPasswordButton.isEnabled = false
            forgotPasswordButton.fadeOut()
        }
    }

    //MARK: - Actions
    
    @IBAction func authenticationButtonsTapped(_ sender: UIButton) {
        //return buttons to default state
        signInButton.isSelected = false
        signUpButton.isSelected = false
        
        //clear borders by removing the sublayer
        if (signInButton.layer.sublayers?.count)! > 1{
        signInButton.layer.sublayers?.remove(at: 0)
        }
        if (signUpButton.layer.sublayers?.count)! > 1{
        signUpButton.layer.sublayers?.remove(at: 0)
        }
        
        //select the tapped button
        sender.isSelected = true
        sender.addBorder(side: .Bottom, color: UIColor.white, width: 2.0)
        updateUI()
    }
    
    @IBAction func registrationButtonsTapped(_ sender: UIButton) {
        //return buttons to default state
        personButton.isSelected = false
        startUpButton.isSelected = false
        corporateButton.isSelected = false
        
        //select the tapped button
        sender.isSelected = true
    }
    
    @IBAction func proceedButtonTapped(_ sender: UIButton) {
        //decide which screen to display next
        if sender.titleLabel?.text == "LOGIN"{
            performSegue(withIdentifier: "login", sender: sender)
        }else{
            performSegue(withIdentifier: "register", sender: sender)
            }
    }
    


    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "register" {
//            //normally you would pass your data here
//            _ = segue.destination as! RegisterViewController
//        }
//        else if segue.identifier == "login" {
//            //normally you would pass your data here
//            _ = segue.destination as! FeedViewController    
//        }
//    }
}
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
