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
    
    @Binding var selected : InputModel
    
    // MARK: - Private
    
    @State private var error : String?
    
    @State private var image : Image?
    
    @State private var task : Task<(),Never>?
    
    // MARK: - Life circle
    
    var body: some View{
        VStack(alignment: .leading){
            HeaderTpl(selected: $selected, model: viewModel.model)
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
        .onChange(of: selected){ item in
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
    
    // MARK: - Private
    
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
    
    /// Get task with a prediction
    /// - Parameter item: Input description
    /// - Returns: Task running prediction
    private func getTask( by item : InputModel) -> Task<(),Never>? {
       Task{
            do{ image = try await viewModel.createPrediction(for: item)
            }catch{ handle(error) }
        }
    }
    
    /// Handle error
    /// - Parameter error: Error
    private func handle(_ error : Error){
        /// Expose logical error from Replicate

        guard let e = error as? ResponseError else{
            return self.error = error.localizedDescription
        }
        
        self.error = e.description

        if let e = error as? ReplicateClient.Errors,
               e == .outputIsEmpty{
            clear()
        }
    }
}
