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

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UISearchBarDelegate {
    
    let BOX_OFFICE_URL = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
    let TOP_DVD_URL = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"

    @IBOutlet weak var moviesTableView: UITableView!
    var moviesDictionaryArray:[NSDictionary]?
    var filteredMoviesDictionaryArray:[NSDictionary]?
    var uiRefreshControl : UIRefreshControl!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorViewLabel: UILabel!
    @IBOutlet weak var movieDvdSelectionTabBar: UITabBar!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorView.hidden = true
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        movieDvdSelectionTabBar.delegate = self
        searchBar.delegate = self
        
        // add refresh control
        // ISSUE: background of the view is not the same as table's background color
        uiRefreshControl = UIRefreshControl()
        uiRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        moviesTableView.addSubview(uiRefreshControl)
        
        movieDvdSelectionTabBar.selectedItem = movieDvdSelectionTabBar.items![0]
        loadData()
    }

    func refresh(sender:AnyObject)
    {
        self.uiRefreshControl.endRefreshing()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMoviesDictionaryArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movieCell = moviesTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MoviesTableViewCell
        let thisMovieDict = self.filteredMoviesDictionaryArray![indexPath.row]
        let movieHelper = MovieHelper(movie: thisMovieDict)
        movieCell.movieLabelName.text = movieHelper.getTitle()
        movieCell.synopsisLabel.text = movieHelper.getSynopsis()
        movieCell.criticScore.text = movieHelper.getCriticScoreString()
        movieCell.userScore.text = movieHelper.getAudienceScoreString()
        
        // fade in thumbnail image
        // ISSUE: images fade in even if they are coming from cache
        let request = NSURLRequest(URL: NSURL(string: movieHelper.getThumbnailUrl())!)
        let thumbnailView = movieCell.thumbnailImageView
        thumbnailView.setImageWithURLRequest(
            request,
            placeholderImage: nil,
            success: { (req, response, image) -> Void in
                thumbnailView.image = image
                thumbnailView.alpha = 0
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                        thumbnailView.alpha = 1
                    })
                },
            failure: nil)
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
                    
                    // copy to filteredMoviedDictionaryArray
                    self.filteredMoviesDictionaryArray = self.moviesDictionaryArray!
                    
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
        let movie = filteredMoviesDictionaryArray![indexPath!.row]
        let movieDetailViewController = segue.destinationViewController as! MovieDetaiViewController
        movieDetailViewController.movie = movie
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()

        filteredMoviesDictionaryArray = self.moviesDictionaryArray
        moviesTableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            self.filteredMoviesDictionaryArray = self.moviesDictionaryArray
        } else {
            filteredMoviesDictionaryArray = moviesDictionaryArray!.filter({ (movieDict : NSDictionary) -> Bool in
                let movieHelper = MovieHelper(movie: movieDict)
                return matchesMovieName(movieHelper, searchString: searchText)
            })
        }
        
        // reload view with new data
        self.moviesTableView.reloadData()
    }
    
    func matchesMovieName(movieHelper: MovieHelper, searchString: String) -> Bool {
        let range = movieHelper.getTitle()!.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch)
        return range != nil
    }
    
    
    
}
