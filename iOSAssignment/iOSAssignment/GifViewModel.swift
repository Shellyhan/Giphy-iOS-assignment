//
//  GifViewModel.swift
//  iOSAssignment
//
//  Created by Shelly Han on 2017-11-18.
//  Copyright © 2017 ShellyHan. All rights reserved.
//


import Foundation
import RxSwift
import CoreData

protocol GifProtocol {
    
    // ########################## MARK: Outputs ##########################
    var gifURL : URL { get }
    
    //for the core data operation
    func getStoredGifs() -> Variable<[CoreDataGif]>
    func addNewGif(withCoreDataGif gifIDInput: String)
    func removeExistingGif(withCoreDataGif gifIDInput: String)
    func matchGif(gifIDInput: String) -> Bool
}

final class GifViewModel : GifProtocol {

    //MARK: - Private properties
    private var gif: Gif!
    
    var storedGifs = Variable<[CoreDataGif]>([])
    var coreDataAccessProvider = CoreDataAccessProvider()
    var disposeBag = DisposeBag()
    
    
    //MARK: - Public properties
    var gifURL : URL {
        return gif.gifUrl
    }

    //MARK: - Initialization
    init(gif: Gif) {
        self.gif = gif
        fetchStoredGifsAndUpdateObservableGifs()
    }

    public func getStoredGifs() -> Variable<[CoreDataGif]> {
        return storedGifs
    }
    // MARK: - fetching gifs from Core Data and update observable gifs
    public func fetchStoredGifsAndUpdateObservableGifs() {
        coreDataAccessProvider.fetchObservableData()
            .map({ $0 })
            .subscribe(onNext : { (theGifs) in
                self.storedGifs.value = theGifs
            })
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - add new gif from Core Data
    public func addNewGif(withCoreDataGif gifIDInput: String) {
        coreDataAccessProvider.addGif(withCoreDataGif: gifIDInput)
    }
    
    // MARK: - remove specified gif from Core Data
    public func removeExistingGif(withCoreDataGif gifIDInput: String) {
        coreDataAccessProvider.removeGif(withCoreDataGif: gifIDInput)
    }

    public func matchGif(gifIDInput: String) -> Bool {
        return coreDataAccessProvider.checkGif(thisGifId: gifIDInput)
    }

}
