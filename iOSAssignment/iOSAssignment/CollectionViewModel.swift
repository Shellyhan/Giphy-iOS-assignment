//
//  CollectionViewModel.swift
//  iOSAssignment
//
//  Created by Shelly Han on 2017-11-20.
//  Copyright © 2017 ShellyHan. All rights reserved.
//

import Foundation
import Foundation
import RxSwift
import CoreData


struct GifCollectionViewModel {
    
    private var coreDataGifs = Variable<[CoreDataGif]>([])
    private var coreDataAccessProvider = CoreDataAccessProvider()
    private var disposeBag = DisposeBag()
    
    init() {
        fetchAndUpdateObservableGifs()
    }
    
    public func getCoreDataGifs() -> Variable<[CoreDataGif]> {
        return coreDataGifs
    }
    
    // MARK: - fetching Todos from Core Data and update observable todos
    private func fetchAndUpdateObservableGifs() {
        coreDataAccessProvider.fetchObservableData()
            .map({ $0 })
            .subscribe(onNext : { (theGifs) in
                self.coreDataGifs.value = theGifs
            })
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - remove specified todo from Core Data
    public func removeExistingGif(withCoreDataGif gifIDInput: String) {
        coreDataAccessProvider.removeGif(withCoreDataGif: gifIDInput)
    }
    
}
