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
    
    /// Get model by dectription
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


let data : [InputModel] = [
    .init(
        owner: "stability-ai",
        name: "stable-diffusion",
        params: ["prompt": "an astronaut riding a horse on mars artstation, hd, dramatic lighting, detailed"]
    ),
    .init(
        owner: "cjwbw",
        name: "anything-v3-better-vae",
        params: [
            "prompt": "masterpiece, best quality, illustration, beautiful detailed, finely detailed, dramatic light, intricate details, 1girl, brown hair, green eyes, colorful, autumn, cumulonimbus clouds, lighting, blue sky, falling leaves, garden",
            "negative_prompt" : "lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry, artist name",
            "width" : 512,
            "height" : 640            
        ]
    ),
    .init(
        owner: "cjwbw",
        name: "stable-diffusion-high-resolution",
        params: ["prompt": "female cyborg assimilated by alien fungus, intricate Three-point lighting portrait, by Ching Yeh and Greg Rutkowski, detailed cyberpunk in the style of GitS 1995"
        ]
    ),
    .init(
        owner: "tstramer",
        name: "classic-anim-diffusion",
        params: ["prompt": "a photo of an astronaut riding a horse on mars"]
    ),
    .init(
        owner: "cjwbw",
        name: "analog-diffusion",
        params: ["prompt": "analog style closeup portrait of cowboy George Washington"
        ]
    ),
    .init(
        owner: "tstramer",
        name: "archer-diffusion",
        params: ["prompt": "archer style, a beautiful cat, highly detailed, 8K"
        ]
    ),
    .init(
        owner: "nitrosocke",
        name: "arcane-diffusion",
        params: ["prompt": "arcane style, a magical princess with golden hair"
        ]
    ),
    .init(
        owner: "nitrosocke",
        name: "redshift-diffusion",
        params: ["prompt": "redshift style magical princess with golden hair"
        ]
    ),
    .init(
        owner: "22-hours",
        name: "vintedois-diffusion",
        params: ["prompt": "victorian city landscape"]
    ),
    .init(
        owner: "tstramer",
        name: "tron-legacy-diffusion",
        params: ["prompt": "city landscape in the style of trnlgcy"]
    ),
    .init(
        owner: "cjwbw",
        name: "van-gogh-diffusion",
        params: ["prompt": "lvngvncnt, beautiful woman at sunset"]
    ),
]
