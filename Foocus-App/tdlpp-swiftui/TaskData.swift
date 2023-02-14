//
//  TaskData.swift
//  tdlpp-swiftui
//
//  Created by 梁宁越 on 2022/11/15.
//

import Foundation

final class TaskData: ObservableObject {
    @Published var tasks: [Task]

    init() {
        tasks = util.loadAll()
    }
}
