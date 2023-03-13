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
    
    private(set) var model : Model?
    
    private let api : ReplicateAPI
    
    init(){
        let url = URL(string: ReplicateAPI.Endpoint.baseURL)!
        let apiKey = ""
        api = ReplicateAPI(baseURL: url, apiKey: apiKey)
    }
    
    // MARK: - API
    
    func createPrediction(for input : InputModel) async throws -> Image{
        model = nil
        model = try await getModel(for: input)
        
        guard let latest = model?.latestVersion else {
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
        let rule : [Http.Validate.Status] = [.range(200..<300)]
        try validateStatus(response, by: rule)
        
        return data

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
