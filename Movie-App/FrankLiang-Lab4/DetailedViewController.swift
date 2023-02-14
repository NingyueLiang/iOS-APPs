//
//  DetailedViewController.swift
//  FrankLiang-Lab4
//
//  Created by 梁宁越 on 2022/10/31.
//

import UIKit

class DetailedViewController: UIViewController {
    var id: Int!
    var poster_path: String?
    var name: String!
    var release_date: String?
    var vote_average: Double!
    var overview: String!
    var vote_count:Int!
    var image: UIImage?
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var poster: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        spinner.hidesWhenStopped = true
        spinner.layer.zPosition = 10
        view.backgroundColor = .systemBackground
        
        movieName.text = name
        if let rDate = release_date{
            releaseDate.text = "Release Date: "+rDate
        }else{
            releaseDate.text = "Release Date: N/A"
        }
        if let mScore = vote_average{
            score.text = "Score: " + String(mScore)
        }else{
            score.text = "Score: N/A"
        }
        if let mOverview = overview{
            movieOverview.text = "Overview: " + mOverview
        }else{
            movieOverview.text = "Overview: N/A"
        }
        
        
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            if let path = self.poster_path{
                let url = URL(string: "https://image.tmdb.org/t/p/original" + path)
                guard let data = try? Data(contentsOf: url!) else {
                    self.poster.image = UIImage(named: "noimg")
                    return}
                self.image = UIImage(data: data)
            }else{
                self.image = UIImage(named: "noimg")
            }
            DispatchQueue.main.async {
                self.poster.image = self.image
                self.spinner.stopAnimating()
            }

        }
        
        
        
    }
    
    @IBOutlet weak var addButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ids: [Int] = userDefaults.object(forKey: "movieId") as? [Int] ?? []
        
        if ids.contains(self.id){
            addButton.isEnabled = false
        }else{
            addButton.isEnabled = true
        }
    }
    
    @IBAction func addFav(_ sender: UIButton) {
        //learn from https://cocoacasts.com/ud-3-how-to-store-an-array-in-user-defaults-in-swift
        //id
        var ids: [Int] = userDefaults.object(forKey: "movieId") as? [Int] ?? []
        ids.append(self.id)
        userDefaults.set(ids, forKey: "movieId")
        //name
        var names: [String] = userDefaults.object(forKey: "movieName") as? [String] ?? []
        names.append(self.name)
        userDefaults.set(names, forKey: "movieName")
        //release date
        var dates: [String] = userDefaults.object(forKey: "movieDate") as? [String] ?? []
        dates.append(self.release_date ?? "")
        userDefaults.set(dates, forKey: "movieDate")
        //image_path
        var paths: [String] = userDefaults.object(forKey: "moviePath") as? [String] ?? []
        paths.append(self.poster_path ?? "")
        userDefaults.set(paths, forKey: "moviePath")
        //overview
        var views: [String] = userDefaults.object(forKey: "movieView") as? [String] ?? []
        views.append(self.overview ?? "")
        userDefaults.set(views, forKey: "movieView")
        //Cnt
        var cnts: [Int] = userDefaults.object(forKey: "movieCnt") as? [Int] ?? []
        cnts.append(self.vote_count)
        userDefaults.set(cnts, forKey: "movieCnt")
        //Score
        var scores: [Double] = userDefaults.object(forKey: "movieScore") as? [Double] ?? []
        scores.append(self.vote_average)
        userDefaults.set(scores, forKey: "movieScore")
        addButton.isEnabled = false
        
    }
    
    @IBAction func getRec(_ sender: Any) {
        let recVC = storyboard!.instantiateViewController(withIdentifier: "RecVC") as! RecViewController
        recVC.movieId = id
        recVC.name = name
        navigationController?.pushViewController(recVC, animated: true)
    }
    @IBAction func watchYtb(_ sender: Any) {
        let ytbVC = storyboard!.instantiateViewController(withIdentifier: "ytbVC") as! YtbViewController
        ytbVC.input = name
        navigationController?.pushViewController(ytbVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
