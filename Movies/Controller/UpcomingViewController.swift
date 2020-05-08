//
//  UpcomingViewController.swift
//  Movies
//
//  Created by Ashwini Prabhu on 5/8/20.
//  Copyright © 2020 experiment. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

class UpcomingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var upcomingCollection: UICollectionView!
    
    var upcoming = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (view.frame.size.width - 20)/2
        let layout = upcomingCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        upcomingCollection.delegate = self
        upcomingCollection.dataSource = self
        
        fetchUpcomingMovies()
    }
    
    func fetchUpcomingMovies(){
        let apikey = "41368b6b9c082767748eb03146e984d6"
        if let url = NSURL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apikey)&language=en-US&page=1"){
            let request = URLRequest(url: url as URL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
               let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data{
                    let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                    print("responseDictionary : \(responseDictionary)")
                    self.upcoming = responseDictionary["results"] as! [[String:Any]]
                    self.upcomingCollection.reloadData()
               }
            }
               task.resume()
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcoming.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCell", for: indexPath) as! MoviesCollectionViewCell
        
        let movie = upcoming[indexPath.row]
        let title = movie["title"] as! String
        let posterPath = movie["poster_path"] as? String ?? ""

        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let posterUrl = URL(string: baseUrl + posterPath)

        cell.moviesName.text = title
        cell.moviesName.sizeToFit()
        cell.moviesImageView.setImageWith(posterUrl!)
        return cell
    }
}
