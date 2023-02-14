//
//  ExecuteCode.swift
//  tdlpp-swiftui
//
//  Created by Ryan Chen on 12/5/22.
//

import Foundation
import SwiftUI

struct ExecuteCode : View {
    var code: () = ().self
    init( _ codeToExec: () -> () ) {
        self.code = codeToExec()
    }
    
    var body: some View {
        return EmptyView().onAppear(){code}
    }
}
