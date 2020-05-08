//
//  MoviesViewController.swift
//  Movies
//
//  Created by Ashwini Prabhu on 5/7/20.
//  Copyright © 2020 experiment. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]()
    var selectedMovie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchMovies()
    }
    
    func fetchMovies(){
        let apikey = "41368b6b9c082767748eb03146e984d6"
        if let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apikey)"){
            let request = URLRequest(url: url as URL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
               let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data{
                    let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                    print("responseDictionary : \(responseDictionary)")
                    self.movies = responseDictionary["results"] as! [[String:Any]]
                    self.tableView.reloadData()
               }
            }
               task.resume()
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MoviesTableViewCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as? String ?? ""
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.movieTitle.text = title
        cell.movieTitle.sizeToFit()
        
        cell.movieOverview.text = overview
        cell.moviePoster.setImageWith(posterUrl!)
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "movieToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if(segue.identifier == "movieToDetail") {
                let vc = segue.destination as! MovieDetailsViewController
                vc.movieDetail = selectedMovie
           }
       }
}
