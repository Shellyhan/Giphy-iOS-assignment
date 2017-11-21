//
//  GifTableViewModel.swift
//  iOSAssignment
//
//  Created by Shelly Han on 2017-11-18.
//  Copyright © 2017 ShellyHan. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Moya_ObjectMapper

protocol GifTableViewModelProtocol {
      
   /// Sets up observables for the object
   /// - Parameters:
   ///   - pageTrigger: Signals the user has scrolled to the bottom
   ///   - searchString: Search term the user is typing

   func setUpObservables(pageTrigger: Observable<Void>, searchString : Observable<String>)
   
   /// The GIFs received from the network.  Depending on observables, these will either be
   ///   trending or searched GIFs.
   var gifs : Observable<[GifProtocol]>! { get set }
    
}

final class GifTableViewModel : GifTableViewModelProtocol {
   // MARK: Public properties
   var gifs : Observable<[GifProtocol]>!

   // MARK: - Private properties
   fileprivate var networkModel : GiphyNetworkModelProtocol
   
   //MARK: - Initialization
   init(provider: RxMoyaProvider<GiphyEndpoint>) {
      networkModel = GiphyNetworkModel(provider: provider)
   }
    
   func setUpObservables(pageTrigger: Observable<Void>, searchString: Observable<String>) {
      let isSearching = searchString.map { $0.characters.count > 0 }
      let page = pageTrigger.withLatestFrom(isSearching)
      
      networkModel.loadSearchGifsTrigger = page.filter { $0 }.map { _ in () }
      networkModel.loadTrendingGifsTrigger = page.filter { !$0 }.map { _ in () }
      
      setupGifs(isSearching: isSearching, searchText: searchString)
   }
}

// MARK: - Setup
private extension GifTableViewModel {
    
   
//    func setupLikes
   func setupGifs(isSearching: Observable<Bool>, searchText: Observable<String>) {
      let trendingGifs = networkModel.recursivelyLoadGifs([], token: .trending(offset: 0))
      
      let searchGifs = searchText.asObservable().flatMapLatest { [weak self] searchText -> Observable<[Gif]> in
         guard let strongSelf = self else { return Observable.just([]) }

         if searchText.isEmpty {
            return Observable.just([])
         } else {
            return strongSelf.networkModel.recursivelyLoadGifs([], token: .search(searchString: searchText, offset: 0))
         }
      }
      
      gifs = Observable.combineLatest(trendingGifs, searchGifs, isSearching.asObservable()) {
         (trending, searched, isSearching) -> [Gif] in
        
         return isSearching ? searched : trending
         }
         .map { $0.map(GifViewModel.init) }
         .shareReplay(1)
   }
}
