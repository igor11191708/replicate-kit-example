//
//  StableDdiffusion.swift
//  replicate-kit-example
//
//  Created by Igor on 09.03.2023.
//

import SwiftUI
import replicate_kit_swift

struct DetailView: View{
    
    @EnvironmentObject var viewModel : ReplicateClient
    
    @Binding var selected : InputModel
    
    @State var error : String?
    
    @State var image : Image?
    
    @State var task : Task<(),Never>?
    
    var encode : String{
        let model = selected
        guard let data = try? JSONEncoder().encode(model) else { return ""}
        
        return String(decoding: data, as: UTF8.self)
    }
    
    var body: some View{
        VStack(alignment: .leading){
            HStack(spacing: 15){
                HStack{
                    Image(systemName: "person.crop.circle")
                    Text(selected.owner)
                }
                HStack{
                    Image(systemName: "photo.circle")
                    Text(selected.name)
                }
                if let url =  viewModel.model?.github_url{
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
            
            if let description =  viewModel.model?.description{
                HStack(alignment: .top){
                    Text("Description")
                    Text(description)
                        .fontWeight(.regular)
                }
                .font(.body)
            }
            
            Spacer()
            if let image{
                image
                    .resizable()
                    .scaledToFit()
                Spacer()
            }else if let error{
                Rectangle()
                    .fill(.clear)
                    .overlay(Text(error))
                    .padding()
            }else{
                Rectangle()
                    .fill(.clear)
                    .overlay(ProgressView())
            }
        }
        .font(.title2)
        .padding()
        .onChange(of: selected){item in
                        cancelTask()
                        clear()
                        task = getTask(by: item)
        }
        .onAppear{
            task = getTask(by: selected)
        }
        .onDisappear{
            cancelTask()
            clear()
        }
    }
    
    @MainActor
    private func clear(){
        error = nil
        image = nil
    }
    
    @MainActor
    private func cancelTask(){
        task?.cancel()
        task = nil
    }
    
    private func getTask( by item : InputModel) -> Task<(),Never>? {

        let task = Task{
                do{
                    image = try await viewModel.createPrediction(for: item)
                }catch{
                    if case ReplicateAPI.Errors.read(let e) = error {
                        self.error = e.description
                    }else{
                        self.error = error.localizedDescription
                    }
 
                    if let e = error as? ReplicateClient.Errors, e == .outputIsEmpty{
                        clear()
                    }
                }
            }
        
        return task
    }
}
