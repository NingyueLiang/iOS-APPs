//
//  RecViewController.swift
//  FrankLiang-Lab4
//
//  Created by 梁宁越 on 2022/10/31.
//

import UIKit

class RecViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var name: String!
    var movieId : Int!
    var recData: [Movie] = []
    struct APIResults:Decodable {
        let page: Int
        let total_results: Int
        let total_pages: Int
        let results: [Movie]
    }
    struct Movie: Decodable {
        let id: Int!
        let poster_path: String?
        let title: String
        let release_date: String?
        let vote_average: Double
        let overview: String
        let vote_count:Int!
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Rec From " + name
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "recCell")
        spinner.hidesWhenStopped = true
        spinner.layer.zPosition = 10
        view.backgroundColor = .systemBackground
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchRecDataForTableView()
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                if self.recData.count == 0 {
                    self.title = "No Recommandation Available"
                    self.alert()
                }
                self.tableView.reloadData()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedVC = storyboard!.instantiateViewController(withIdentifier: "DetailedVC") as! DetailedViewController
        detailedVC.id = recData[indexPath.row].id
        detailedVC.name = recData[indexPath.row].title
        detailedVC.poster_path = recData[indexPath.row].poster_path
        detailedVC.vote_average = recData[indexPath.row].vote_average
        detailedVC.release_date = recData[indexPath.row].release_date
        detailedVC.overview = recData[indexPath.row].overview
        detailedVC.vote_count = recData[indexPath.row].vote_count

        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = recData[indexPath.row].title
        return cell
    }
    
    func fetchRecDataForTableView() {
        guard let target = movieId else{ return }
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(target)/recommendations?api_key=b6428c9ca236da56702c725415ee1034&language=en-US&page=1")
    
        guard let data = try? Data(contentsOf: url!) else { return }
        guard let result = try? JSONDecoder().decode(APIResults.self, from: data) else { return }
        recData = result.results
        
    }
    //learn from https://www.appsdeveloperblog.com/how-to-show-an-alert-in-swift/
    func alert(){
        let diag = UIAlertController(title: "Not Available Yet", message: "No Recommandations Available Yet", preferredStyle: .alert)
        diag.addAction(UIAlertAction(title: "OK", style: .default))
        present(diag, animated: true, completion: nil)
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
