//
//  HttpHelper.swift
//  replicate-kit-example
//
//  Created by Igor on 11.03.2023.
//

import Foundation


func validate(_ response : URLResponse, and data : Data) throws -> Data {
    switch (response as? HTTPURLResponse)?.statusCode {
        case (200..<300)?: return data
    default: throw ReplicateClient.Errors.invalidImageResponse(response)
    }
}
