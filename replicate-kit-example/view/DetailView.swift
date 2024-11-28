//
//  DetailView.swift
//  replicate-kit-example
//
//  Created by Igor Shelopaev on 09.03.2023.
//

import SwiftUI
import replicate_kit_swift
import async_task

fileprivate typealias TaskModel = Async.SingleTask<Image, ReplicateAPI.Errors>

struct DetailView: View{
    
    @EnvironmentObject var viewModel : ReplicateClient
    
    @StateObject private var taskModel = TaskModel(errorHandler: errorHandler)
    
    @Binding var selected : InputModel
    
    // MARK: - Life circle
    
    var body: some View{
        VStack(alignment: .leading){
            HeaderTpl(selected: $selected, model: viewModel.model)
            Spacer()
            if let image = taskModel.value{
                image
                    .resizable()
                    .scaledToFit()
                Spacer()
            }else if let text = errorToText(taskModel.error){
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

    func start(by input : InputModel){
        taskModel.start(with: input){ input in
            try await viewModel.createPrediction(for: input)
        }
    }
    
    func cancel(){
        taskModel.cancel()
    }
    
    func errorToText(_ error : Error?) -> String?{
        
        if let e = error as? ReplicateClient.Errors,
               e == .outputIsEmpty{
            taskModel.clean()
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

