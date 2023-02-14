//
//  util.swift
//  tdl_pp
//
//  Created by Yubo Wang on 11/9/22.
//

import Foundation
import SQLite3
import UIKit

class util {
    static func openDataBase() -> OpaquePointer? {
        var db: OpaquePointer?
        let p = Bundle.main.path(forResource: "tdl", ofType: "db")
        guard let p = p else {
            return nil
        }
        if sqlite3_open_v2(p, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK {
            print("databased connected successfully")
            return db
        } else {
            return nil
        }
    }
    
    static func inertDB(task:Task) {
        let db = openDataBase()!
        let dataString = "INSERT INTO tdl (id, title, desc, file, createtime, ddl, prio, status, modulelabel, img, color) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertOP: OpaquePointer?
        
        if sqlite3_prepare_v2(db, dataString, -1, &insertOP, nil) == SQLITE_OK {
            let id: Int32 = Int32(task.id)
            sqlite3_bind_int(insertOP, 1, id)
            
            let title: NSString = task.title as NSString
            sqlite3_bind_text(insertOP, 2, title.utf8String, -1, nil)
            
            let desc: NSString = String(task.desc ?? "") as NSString
            sqlite3_bind_text(insertOP, 3, desc.utf8String, -1, nil)
            
            let file: NSString = (task.file_) as NSString
            sqlite3_bind_text(insertOP, 4, file.utf8String, -1, nil)
            
            let createtime: Int32 = Int32(task.createDate.timeIntervalSince1970)
            sqlite3_bind_int(insertOP, 5, createtime)
            
            let ddl: Int32 = Int32(task.ddlDate?.timeIntervalSince1970 ?? 0)
            sqlite3_bind_int(insertOP, 6, ddl)
            
            let prio: Int32 = Int32(task.priority)
            sqlite3_bind_int(insertOP, 7, prio)
            
            let status: Int32 = Int32(task.status)
            sqlite3_bind_int(insertOP, 8, status)
            
            let modulelabel: NSString = String(task.moduleLabel) as NSString
            sqlite3_bind_text(insertOP, 9, modulelabel.utf8String, -1, nil)
            
            if task.img != nil && (task.img!.pngData() != nil) {
                let img: NSString = task.img!.pngData()!.base64EncodedString(options: .lineLength64Characters) as NSString
                sqlite3_bind_text(insertOP, 10, img.utf8String, -1, nil)
            } else {
                let img: NSString = NSString("")
                sqlite3_bind_text(insertOP, 10, img.utf8String, -1, nil)
            }
            
            let color: NSString = String(task.color) as NSString
            sqlite3_bind_text(insertOP, 11, color.utf8String, -1, nil)
            
            if sqlite3_step(insertOP) == SQLITE_DONE {
                print("insert successfully")
            } else {
                print("insert fail")
            }
        } else {
            print("db connect fail")
        }
        sqlite3_finalize(insertOP)
    }
       
    static func delete(id: Int32) {
        let db = openDataBase()!
        let dataString = "DELETE FROM tdl WHERE id = \(id);"
        var delOP: OpaquePointer?
        
        if sqlite3_prepare_v2(db, dataString, -1, &delOP, nil) == SQLITE_OK {
            if sqlite3_step(delOP) == SQLITE_DONE {
                print("delete success: \(id)")
            } else {
                print("delete fail")
            }
        } else {
            print("delete fail")
        }
        sqlite3_finalize(delOP)
    }
    
    static func loadAll() -> [Task] {
        let db = openDataBase()!
        let dataString = "SELECT * FROM tdl;"
        var queryOP: OpaquePointer?
        var res: [Task] = []
        
        if sqlite3_prepare_v2(db, dataString, -1, &queryOP, nil) == SQLITE_OK {
            while sqlite3_step(queryOP) == SQLITE_ROW {
                let id = sqlite3_column_int(queryOP, 0)
                let title = sqlite3_column_text(queryOP, 1)
                let desc = sqlite3_column_text(queryOP, 2)
                let file = sqlite3_column_text(queryOP, 3)
                let createtime = sqlite3_column_int(queryOP, 4)
                let ddl = sqlite3_column_int(queryOP, 5)
                let prio = sqlite3_column_int(queryOP, 6)
                let status = sqlite3_column_int(queryOP, 7)
                let modulelabel = sqlite3_column_text(queryOP, 8)
   
                let stringImg = String(cString: sqlite3_column_text(queryOP, 9))
                let decodedImg = Data(base64Encoded: stringImg, options: .ignoreUnknownCharacters)
                let color = sqlite3_column_text(queryOP, 10)
                
                if decodedImg == nil{
                    let task = Task(Int(id), String(cString: title!), String(cString: desc!), String(cString:file!), Date(timeIntervalSince1970: TimeInterval(createtime)), Date(timeIntervalSince1970: TimeInterval(ddl)), Int(prio), Int(status), String(cString: modulelabel!), nil, String(cString:color!))
                    // print("color\(task.color)")
                    res.append(task)
                }
                else {
                    let task = Task(Int(id), String(cString: title!), String(cString: desc!), String(cString:file!), Date(timeIntervalSince1970: TimeInterval(createtime)), Date(timeIntervalSince1970: TimeInterval(ddl)), Int(prio), Int(status), String(cString: modulelabel!), UIImage(data: decodedImg! as Data), String(cString:color!))
                    // print("color\(task.color)")
                    res.append(task)
                }
            }
            return res
        } else {
            print("query fail")
        }
        sqlite3_finalize(queryOP)
        return []
    }
    
    static func updateDB(id: Int32, field: String, value: Int) {
        let db = openDataBase()!
        let dataString = "UPDATE tdl SET \(field) = \(value) WHERE id = \(id);"
        var updateOP: OpaquePointer?
        
        if sqlite3_prepare_v2(db, dataString, -1, &updateOP, nil) == SQLITE_OK {
            if sqlite3_step(updateOP) == SQLITE_DONE {
                print("update success")
            } else {
                print("update fail")
            }
        } else {
            print("update fail")
        }
    }
    
    static func updateDB(id: Int32, field: String, value: String) {
        let db = openDataBase()!
        let dataString = "UPDATE tdl SET \(field) = '\(value)' WHERE id = \(id);"
        var updateOP: OpaquePointer?

        if sqlite3_prepare_v2(db, dataString, -1, &updateOP, nil) == SQLITE_OK {
            if sqlite3_step(updateOP) == SQLITE_DONE {
                print("update success")
            } else {
                print("update fail")
            }
        } else {
            print("update fail")
        }
    }
    
    static let timeFormatter = DateFormatter()
    
    static func formatDate(_ date:Date) -> String {
        timeFormatter.dateFormat = "dd MMM YYYY, HH:mm:ss"
        timeFormatter.timeZone = TimeZone.current
        return timeFormatter.string(from: date)
    }
    
    // The following functions about conversion between colors and HEX strings are inspired by the following sources:
    // https://stackoverflow.com/questions/57870527/scanhexint32-was-deprecated-in-ios-13-0
    // https://stackoverflow.com/questions/26341008/how-to-convert-uicolor-to-hex-and-display-in-nslog
    static func color2hex(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
     }

    static func hex2color(hexString: String) -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()

        //print(colorString)
        let alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    static func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt64 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt64(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        return floatValue
    }
        
    static func priority2str(priority: Int) -> String {
        switch priority {
        case 0:
            return "Critical Urgent"
        case 1:
            return "Major Urgent"
        case 2:
            return "Medium Urgent"
        case 3:
            return "Minor Urgent"
        case 4:
            return "Not Urgent"
        default:
            return "No Priority"
        }
    }
    
    static func str2priority(str: String) -> Int {
        switch str {
        case "Critical Urgent":
            return 0
        case "Major Urgent":
            return 1
        case "Medium Urgent":
            return 2
        case "Minor Urgent":
            return 3
        case "Not Urgent":
            return 4
        default:
            return 5
        }
    }
    
    static func status2str(status: Int) -> String {
        switch status {
        case 0:
            return "To-Do"
        case 1:
            return "Doing"
        case 2:
            return "Done"
        default:
            return "No Status"
        }
    }
    
    static func str2status(str: String) -> Int {
        switch str {
        case "To-Do":
            return 0
        case "Doing":
            return 1
        case "Done":
            return 2
        default:
            return 3
        }
    }
}

