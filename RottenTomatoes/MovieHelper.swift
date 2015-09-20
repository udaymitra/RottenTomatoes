//
//  MovieHelper.swift
//  RottenTomatoes
//
//  Created by Soumya on 9/19/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import Foundation

class MovieHelper {
    
    var movie: NSDictionary
    
    init(movie: NSDictionary) {
        self.movie = movie
    }
    
    func getTitle() -> String? {
        return movie["title"] as? String
    }
    
    func getSynopsis() -> String? {
        return movie["synopsis"] as? String
    }
    
    func getCriticScoreString() -> String {
        let criticScoreInt = movie.valueForKeyPath("ratings.critics_score") as! Int
        return "\(criticScoreInt)%"
    }
    
    func getAudienceScoreString() -> String {
        let audienceScoreInt = movie.valueForKeyPath("ratings.audience_score") as! Int
        return "\(audienceScoreInt)%"
    }
    
    func getMpaaRatingString() -> String? {
        return movie["mpaa_rating"] as? String
    }
    
    func getRuntimeString() -> String {
        let runTimeMin = movie["runtime"] as! Int
        let min = runTimeMin % 60;
        let hour = (runTimeMin / 60) as Int;
        return (min > 0)
            ? "\(hour) hr. \(min) min."
            : "\(hour) hr."
    }
    
    func getThumbnailUrl() -> String {        
        return movie.valueForKeyPath("posters.thumbnail") as! String
    }
    
    func getPosterUrl() -> String {
        var posterUrl = movie.valueForKeyPath("posters.detailed") as! String
        let range = posterUrl.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            posterUrl = posterUrl.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        return posterUrl
    }
    
}
