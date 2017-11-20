//
//  GiphyResponse.swift
//  GIFApp
//
//  Created by Alex Vickers on 1/31/17.
//  Copyright © 2017 skciva. All rights reserved.
//

import Foundation
import ObjectMapper

struct GiphyResponse : Mappable {
   var limit: Int = 25
   var offset: Int = 0
   var gifs: [Gif]!
   
   // MARK: JSON
   init?(map: Map) {
      mapping(map: map)
   }
    
   mutating func mapping(map: Map) {
      limit <- map[GiphyConstants.Properties.Meta.limit]
      offset <- map[GiphyConstants.Properties.Meta.offset]
      gifs <- map[GiphyConstants.Properties.Meta.data]
   }
}
