//
//  FeedViewController.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/17/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var revealMenu: UIBarButtonItem!
    @IBOutlet weak var feedTableView: UITableView!

    @IBOutlet weak var allFeedsButton: UIButton! {didSet {
        self.allFeedsButton.addBorder(side: .Bottom, color: UIColor.white, width: 2.0)}}
    @IBOutlet weak var challengesFeedsButton: UIButton!
    @IBOutlet weak var eventsFeedsButton: UIButton!
    @IBOutlet weak var storiesFeedsButton: UIButton!
    let searchController = UISearchController(searchResultsController: nil)

    
    var feeds = [Feed(title: "StartUp Grill", description: "Yes it is the cold time of the year again but we are going to warm it up with some hot BBQ, punch and burning minds!", type: "Event", category: "Networking", topic: "Trends", date: NSDate(), location: "Bismarckstr. 12, CHIC 10625 Berlin", user: "Etjen Ymeraj", imagePath: "BBQ"), Feed(title: "The 2020 Survey", description: "Meet the new influencers in the property market that are revolutionising the whole industry!", type: "Challenge", category: "Retail", topic: "Innovation", date: NSDate(), location: "Bismarckstr. 12, CHIC 10625 Berlin", user: "Fabian Sonnenburg", imagePath: "BBQ"), Feed(title: "3YOUR MIND", description: "How three people managed to set a standard in the 3D printing industry, here is their success story", type: "Story", category: "StartUp", topic: "Entrepreneurship", date: NSDate(), location: "Bismarckstr. 12, CHIC 10625 Berlin", user: "Alexa", imagePath: "BBQ")] {didSet {  DispatchQueue.main.async { self.feedTableView.reloadData() }}}
    
    var filteredFeeds = [Feed]() {didSet {  DispatchQueue.main.async { self.feedTableView.reloadData() }}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    
    @IBAction func searchFeed(_ sender: Any) {
        configureSearchController()
    }
    
    
    @IBAction func addToFavouritesButtonTapped(_ sender: Any) {
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
    }
    
    @IBAction func displayFeeds(_ sender: UIButton) {
        //return buttons to default state
        allFeedsButton.isSelected = false
        challengesFeedsButton.isSelected = false
        eventsFeedsButton.isSelected = false
        storiesFeedsButton.isSelected = false
        
        //clear borders by removing the sublayer
        if (allFeedsButton.layer.sublayers?.count)! > 1{
            allFeedsButton.layer.sublayers?.remove(at: 0)
        }
        if (challengesFeedsButton.layer.sublayers?.count)! > 1{
            challengesFeedsButton.layer.sublayers?.remove(at: 0)
        }
        if (eventsFeedsButton.layer.sublayers?.count)! > 1{
            eventsFeedsButton.layer.sublayers?.remove(at: 0)
        }
        if (storiesFeedsButton.layer.sublayers?.count)! > 1{
            storiesFeedsButton.layer.sublayers?.remove(at: 0)
        }
        
        //select the tapped button
        sender.isSelected = true
        sender.addBorder(side: .Bottom, color: UIColor.white, width: 2.0)
        updateUI()
    }
    
    func updateUI(){
        filteredFeeds.removeAll()
         if challengesFeedsButton.isSelected == true {
            filteredFeeds = feeds.filter { feed in
                return (feed.type.lowercased().range(of: "challenge") != nil)
            }
            feedTableView.reloadData()
        } else if eventsFeedsButton.isSelected == true {
            filteredFeeds = feeds.filter { feed in
                return (feed.type.lowercased().range(of: "event") != nil)
            }
            feedTableView.reloadData()
        } else if storiesFeedsButton.isSelected == true {
            filteredFeeds = feeds.filter { feed in
                return (feed.type.lowercased().range(of: "story") != nil)
            }
            feedTableView.reloadData()
        }else {
            filteredFeeds = feeds
            feedTableView.reloadData()
        }
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredFeeds = feeds.filter { feed in
            return (feed.title.lowercased().range(of: searchText.lowercased()) != nil)
        }
        feedTableView.reloadData()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier, let selectedFeed = sender as? Feed  {
            if identifier == "feedDetail" {
                let feedDetail = segue.destination as! FeedDetailViewController
                feedDetail.feed = selectedFeed
            }
        }
    }
}

extension FeedViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func configureSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self //allow class to be informed as changes happen in search bar
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundColor = UIColor.clear
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.barTintColor = greenHexColor.hexStringToUIColor()
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.setShowsCancelButton(true, animated: true)
        searchController.searchBar.tintColor = greenHexColor.hexStringToUIColor()
        searchController.loadViewIfNeeded()
        self.present(searchController, animated: true, completion: nil)
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive && searchController.searchBar.text != "") || allFeedsButton.isSelected == false{
            return filteredFeeds.count
        }
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.feedTableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        cell.feed = ((searchController.isActive && searchController.searchBar.text != "") || allFeedsButton.isSelected == false) ? filteredFeeds[indexPath.row] : feeds[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.feedTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "feedDetail", sender: ((searchController.isActive && searchController.searchBar.text != "") || allFeedsButton.isSelected == false) ? filteredFeeds[indexPath.row] : feeds[indexPath.row])

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230.00
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230.00
    }
    
}
