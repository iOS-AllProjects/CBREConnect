//
//  MyContentViewController.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/21/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class MyContentViewController: UIViewController {

    @IBOutlet weak var myContentTableView: UITableView!
    
    @IBOutlet weak var revealMenu: UIBarButtonItem!
    var myContent = ["Startup Grill", "Another Event"]
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
extension MyContentViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myContentTableView.dequeueReusableCell(withIdentifier: "myContentCell", for: indexPath)
        cell.textLabel?.text = myContent[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myContentTableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "feedDetail", sender: myContent[indexPath.row])
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.00
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.00
    }

}
