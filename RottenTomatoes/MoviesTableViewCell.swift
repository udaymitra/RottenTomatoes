//
//  MoviesTableViewCell.swift
//  RottenTomatoes
//
//  Created by Soumya on 9/17/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    @IBOutlet weak var movieLabelName: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
