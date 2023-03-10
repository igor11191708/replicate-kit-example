//
//  SideBar.swift
//  replicate-kit-example
//
//  Created by Igor on 09.03.2023.
//

import SwiftUI

struct SideBar: View{
    
    @Binding var selected : InputModel
    
    var body: some View{
#if os(macOS)
        List(selection: $selected){
            Section("Diffusion models"){
                ForEach(data, id: \.self){ item in
                    HStack{
                        Image(systemName: "photo.circle")
                        Text(item.name)
                    }
                }
            }
        }
        
#elseif os(iOS)
        List{
            Section("Diffusion models"){
                ForEach(data, id: \.self){ item in
                    NavigationLink(value: item){
                        HStack{
                            Image(systemName: "photo.circle")
                            Text(item.name)
                        }
                    }
                }
            }
        }
#endif
    }
}
