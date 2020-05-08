//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Ashwini Prabhu on 5/8/20.
//  Copyright © 2020 experiment. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieSummary: UITextView!
    
    var movieDetail: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let posterPath = movieDetail["poster_path"] as? String ?? ""
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let posterUrl = URL(string: baseUrl + posterPath)
        movieImageView.setImageWith(posterUrl!)
        
        movieTitle.text = movieDetail["title"] as? String
        movieTitle.sizeToFit()
        
        let movieDate = movieDetail["release_date"] as! String
        releaseDate.text = ("Released On: \(movieDate)")
        
        let movieRatings = movieDetail["vote_average"] as? NSNumber
        ratings.text = ("Ratings: \(movieRatings!.stringValue)/10")
        
        movieSummary.text = movieDetail["overview"] as? String
        movieSummary.sizeToFit()
    }
}
