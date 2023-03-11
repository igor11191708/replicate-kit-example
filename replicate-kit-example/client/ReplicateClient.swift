//
//  ReplicateClient.swift
//  replicate-kit-example
//
//  Created by Igor on 09.03.2023.
//

import replicate_kit_swift
import async_http_client
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
        
        let (data, response) = try await Http.Get.from(url)

        return try validate(response, and: data)

    }
    
    // MARK: - Inner
    
    enum Errors : Error, Hashable{
        case latestVersionIsEmpty
        case outputIsEmpty
        case imageInit
        case urlOutputIsNotValid
        case invalidImageResponse(URLResponse)
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


fileprivate func validate(_ response : URLResponse,and data : Data) throws -> Data {
    switch (response as? HTTPURLResponse)?.statusCode {
        case (200..<300)?: return data
    default: throw ReplicateClient.Errors.invalidImageResponse(response)
    }
}
