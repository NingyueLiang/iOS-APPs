//
//  Task.swift
//  tdl_pp
//
//  Created by Ryan Chen on 11/10/22.
//

import Foundation
import UIKit
import SwiftUI

class Task: Hashable, Identifiable, ObservableObject {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return (lhs.title == rhs.title) && (lhs.createDate == rhs.createDate)
    }
    
    
    var id:Int32
    var title:String = ""
    var desc:String?
    var file_:String
    var createDate:Date = Date()
    var ddlDate:Date?
    var priority:Int // 0 (high) - 4 (low) and 5 for no priority
    var status:Int
    var moduleLabel:String
    var img:UIImage?
    var color:String
    
    let count = 11
    
    init() {
        self.id = 438
        self.title = "test"
        self.color = "#F8B195"
        self.moduleLabel = "No Label"
        self.priority = 3
        self.status = 2
        self.file_ = ""
    }
    
    init(_ id:Int, _ title:String, _ desc:String?, _ file:String?, _ createTime:Date, _ ddlDate:Date?, _ priority:Int?, _ status:Int?, _ moduleLabel:String?, _ img:UIImage?, _ color:String?){
        self.id = Int32(truncating: NSNumber(value: id))
        self.title = title
        self.desc = desc
        self.file_ = file ?? ""
        self.createDate = createTime
        self.ddlDate = ddlDate
        self.priority = priority ?? 5
        self.status = status ?? 3
        self.moduleLabel = moduleLabel ?? "No Label"
        self.img = img
        if color == nil || color!.count < 6 {
            self.color = "#355C7D"
        } else {
            self.color = color!
        }
    }
    
    init(_ id:Int, _ title:String, _ desc:String?, _ file:String?, _ ddlDate:Date?, _ priority:Int?, _ status:Int?, _ moduleLabel:String?, _ img:UIImage?, _ color:String?){
        self.id = Int32(truncating: NSNumber(value: id))
        self.title = title
        self.desc = desc
        self.file_ = file ?? ""
        self.createDate = Date()
        self.ddlDate = ddlDate
        self.priority = priority ?? 5
        self.status = status ?? 3
        self.moduleLabel = moduleLabel ?? "No Label"
        self.img = img
        if color == nil || color!.count < 6 {
            self.color = "#355C7D"
        } else {
            self.color = color!
        }
    }
    
    init(_ title:String, _ desc:String?, _ file:String?, _ createTime:Date, _ ddlDate:Date?, _ priority:Int?, _ status:Int?, _ moduleLabel:String?, _ img:UIImage?, _ color:String?){
        self.id = Int32(truncating: NSNumber(value: abs("\(title)\(String(describing: createTime))".hashValue)))
        self.title = title
        self.desc = desc
        self.file_ = file ?? ""
        self.createDate = createTime
        self.ddlDate = ddlDate
        self.priority = priority ?? 5
        self.status = status ?? 3
        self.moduleLabel = moduleLabel ?? "No Label"
        self.img = img
        if color == nil || color!.count < 6 {
            self.color = "#355C7D"
        } else {
            self.color = color!
        }
    }
    
    init(_ title:String, _ desc:String?, _ file:String?, _ ddlDate:Date?, _ priority:Int?, _ status:Int?, _ moduleLabel:String?, _ img:UIImage?, _ color:String?){
        let createTime = Date()
        self.id = Int32(truncating: NSNumber(value: abs("\(title)\(String(describing: createTime))".hashValue)))
        self.title = title
        self.desc = desc
        self.file_ = file ?? ""
        self.createDate = createTime
        self.ddlDate = ddlDate
        self.priority = priority ?? 5
        self.status = status ?? 3
        self.moduleLabel = moduleLabel ?? "No Label"
        self.img = img
        if color == nil || color!.count < 6 {
            self.color = "#355C7D"
        } else {
            self.color = color!
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(createDate)
    }
    

    // return time left in seconds
    func timeRemaining(currentTime:Date) -> Int {
        let totalDifference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: currentTime, to: ddlDate!)
        return totalDifference.day! * 24 * 60 * 60 + totalDifference.hour! * 60 * 60 + totalDifference.minute! * 60 + totalDifference.second!
    }

    func getProgress(currentTime:Date) -> Double {
        let duration = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: createDate, to: ddlDate!)
        let totalSeconds = duration.day! * 24 * 60 * 60 + duration.hour! * 60 * 60 + duration.minute! * 60 + duration.second!
        let remainingSeconds = timeRemaining(currentTime: currentTime)
        return Double(remainingSeconds) / Double(totalSeconds)
    }

}
