//
//  MovieTableViewCell.swift
//  AliveCorAssignment
//
//  Created by abhinay varma on 31/10/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var bookmarkIcon: UIButton!
    var model:Movie?
    var favClicked:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ model:Movie) {
        self.model = model
        let imageUrlString =  EndPoint.imageBaseURL.rawValue + (model.posterPath ?? "")
        if let url = URL(string:imageUrlString) {
            self.movieImage.sd_setImage(with: url, completed: nil)
        }
        self.ratingView.percent = model.voteAverage / 10
        self.titleLabel.text = model.title
        self.yearLabel.text = String(model.releaseDate?.prefix(4) ?? "")
        self.durationLabel.text =  "\(model.voteCount) votes"
        self.descriptionLabel.text = model.overview
        if model.favorite {
            bookmarkIcon.setBackgroundImage(UIImage(named:"selectedFav"),for:.normal)
        }else {
            bookmarkIcon.setBackgroundImage(UIImage(named:"bookmarkButtonIcon"),for:.normal)
        }
    }
    
    @IBAction func onClickBookmark(_ sender: Any) {
        if model?.favorite ?? true {
            bookmarkIcon.setBackgroundImage(UIImage(named:"bookmarkButtonIcon"),for:.normal)
        }else {
            bookmarkIcon.setBackgroundImage(UIImage(named:"selectedFav"),for:.normal)
        }
        if favClicked != nil {
            favClicked?()
        }
    }
    
}
