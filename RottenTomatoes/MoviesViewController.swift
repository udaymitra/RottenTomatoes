//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by Soumya on 9/17/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let BOX_OFFICE_URL = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"

    @IBOutlet weak var moviesTableView: UITableView!
    
    var moviesDictionaryArray:[NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        populateMoviesFromBoxOffice()
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
    
    func populateMoviesFromBoxOffice() {
        let url = NSURL(string: BOX_OFFICE_URL)
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if let d = data {
                let object = try! NSJSONSerialization.JSONObjectWithData(d, options: []) as! NSDictionary
                if let allData = object["movies"] {
                    self.moviesDictionaryArray = allData as? [NSDictionary]
                    self.moviesTableView.reloadData()
                }
            } else {
                if let e = error {
                    NSLog("Error: \(e)")
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = moviesTableView.indexPathForCell(cell)
        let movie = moviesDictionaryArray![indexPath!.row]
        let movieDetailViewController = segue.destinationViewController as! MovieDetaiViewController
        movieDetailViewController.movie = movie
    }

}
