//
//  CoreDataAccessProvider.swift
//  iOSAssignment
//
//  Created by Shelly Han on 2017-11-19.
//  Copyright © 2017 ShellyHan. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class CoreDataAccessProvider {
    
    private var gifsFromCoreData = Variable<[CoreDataGif]>([])
    
    private var managedObjectContext : NSManagedObjectContext
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        managedObjectContext = delegate.persistentContainer.viewContext
        
        gifsFromCoreData.value = fetchData()

    }
    
    // MARK: - fetching gifs from Core Data and update observable gifs
    private func fetchData() -> [CoreDataGif] {
//        let gifFetchRequest = CoreDataGif.CoreFetchRequest()
        
        let gifFetchRequest = NSFetchRequest<CoreDataGif>(entityName: "CoreDataGif");
        
        gifFetchRequest.returnsObjectsAsFaults = false
        
        do {
            return try managedObjectContext.fetch(gifFetchRequest)
        } catch {
            return []
        }
        
    }
    
    // MARK: - return observable gif
    public func fetchObservableData() -> Observable<[CoreDataGif]> {
        gifsFromCoreData.value = fetchData()
        return gifsFromCoreData.asObservable()
    }

    
    public func checkGif(thisGifId: String) -> Bool {
    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataGif")
        let predicate = NSPredicate(format: "storedGifId == %@", thisGifId)
        fetchRequest.predicate = predicate
        
        let result = try? managedObjectContext.fetch(fetchRequest)
        return (result?.count != 0)
    }
    
    // MARK: - add new gif from Core Data
    public func addGif(withCoreDataGif gifIDInput: String) {
        let newGif = NSEntityDescription.insertNewObject(forEntityName: "CoreDataGif", into: managedObjectContext) as! CoreDataGif
        
        newGif.storedGifId = gifIDInput

        
        do {
            try managedObjectContext.save()
            gifsFromCoreData.value = fetchData()
        } catch {
            fatalError("error saving data")
        }
    }
    
    // MARK: - remove specified gif from Core Data
    public func removeGif(withCoreDataGif gifIDInput: String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataGif")
        let predicate = NSPredicate(format: "storedGifId == %@", gifIDInput)
        fetchRequest.predicate = predicate

        let result = try? managedObjectContext.fetch(fetchRequest)
        
        managedObjectContext.delete(result!.first as! NSManagedObject)
        
        do {
            try managedObjectContext.save()
            gifsFromCoreData.value = fetchData()
        } catch {
            fatalError("error delete data")
        }
    }
    
}
