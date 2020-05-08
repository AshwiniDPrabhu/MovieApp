//
//  TrendingViewController.swift
//  Movies
//
//  Created by Ashwini Prabhu on 5/7/20.
//  Copyright © 2020 experiment. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

class TrendingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var trendingMovies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 20)/2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
        fetchTrendingMovies()
    }
    
    func fetchTrendingMovies(){
        let apikey = "41368b6b9c082767748eb03146e984d6"
        if let url = NSURL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apikey)&language=en-US&page=1"){
            let request = URLRequest(url: url as URL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
               let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data{
                    let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                    print("responseDictionary : \(responseDictionary)")
                    self.trendingMovies = responseDictionary["results"] as! [[String:Any]]
                    self.collectionView.reloadData()
               }
            }
               task.resume()
            }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingMovies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MoviesCollectionViewCell
        
        let trendingMovie = trendingMovies[indexPath.row]
        let title = trendingMovie["title"] as! String
        let posterPath = trendingMovie["poster_path"] as? String ?? ""

        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let posterUrl = URL(string: baseUrl + posterPath)

        cell.moviesName.text = title
        cell.moviesImageView.setImageWith(posterUrl!)
        return cell
    }
}
