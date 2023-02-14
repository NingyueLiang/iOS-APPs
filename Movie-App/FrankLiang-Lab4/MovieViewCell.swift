//
//  MovieViewCell.swift
//  FrankLiang-Lab4
//
//  Created by 梁宁越 on 2022/10/29.
//

import UIKit

class MovieViewCell: UICollectionViewCell {
    //learn from  https://www.kodeco.com/18895088-uicollectionview-tutorial-getting-started#toc-anchor-013
    let title = UILabel(frame: CGRect(x: 0, y: 140, width: 120, height: 40))
    let poster = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 180))
    
    
    func getContent(txt: String, img: UIImage){
        title.text = txt
        title.textAlignment = .center
        title.textColor = UIColor.white
        title.backgroundColor = UIColor(named: "bgcolor")
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 13)
        poster.image = img
    }
    
}
