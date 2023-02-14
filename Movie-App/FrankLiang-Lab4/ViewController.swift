//
//  ViewController.swift
//  FrankLiang-Lab4
//
//  Created by 梁宁越 on 2022/10/29.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,  UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let userDefaults = UserDefaults.standard
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
    
    //variable to store the data
    var theData: [Movie] = []
    var theImageCache:[UIImage] = []
    private let itemsPerRow: CGFloat = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        spinner.hidesWhenStopped = true
        spinner.layer.zPosition = 10
        searchBar.delegate = self
        setupCollectionView()
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchDefaultDataForCollectionView()
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.collectionView.reloadData()
            }
            
        }
      
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text ?? "").isEmpty {
            let inputText = (searchBar.text ?? "")
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                self.fetchDataForCollectionView(searchInput: inputText)
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.searchBar.text = ""
                    self.collectionView.reloadData()
                }
                
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var mCell = MovieViewCell()
        if let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MovieViewCell{
            movieCell.getContent(txt: theData[indexPath.row].title, img: theImageCache[indexPath.row])
            mCell = movieCell
            mCell.contentView.addSubview(mCell.poster)
            mCell.contentView.addSubview(mCell.title)
        }

        return mCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = storyboard!.instantiateViewController(withIdentifier: "DetailedVC") as! DetailedViewController
        let movie = theData[indexPath.row]
        detailedVC.id = movie.id
        detailedVC.name = movie.title
        detailedVC.poster_path = movie.poster_path
        detailedVC.vote_average = movie.vote_average
        detailedVC.release_date = movie.release_date
        detailedVC.overview = movie.overview
        detailedVC.vote_count = movie.vote_count
    
        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieViewCell.self, forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        //learn from https://www.kodeco.com/18895088-uicollectionview-tutorial-getting-started#toc-anchor-013
        let cellWidth = UIScreen.main.bounds.width / itemsPerRow - 10
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth*1.5)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom:0, right: 5)
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
       
    }
//learn from  https://developer.apple.com/documentation/uikit/uicontrol/adding_context_menus_in_your_app
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
   let configuraton =  UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {
                suggestedActions in
            let addFavAction =
                UIAction(title: NSLocalizedString("Favorite", comment: ""),
                         image: UIImage(systemName: "star")) { action in
                    let movie = self.theData[indexPath.row]
                    let ids: [Int] = self.userDefaults.object(forKey: "movieId") as? [Int] ?? []
                    if !ids.contains(movie.id){
                        var ids: [Int] = self.userDefaults.object(forKey: "movieId") as? [Int] ?? []
                        ids.append(movie.id)
                        self.userDefaults.set(ids, forKey: "movieId")
                        //name
                        var names: [String] = self.userDefaults.object(forKey: "movieName") as? [String] ?? []
                        names.append(movie.title)
                        self.userDefaults.set(names, forKey: "movieName")
                        //release date
                        var dates: [String] = self.userDefaults.object(forKey: "movieDate") as? [String] ?? []
                        dates.append(movie.release_date ?? "")
                        self.userDefaults.set(dates, forKey: "movieDate")
                        //image_path
                        var paths: [String] = self.userDefaults.object(forKey: "moviePath") as? [String] ?? []
                        paths.append(movie.poster_path ?? "")
                        self.userDefaults.set(paths, forKey: "moviePath")
                        //overview
                        var views: [String] = self.userDefaults.object(forKey: "movieView") as? [String] ?? []
                        views.append(movie.overview)
                        self.userDefaults.set(views, forKey: "movieView")
                        //Cnt
                        var cnts: [Int] = self.userDefaults.object(forKey: "movieCnt") as? [Int] ?? []
                        cnts.append(movie.vote_count)
                        self.userDefaults.set(cnts, forKey: "movieCnt")
                        //Score
                        var scores: [Double] = self.userDefaults.object(forKey: "movieScore") as? [Double] ?? []
                        scores.append(movie.vote_average)
                        self.userDefaults.set(scores, forKey: "movieScore")
                    }
                }
                
           
                                            
            return UIMenu(title: "", children: [addFavAction])
        })
        return configuraton
    }
    
    
    func fetchDefaultDataForCollectionView() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=b6428c9ca236da56702c725415ee1034")
        guard let data = try? Data(contentsOf: url!) else { return }
        guard let result = try? JSONDecoder().decode(APIResults.self, from: data) else { return }
        theData = result.results
        self.cacheImages()
    }
    
    func fetchDataForCollectionView(searchInput: String) {
        guard let search = searchInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=b6428c9ca236da56702c725415ee1034&query="+search)
        if url != nil {
            guard let data = try? Data(contentsOf: url!) else { return }
            guard let result = try? JSONDecoder().decode(APIResults.self, from: data) else { return }
            theData = result.results
            self.cacheImages()
            
        }
        
    }
    
    func cacheImages() {
        theImageCache = []
        for movie in theData {
            var image = UIImage(named: "noimg")
            if let poster = movie.poster_path{
                let url = URL(string: "https://image.tmdb.org/t/p/w500" + poster)
                guard let data = try? Data(contentsOf: url!) else {return}
                image = UIImage(data: data)
            }
            theImageCache.append(image ?? UIImage())
        }
    }
}

