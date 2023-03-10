//
//  ReplicateClient.swift
//  replicate-kit-example
//
//  Created by Igor on 09.03.2023.
//

import replicate_kit_swift
import SwiftUI

final class ReplicateClient : ObservableObject{
    
    private let api : ReplicateAPI
    
    init(){
        let url = URL(string: ReplicateAPI.Endpoint.baseURL)!
        let apiKey = ""
        api = ReplicateAPI(baseURL: url, apiKey: apiKey)
    }
    
    // MARK: - API
    
    func createPrediction(for input : InputModel) async throws -> Image{
        
        let model = try await getModel(for: input)
        
        guard let latest = model.latestVersion else {
            throw Errors.latestVersionIsEmpty
        }
            
        let output: [String]? = try await api.createPrediction(
                version: latest.id,
                input: input.params
        ).output
        
            
        guard let stringURL = output?.first else { throw Errors.outputIsEmpty
        }
            
        return try await getImage(for: stringURL)

    }
    
    // MARK: - Private
    
    /// Get model by desctription
    /// - Parameter item: Model params
    /// - Returns: Replicate model
    private func getModel(for item : InputModel) async throws -> Model{
        try await api.getModel(owner: item.owner, name: item.name)
    }
    
    /// - Parameter stringUrl: String url
    /// - Returns: Image
    private func getImage(for stringUrl : String ) async throws -> Image{
        let data = try await loadData(for: stringUrl)
        return try image(from: data)
    }
        
    /// Load data
    /// - Parameter stringUrl: String url
    /// - Returns: Data for image
    private func loadData(for stringUrl : String) async throws -> Data{
        guard let url = URL(string: stringUrl) else{
           throw Errors.urlOutputIsNotValid
        }
        // TODO: elaborate on this line
        return try await URLSession.shared.data(from: url).0
    }
    
    // MARK: - Inner
    
    enum Errors : Error{
        case latestVersionIsEmpty
        case outputIsEmpty
        case imageInit
        case urlOutputIsNotValid
    }
    
}

// MARK: - File private

#if os(iOS) || os(watchOS) || os(tvOS)
    /// - Parameter data: Data
    /// - Returns: Image based on UIImage
    fileprivate func image(from data: Data?) throws -> Image {

        if let data, let image = UIImage(data: data){
            return Image(uiImage: image)
        }
        
        throw ReplicateClient.Errors.imageInit
    }
#endif
    
#if os(macOS)
    /// - Parameter data: Data
    /// - Returns: Image based on NSImage
    fileprivate func image(from data: Data?) throws -> Image {
        
        if let data, let image = NSImage(data: data){
            return Image(nsImage: image)
        }
        
        throw ReplicateClient.Errors.imageInit
    }
#endif
