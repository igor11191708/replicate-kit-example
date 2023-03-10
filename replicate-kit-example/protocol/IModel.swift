//
//  ModelItem.swift
//  replicate-kit-example
//
//  Created by Igor on 09.03.2023.
//

import Foundation
import replicate_kit_swift
import some_codable_swift

protocol IModel: Encodable, Hashable{
    
    var owner : String { get }
    
    var name : String { get }
    
    var params: [String : SomeEncodable] { get }
}

