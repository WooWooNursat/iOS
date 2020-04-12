//
//  MovieTableViewCell.swift
//  TableViewProject
//
//  Created by erumaru on 4/4/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    // MARK: - Variables
    var movie: Movie! {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Methods
    func updateUI() {
        self.titleLabel.text = movie.title
        self.yearLabel.text = movie.year
        
        ImageService.shared.downloadImage(url: movie.posterURL) { image in
            self.posterImageView.image = image
        }
    }
}
