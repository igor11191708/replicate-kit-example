//
//  DetailView.swift
//  replicate-kit-example
//
//  Created by Igor on 09.03.2023.
//

import SwiftUI
import replicate_kit_swift
import async_task

struct DetailView: View{
    
    @EnvironmentObject var viewModel : ReplicateClient
    
    @StateObject private var detailModel = SingleTaskViewModel<Image, ReplicateAPI.Errors>(errorHandler: errorHandler)
    
    @Binding var selected : InputModel
    
    // MARK: - Life circle
    
    var body: some View{
        VStack(alignment: .leading){
            HeaderTpl(selected: $selected, model: viewModel.model)
            Spacer()
            if let image = detailModel.value{
                image
                    .resizable()
                    .scaledToFit()
                Spacer()
            }else if let text = errorToText(detailModel.error){
                Rectangle()
                    .fill(.clear)
                    .overlay(Text(text))
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
    
    func errorToText(_ error : Error?) -> String?{
        
        if let e = error as? ReplicateClient.Errors,
               e == .outputIsEmpty{
            detailModel.clean()
        }
        
        return error?.localizedDescription
    }
}

@Sendable
func errorHandler(_ error : Error?) -> ReplicateAPI.Errors?{
    if let e = error as? ReplicateClient.Errors{
        return .clientError(e.localizedDescription)
    }
    
    return nil
}

