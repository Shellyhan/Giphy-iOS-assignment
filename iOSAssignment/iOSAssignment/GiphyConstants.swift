//
//  GiphyConstants.swift
//  GIFApp
//
//  Created by Alex Vickers on 1/31/17.
//  Copyright © 2017 skciva. All rights reserved.
//

import Foundation

// Docs found: https://github.com/Giphy/GiphyAPI

struct GiphyConstants {
   static let baseURL = "http://api.giphy.com/v1/gifs/"
   static let apiKey = "dc6zaTOxFJmzC"
   static let offset = 25
   
   struct Resources {
      static let search = "search"
      static let trending = "trending"
   }
   
   struct Parameters {
      static let query = "q"
      static let limit = "limit" // default 25, max 100
      static let offset = "offset" // defaults to 0, results offset
      static let apiKey = "api_key"
   }
   
   struct Properties {
      static let id = "id"
      static let gifURL = "images.downsized.url"
//      static let height = "images.downsized.height"
//      static let width = "images.downsized.width"
    
      static let data = "data"
      static let images = "images"
//      static let rendition = "fixed_height"
    
      // these are properties of the overall Giphy request, used to make mapping the individiaul GIFs easier
      struct Meta {
         static let limit = "meta.limit"
         static let offset = "meta.offset"
         static let data = "data"
      }
   }
   
//   struct CellProperties {
//      static let height = 250
//   }
}
