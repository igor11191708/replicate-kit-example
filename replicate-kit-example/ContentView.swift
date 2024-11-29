//
//  ContentView.swift
//  replicate-kit-example
//
//  Created by Igor on 09.03.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var selected : InputModel
   
    var body: some View {
        NavigationSplitView{
            SideBar(selected: $selected)
                .navigationTitle("Replicate models")
                .navigationSplitViewColumnWidth(min: 300, ideal: 350, max: 600)
                .navigationDestination(for: InputModel.self){ value in  DetailView(selected : .constant(value))
                }
        } detail: {
            #if os(macOS)
                DetailView(selected : $selected)
            #endif
          }
        .navigationSplitViewStyle(.balanced)
    }
}
