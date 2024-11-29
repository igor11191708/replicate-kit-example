//
//  DetailView.swift
//  replicate-kit-example
//
//  Created by Igor Shelopaev on 09.03.2023.
//

import SwiftUI
import replicate_kit_swift
import async_task

fileprivate typealias TaskModel = Async.ObservableSingleTask<Image, ReplicateAPI.Errors>

struct DetailView: View{
    
    @EnvironmentObject var viewModel : ReplicateClient
    
    @State private var taskModel = TaskModel(errorMapper: errorMapper)
    
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
        .onChange(of: selected){ oldItem, newItem in
           start(by: newItem)
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
        return error?.localizedDescription
    }
}

@Sendable
func errorMapper(_ error : Error?) -> ReplicateAPI.Errors?{
    if let e = error as? ReplicateClient.Errors{
        return .clientError(e)
    }
    
    return nil
}

