//
//  ImageHelper.swift
//  replicate-kit-example
//
//  Created by Igor on 11.03.2023.
//

import SwiftUI

// MARK: - File private

#if os(iOS) || os(watchOS) || os(tvOS)
    /// - Parameter data: Data
    /// - Returns: Image based on UIImage
    func image(from data: Data?) throws -> Image {

        if let data, let image = UIImage(data: data){
            return Image(uiImage: image)
        }
        
        throw ReplicateClient.Errors.imageInit
    }
#endif
    
#if os(macOS)
    /// - Parameter data: Data
    /// - Returns: Image based on NSImage
    func image(from data: Data?) throws -> Image {
        
        if let data, let image = NSImage(data: data){
            return Image(nsImage: image)
        }
        
        throw ReplicateClient.Errors.imageInit
    }
#endif
