//
//  Gif.swift
//  GIFApp
//
//  Created by Alex Vickers on 1/31/17.
//  Copyright © 2017 skciva. All rights reserved.
//

import Foundation
import ObjectMapper


struct Gif {
    var gifUrl: URL!
}

extension Gif: Mappable {

    
   // MARK: JSON to Gif:
    init?(map: Map) {
        mapping(map: map)
    }

    mutating func mapping(map: Map) {
        gifUrl <- (map[GiphyConstants.Properties.gifURL], URLTransform())
    }
}
