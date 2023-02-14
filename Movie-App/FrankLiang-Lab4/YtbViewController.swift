//
//  YtbViewController.swift
//  FrankLiang-Lab4
//
//  Created by 梁宁越 on 2022/10/31.
//

import UIKit
import WebKit
class YtbViewController: UIViewController {
    var input: String!
    @IBOutlet weak var ytbView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Clips for " + input
        let search = self.input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //learn from https://stackoverflow.com/questions/25597092/how-to-load-url-in-uiwebview-in-swift
        
        if let url = URL (string: "http://www.youtube.com/results?search_query="+(search ?? "")){
            let requestObj = URLRequest(url: url)
            ytbView.load(requestObj)
        } else {
            self.title = "Invalid URL"
            self.alert()
            return
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ytbView.removeFromSuperview()
    }
    
    
    func alert(){
        let diag = UIAlertController(title: "Invalid URL", message: "The YouTube is not working :(", preferredStyle: .alert)
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
