//
//  tdlpp_swiftuiApp.swift
//  tdlpp-swiftui
//
//  Created by Bruce Li on 11/15/22.
//

import SwiftUI

@main
struct tdlpp_swiftuiApp: App {
    
    @StateObject private var taskData = TaskData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskData)
        }
    }
}
