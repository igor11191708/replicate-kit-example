//
//  replicate_kit_exampleApp.swift
//  replicate-kit-example
//
//  Created by Igor on 09.03.2023.
//

import SwiftUI

@main
struct replicate_kit_exampleApp: App {
    
    @StateObject var model = ReplicateClient()
    
    var body: some Scene {
        WindowGroup {
            ContentView(selected : data.first!)
                .environmentObject(model)
        }
    }
}
