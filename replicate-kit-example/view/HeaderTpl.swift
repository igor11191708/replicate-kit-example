//
//  HeaderTpl.swift
//  replicate-kit-example
//
//  Created by Igor on 12.03.2023.
//

import SwiftUI
import replicate_kit_swift

struct HeaderTpl: View {
    
    @Binding var selected : InputModel

    let model : Model?
    
    var body: some View {
        HStack(spacing: 15){
            HStack{
                Image(systemName: "person.crop.circle")
                Text(selected.owner)
            }
            HStack{
                Image(systemName: "photo.circle")
                Text(selected.name)
            }
            if let url =  model?.github_url{
                HStack{
                    Image(systemName: "icloud.circle")
                    Link("Github url", destination: url)
                }
            }
            
            Spacer()
        }.padding(.bottom)
        
        HStack(alignment: .top){
            Text("Params")
            Text(encode)
                .fontWeight(.regular)
        }
        .font(.body)
        .padding(.bottom)
        
        if let description =  model?.description{
            HStack(alignment: .top){
                Text("Description")
                Text(description)
                    .fontWeight(.regular)
            }
            .font(.body)
        }
    }
    
    private var encode : String{
        let model = selected
        guard let data = try? JSONEncoder().encode(model) else { return ""}
        
        return String(decoding: data, as: UTF8.self)
    }
}


