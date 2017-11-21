//
//  GIFCollectionViewController.swift
//  iOSAssignment
//
//  Created by Shelly Han on 2017-11-20.
//  Copyright © 2017 ShellyHan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import Moya_ObjectMapper
import NSObject_Rx
import Kingfisher
import SnapKit
import ObjectMapper
import CoreData


final class GIFCollectionViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var gifCollectionView: UICollectionView!
    
    //MARK: - Public properties
    var theStoreGifArray: Variable<[CoreDataGif]> = Variable([])

    var disposeBag = DisposeBag()


    // to trigger the collection view reload after core data changed
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.theStoreGifArray.value = GifCollectionViewModel().getCoreDataGifs().value
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theStoreGifArray.value = GifCollectionViewModel().getCoreDataGifs().value
        
        // Do any additional setup after loading the view.
        gifCollectionView
            .rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
        populateTodoListTableView()
    }
    
    // MARK: - perform a binding from observableTodo from ViewModel to todoListTableView
    private func populateTodoListTableView() {
        
        
        theStoreGifArray.asObservable()
            .bindTo(gifCollectionView.rx.items) {
                (tableView, row, element) in

                let indexPath = IndexPath(row: row, section: 0)
                let cell = self.gifCollectionView.dequeueReusableCell(withReuseIdentifier: "Ccell", for: indexPath)
                let stringURL = element.storedGifId
                let theURL = URL(string: stringURL)
                let cellDisposeBag = DisposeBag()


//                setup the cell view:
                let gifImageView : AnimatedImageView = {
                    let animatedImageView = AnimatedImageView()
                    animatedImageView.contentMode = .scaleAspectFit
                    return animatedImageView
                }()

                let gifButton = UIButton()

                self.setupCellContentView(theURL: theURL!, cellContent: cell.contentView, gifImage: gifImageView, gifButton: gifButton)


//                setup the button delete:
                gifButton.rx.tap
                    .subscribe(onNext: {
//                    remove the selected gif from core data:
                        GifCollectionViewModel().removeExistingGif(withCoreDataGif: stringURL)
                        self.theStoreGifArray.value = GifCollectionViewModel().getCoreDataGifs().value
                    })
                    .addDisposableTo(cellDisposeBag)
                
                cell.rx_disposeBag = cellDisposeBag
            
                return cell
            }
            .addDisposableTo(disposeBag)
        
        
        
        theStoreGifArray.asObservable()
            .map { gifs in gifs.count != 0
            }
            .bindTo(defaultView.rx.isHidden)
            .addDisposableTo(disposeBag)

    }
    
    
    
    func setupCellContentView(theURL: URL, cellContent: UIView, gifImage: UIImageView, gifButton: UIButton) {
        
        let coverView = UIView()
        coverView.backgroundColor = UIColor.white
        
        gifButton.setImage(UIImage(named: "01"), for: UIControlState.normal)
        gifImage.kf.setImage(with: theURL)
        gifImage.kf.indicatorType = .activity
        
        
        cellContent.addSubview(coverView)
        cellContent.addSubview(gifImage)
        cellContent.addSubview(gifButton)
        
        coverView.snp.makeConstraints { (make) -> Void in
            
            make.width.equalTo(180)
            make.height.equalTo(180)
            make.top.equalTo(cellContent)
        }
        
        gifImage.snp.makeConstraints { (make) -> Void in
            
            make.width.equalTo(180)
            make.height.greaterThanOrEqualTo(180)
            make.top.equalTo(cellContent)
        }
        gifButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(30)
            make.right.equalTo(cellContent)
            make.top.equalTo(cellContent)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


