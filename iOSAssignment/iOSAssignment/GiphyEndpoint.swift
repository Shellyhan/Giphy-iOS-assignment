//
//  GiphyEndpoint.swift
//  GIFApp
//
//  Created by Alex Vickers on 1/31/17.
//  Copyright © 2017 skciva. All rights reserved.
//

import Foundation
import Moya

private extension String {
   
   // lowercase the string, then replace spaces with + for GIPHY search terms
   var URLEscapedSearchString: String {
      return self.lowercased().replacingOccurrences(of: " ", with: "+")
   }
}


enum GiphyEndpoint {
   case search(searchString: String, offset: Int)
   case trending(offset: Int)
}

extension GiphyEndpoint: TargetType {
   var baseURL: URL { return URL(string: GiphyConstants.baseURL)! }
   
   var path : String {
      switch self {
      case .search:
         return GiphyConstants.Resources.search
      case .trending:
         return GiphyConstants.Resources.trending
      }
   }
   
   var method: Moya.Method {
      return .get
   }
   
   var parameters: [String : Any]? {
      var parameters = [String:Any]()

      switch self {
      case .search(let searchString, let offset):
         parameters = [
            GiphyConstants.Parameters.apiKey : GiphyConstants.apiKey,
            GiphyConstants.Parameters.query : searchString.URLEscapedSearchString,
            GiphyConstants.Parameters.offset : offset
         ]
      case .trending(let offset):
         parameters = [
            GiphyConstants.Parameters.apiKey : GiphyConstants.apiKey,
            GiphyConstants.Parameters.offset : offset
         ]
      }
      
      print(parameters)
            
      return parameters
   }
   
   var task : Task {
      return .request
   }
   
   
   var parameterEncoding: ParameterEncoding {
      return URLEncoding.default
   }
 
   // used to conform to TargetType protocol, not using currently
   var sampleData: Data {
    //    switch self {
    //    case .search(let searchString, let offset):
    //        return "{}".data(using: .utf8)!
    //    case .trending(let offset):
    //        return "{}".data(using: .utf8)!
    //    }
      return Data()
   }
   
}
