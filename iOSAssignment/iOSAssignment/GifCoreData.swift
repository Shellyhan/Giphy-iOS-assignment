//
//  GifCoreData.swift
//  iOSAssignment
//
//  Created by Shelly Han on 2017-11-19.
//  Copyright © 2017 ShellyHan. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper


@objc(CoreDataGif)
public class CoreDataGif: NSManagedObject {
    
}

extension CoreDataGif {
    
    @nonobjc public class func CoreFetchRequest() -> NSFetchRequest<CoreDataGif> {
        return NSFetchRequest<CoreDataGif>(entityName: "CoreDataGif");
    }
    
    @NSManaged public var storedGifId: String
//    Acutally using the URL of gif for fast store and fetch,
//    should use gif's ID instead of URL, due to different media used in the giphy response
    
}
