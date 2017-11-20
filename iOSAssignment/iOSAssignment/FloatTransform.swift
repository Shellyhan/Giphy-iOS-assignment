//
//  FloatTransform.swift
//  GIFApp
//
//  Created by Alex Vickers on 1/31/17.
//  Copyright © 2017 skciva. All rights reserved.
//

import Foundation
import ObjectMapper

// Sometimes GIPHY returns floats as strings in JSON..
struct FloatTransform : TransformType {
   func transformFromJSON(_ value: Any?) -> Float? {
      if let float = value as? Float { return float }
      if let string = value as? String { return Float(string) }
      return nil
   }
   
   func transformToJSON(_ value: Float?) -> String? {
      return String(describing: value)
   }
}
