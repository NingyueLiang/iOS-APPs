//
//  FavouriteViewController.swift
//  FrankLiang-Lab4
//
//  Created by 梁宁越 on 2022/10/31.
//

import UIKit

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let userDefaults = UserDefaults.standard
    var favName: [String] = []
    var ids: [Int] = []
    var dates: [String] = []
    var paths: [String] = []
    var views: [String] = []
    var cnts: [Int] = []
    var scores: [Double] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Favorites"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = favName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            fetchData()
            ids.remove(at: indexPath.row)
            userDefaults.set(ids, forKey: "movieId")
            favName.remove(at: indexPath.row)
            userDefaults.set(favName, forKey: "movieName")
            dates.remove(at: indexPath.row)
            userDefaults.set(dates, forKey: "movieDate")
            paths.remove(at: indexPath.row)
            userDefaults.set(paths, forKey: "moviePath")
            views.remove(at: indexPath.row)
            userDefaults.set(views, forKey: "movieView")
            cnts.remove(at: indexPath.row)
            userDefaults.set(cnts, forKey: "movieCnt")
            scores.remove(at: indexPath.row)
            userDefaults.set(scores, forKey: "movieScore")
            fetchData()
            tableView.reloadData()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedVC = storyboard!.instantiateViewController(withIdentifier: "DetailedVC") as! DetailedViewController
        detailedVC.id = ids[indexPath.row]
        detailedVC.name = favName[indexPath.row]
        detailedVC.poster_path = paths[indexPath.row]
        detailedVC.vote_average = scores[indexPath.row]
        detailedVC.release_date = dates[indexPath.row]
        detailedVC.overview = views[indexPath.row]
        detailedVC.vote_count = cnts[indexPath.row]

        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    
    func fetchData(){
        favName = userDefaults.object(forKey: "movieName") as? [String] ?? []
        ids = userDefaults.object(forKey: "movieId") as? [Int] ?? []
        dates = userDefaults.object(forKey: "movieDate") as? [String] ?? []
        paths = userDefaults.object(forKey: "moviePath") as? [String] ?? []
        views = userDefaults.object(forKey: "movieView") as? [String] ?? []
        cnts = userDefaults.object(forKey: "movieCnt") as? [Int] ?? []
       scores = userDefaults.object(forKey: "movieScore") as? [Double] ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }
    
    @IBAction func resetDefault(_ sender: Any) {
        userDefaults.dictionaryRepresentation().keys.forEach(userDefaults.removeObject(forKey:))
        fetchData()
        tableView.reloadData()
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
