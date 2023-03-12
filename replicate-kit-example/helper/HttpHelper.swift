//
//  HttpHelper.swift
//  replicate-kit-example
//
//  Created by Igor on 11.03.2023.
//

import Foundation

/// Validate result by the status code
/// - Parameter result: Result from Get request
/// - Throws: Status code is not valid
/// - Returns: Data
func validate(_ result : (data : Data, response: URLResponse)) throws -> Data {
    let response = result.response
    switch (response as? HTTPURLResponse)?.statusCode {
        case (200..<300)?: return result.data
        default: throw ReplicateClient.Errors.invalidImageResponse(response)
        }
}
