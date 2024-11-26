//
//  DetailViewModel.swift
//  replicate-kit-example
//
//  Created by Igor Shelopaev on 26.11.24.
//

import Foundation
import SwiftUICore
import replicate_kit_swift

typealias Operation =  @Sendable () async throws -> Image?

@MainActor
final class DetailViewModel : ObservableObject{
    
    @Published private(set) var error : String?
    
    @Published private(set) var image : Image?
    
    private var task : Task<(),Never>?
    
    // MARK: - API
    
    public func start(operation: @escaping Operation){
        task = Task{
            do{
                image = try await operation()
            }catch{
                handle(error)
            }
         }
    }
    
    public func cancel(){
        task?.cancel()
        task = nil
        clear()
    }
    
    // MARK: - Private
    
    private func clear(){
        error = nil
        image = nil
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
