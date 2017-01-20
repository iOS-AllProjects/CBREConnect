//
//  FeedDetailViewController.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/19/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController {

    @IBOutlet weak var FeedDetailImageView: UIImageView!
    @IBOutlet weak var FeedDetailTextView: UITextView!
    @IBOutlet weak var FeedDetailDateLabel: UILabel!
    @IBOutlet weak var FeedDetailLocationLabel: UILabel!
    @IBOutlet weak var createdByImageView: RoundedImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var FeedDetailTitle: UILabel!
    
    var feed: Feed?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup UI
    func setupUI(){
        if let feed = feed {
            title = feed.type
            FeedDetailTitle.text = feed.title
            FeedDetailDateLabel.text = feed.date.toString(format: "dd.MM.yyyy")
            FeedDetailLocationLabel.text = feed.location
            userLabel.text = feed.user
            FeedDetailTextView.text = feed.description
            FeedDetailImageView.image = UIImage(named:"\(feed.imagePath)")
            createdByImageView.image = UIImage(named: "\(feed.imagePath)")
        }
    }


    @IBAction func viewProfileButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
       self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func addToFavouritesButtonTapped(_ sender: Any) {
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
