//
//  ContactsViewController.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/21/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var revealMenu: UIBarButtonItem!
    @IBOutlet weak var contactsTableView: UITableView!
    
    var myContacts = ["Etjen Ymeraj", "Alexa P"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //activate side menu
        revealMenu.target = self.revealViewController()
        revealMenu.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//TODO: Fix Spacing
extension ContactsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.contactsTableView.dequeueReusableCell(withIdentifier: "myContactCell", for: indexPath)
        cell.textLabel?.text = myContacts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.contactsTableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "feedDetail", sender: myContent[indexPath.row])
        
    }
}
