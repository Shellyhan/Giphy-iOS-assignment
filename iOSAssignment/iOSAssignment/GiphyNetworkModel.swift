//
//  GiphyNetworkModel.swift
//  GIFApp
//
//  Created by Alex Vickers on 1/31/17.
//  Copyright © 2017 skciva. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Moya_ObjectMapper

protocol GiphyNetworkModelProtocol {
   var loadTrendingGifsTrigger: Observable<Void>! { get set }
   var loadSearchGifsTrigger: Observable<Void>! { get set }
   
//    Pagination of gif loading:
   func recursivelyLoadGifs(_ loadedGifs: [Gif], token: GiphyEndpoint) -> Observable<[Gif]>
   
}


final class GiphyNetworkModel : GiphyNetworkModelProtocol {
   
   // MARK: - Public properties
   var loadTrendingGifsTrigger: Observable<Void>!
   var loadSearchGifsTrigger: Observable<Void>!
   
   // MARK: - Private properties
   fileprivate let provider : RxMoyaProvider<GiphyEndpoint>
   
   // MARK: - Initialization
   init(provider: RxMoyaProvider<GiphyEndpoint>) {
      self.provider = provider
   }
}

extension GiphyNetworkModel {
   
   func recursivelyLoadGifs(_ loadedGifs: [Gif], token: GiphyEndpoint) -> Observable<[Gif]> {
      
      // request another page of GIFs, whether searched or trending
      return fetch(token).flatMap { [weak self] gifs -> Observable<[Gif]> in
         
         guard let strongSelf = self else { return Observable.just([]) }

         var totalGifs = loadedGifs
         
         totalGifs.append(contentsOf: gifs)
         
         var triggerObservable : Observable<Void>
         var endpointToken : GiphyEndpoint
         
         
         switch token {
         case let .trending(offset):
            triggerObservable = strongSelf.loadTrendingGifsTrigger
            endpointToken = GiphyEndpoint.trending(offset: (offset + GiphyConstants.offset))
            
         case let .search(searchString, offset):
            triggerObservable = strongSelf.loadSearchGifsTrigger
            endpointToken = GiphyEndpoint.search(searchString: searchString, offset: (offset + GiphyConstants.offset))
         }
         
         
         return Observable.concat([
            // return loaded immediately
            Observable.just(totalGifs),
            
            // wait until next page can load
            Observable.never().takeUntil(triggerObservable),
            
            //load next page
            strongSelf.recursivelyLoadGifs(totalGifs, token: endpointToken)
         ])
         
      }
   }
   
   private func fetch(_ token: GiphyEndpoint) -> Observable<[Gif]> {

      return self.provider.request(token)
         .observeOn(SerialDispatchQueueScheduler(qos: .background))
         .filterSuccessfulStatusCodes()
         .retry(3)
         .mapObject(GiphyResponse.self)
         .map { res in
            return res.gifs!
         }
         .catchError { _ in
            return Observable.empty()
         }
   }
}
