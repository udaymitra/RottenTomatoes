//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by Soumya on 9/17/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    let BOX_OFFICE_URL = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
    let TOP_DVD_URL = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"

    @IBOutlet weak var moviesTableView: UITableView!
    var moviesDictionaryArray:[NSDictionary]?
    var uiRefreshControl : UIRefreshControl!    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorViewLabel: UILabel!
    @IBOutlet weak var movieDvdSelectionTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorView.hidden = true
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        movieDvdSelectionTabBar.delegate = self
        
        // add refresh control
        uiRefreshControl = UIRefreshControl()
        uiRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        moviesTableView.addSubview(uiRefreshControl)
        
        movieDvdSelectionTabBar.selectedItem = movieDvdSelectionTabBar.items![0]
        loadData()
    }

    func refresh(sender:AnyObject)
    {
        self.uiRefreshControl.endRefreshing()

        // Code to refresh table view
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDictionaryArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movieCell = moviesTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MoviesTableViewCell
        let thisMovieDict = self.moviesDictionaryArray![indexPath.row]
        movieCell.movieLabelName.text = thisMovieDict["title"] as? String
        movieCell.synopsisLabel.text = thisMovieDict["synopsis"] as? String
        if let posters = thisMovieDict["posters"] as? NSDictionary {
            let posterImageUrl = posters["thumbnail"] as? String
            movieCell.thumbnailImageView.setImageWithURL(NSURL(string: posterImageUrl!)!)
        }
        
        return movieCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        moviesTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        loadData()
    }
    
    func loadData() {
        var url = BOX_OFFICE_URL
        self.navigationController?.navigationBar.topItem?.title = "Movies"
        if (movieDvdSelectionTabBar.selectedItem!.title == "DVDs") {
            url = TOP_DVD_URL
            self.navigationController?.navigationBar.topItem?.title = "DVDs"
        }
        let request = NSURLRequest(URL: NSURL(string: url)!)
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.labelText = "Loading awesome movies for you"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if let d = data {
                let object = try! NSJSONSerialization.JSONObjectWithData(d, options: []) as! NSDictionary
                if let allData = object["movies"] {
                    self.moviesDictionaryArray = allData as? [NSDictionary]
                    
                    // reload view with new data
                    self.moviesTableView.reloadData()
                    
                    // stop spinning activity
                    spinningActivity.hide(true)
                    
                    self.moviesTableView.hidden = false
                    self.errorView.hidden = true
                }
            } else {
                if let e = error {
                    NSLog("Error: \(e)")
                    
                    // stop spinning activity
                    spinningActivity.hide(true)
                    
                    self.moviesTableView.hidden = true
                    self.errorView.frame.origin.y = self.errorView.frame.height / 2
                    self.errorView.hidden = false
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = moviesTableView.indexPathForCell(cell)
        let movie = moviesDictionaryArray![indexPath!.row]
        let movieDetailViewController = segue.destinationViewController as! MovieDetaiViewController
        movieDetailViewController.movie = movie
    }
    
}
