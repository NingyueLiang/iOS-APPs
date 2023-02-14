//
//  Document.swift
//  tdlpp-swiftui
//
//  Created by Ryan Chen on 12/3/22.
//

import Foundation

import SwiftUI
import UniformTypeIdentifiers

// For document in fileExport above
struct Doc: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.item]

    // by default our document is empty
    var url : String

    // a simple initializer that creates new, empty documents
    init(url: String) {
        self.url = url
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        // we don't need to read it
        url = ""
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
            // to save the file
            var file = FileWrapper()
            if URL(string: url)!.startAccessingSecurityScopedResource(){
                file = try! FileWrapper(url: URL(string: url)!, options: .immediate)
                return file
            }
            URL(string: url)!.stopAccessingSecurityScopedResource()
            return file
        }
}
