//
//  MovieDetaiViewController.swift
//  RottenTomatoes
//
//  Created by Soumya on 9/17/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class MovieDetaiViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var criticScoreLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var mpaaRatingLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    
    var movie: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie!["title"] as? String
        synopsisLabel.text = movie!["synopsis"] as? String
        let criticScoreInt = movie?.valueForKeyPath("ratings.critics_score") as! Int
        criticScoreLabel.text = "\(criticScoreInt)%"
        let audienceScoreInt = movie?.valueForKeyPath("ratings.audience_score") as! Int
        userScoreLabel.text = "\(audienceScoreInt)%"
        mpaaRatingLabel.text = movie!["mpaa_rating"] as? String
        let runTimeMin = movie!["runtime"] as! Int
        let min = runTimeMin % 60;
        let hour = (runTimeMin / 60) as Int;
        let runtimeString = (min > 0)
            ? "\(hour) hr. \(min) min."
            : "\(hour) hr."
        runtimeLabel.text = runtimeString
        
        var posterUrl = movie?.valueForKeyPath("posters.detailed") as! String
        let range = posterUrl.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            posterUrl = posterUrl.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        posterImageView.setImageWithURL(NSURL(string: posterUrl)!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
