//
//  TrailerViewController.swift
//  flix
//
//  Created by Xueying Wang on 6/23/17.
//  Copyright © 2017 Xueying Wang. All rights reserved.
//

import UIKit

class TrailerViewController: UIViewController {
    @IBOutlet weak var trailerWebView: UIWebView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movie: [String: Any]?
    var key = ""
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()

        
        if let movie = movie {
            let movie_id = movie["id"] as! Int
            let movieURL = URL(string: "https://api.themoviedb.org/3/movie/\(movie_id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
            let request = URLRequest(url: movieURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                //This will run when the network request returns
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    let trailers = dataDictionary["results"] as! [[String: Any]]
                    let trailer = trailers[0]
                    self.key = trailer["key"] as! String
                    self.url = "https://www.youtube.com/watch?v=" + self.key
                    let requestURL = URL(string:self.url)
                    let request = URLRequest(url: requestURL!)
                    self.trailerWebView.loadRequest(request)
                    self.activityIndicator.stopAnimating()
                }
            }
            task.resume()
        }
    }
    
    
    @IBAction func backToDetail(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
