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
