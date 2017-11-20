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
    var id: String!
    var gifUrl: URL!
    var isLiked: Bool!
//   var height : Float!
//   var width : Float!
}

extension Gif: Mappable {

    
   // MARK: JSON to Gif:
    init?(map: Map) {
        mapping(map: map)
        checkCoreData()
    }

    mutating func mapping(map: Map) {
        id <- map[GiphyConstants.Properties.id]
        gifUrl <- (map[GiphyConstants.Properties.gifURL], URLTransform())
//        height <- (map[GiphyConstants.Properties.height], FloatTransform())
//        width <- (map[GiphyConstants.Properties.width], FloatTransform())
    }

//    //Match the core data
    mutating func checkCoreData() {
        //    get the core data:
//        but use the rx core:
        let list: [String] = ["G5X63GrrLjjVK", "RrVzUOXldFe8M", "xT1R9IvpMoVi0xCd7W"]
        
        if list.contains(id) {
            isLiked = true
        } else {
            isLiked = false
        }

    }
}
