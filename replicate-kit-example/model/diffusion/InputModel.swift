//
//  StableDiffusion.swift
//  replicate-kit-example
//
//  Created by Igor on 09.03.2023.
//

import replicate_kit_swift
import some_codable_swift

struct InputModel: IModel{
    
    let owner : String
    
    let name : String
    
    let params: [String : SomeEncodable]
}
