//
//  DetailView.swift
//  replicate-kit-example
//
//  Created by Igor on 09.03.2023.
//

import SwiftUI
import replicate_kit_swift

struct DetailView: View{
    
    @EnvironmentObject var viewModel : ReplicateClient
    
    @StateObject private var detailModel = DetailViewModel()
    
    @Binding var selected : InputModel
    
    // MARK: - Life circle
    
    var body: some View{
        VStack(alignment: .leading){
            HeaderTpl(selected: $selected, model: viewModel.model)
            Spacer()
            if let image = detailModel.image{
                image
                    .resizable()
                    .scaledToFit()
                Spacer()
            }else if let error = detailModel.error{
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
        .onChange(of: selected){ item in
            cancel()
           start(by: item)
        }
        .onAppear{
            start(by: selected)
        }
        .onDisappear{
            cancel()
        }
    }
    
    // MARK: - Private

    func start(by item : InputModel){
        detailModel.start{
            try await viewModel.createPrediction(for: item)
        }
    }
    
    func cancel(){
        detailModel.cancel()
    }
    

}
