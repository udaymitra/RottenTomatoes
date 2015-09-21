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
        let movieHelper = MovieHelper(movie: movie!)
        
        titleLabel.text = movieHelper.getTitle()
        synopsisLabel.text = movieHelper.getSynopsis()
        criticScoreLabel.text = movieHelper.getCriticScoreString()
        userScoreLabel.text = movieHelper.getAudienceScoreString()
        mpaaRatingLabel.text = movieHelper.getMpaaRatingString()
        runtimeLabel.text = movieHelper.getRuntimeString()
        
        posterImageView.setImageWithURL(NSURL(string: movieHelper.getThumbnailUrl())!)
        posterImageView.fadeInImageFromUrl(movieHelper.getPosterUrl(), placeholderImage: posterImageView.image, fadeInDuration: 0.2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
