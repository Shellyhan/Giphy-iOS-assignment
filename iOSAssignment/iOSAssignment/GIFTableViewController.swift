//
//  GIFTableViewController.swift
//  GIFApp
//
//  Created by Shelly Han on 2017-11-16.
//  Copyright © 2017 ShellyHan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import Moya_ObjectMapper
import NSObject_Rx

final class GIFTableViewController: UIViewController, UITableViewDelegate {

    //MARK: - Public properties
    var viewModel = GifCollectionViewModel(provider: RxMoyaProvider<GiphyEndpoint>())
    
    
    //MARK: - Private properties
    fileprivate let startLoadingOffset: CGFloat = 5.0
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var gifSearchBar: UISearchBar!
    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var gifTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifTableView.allowsSelection = false
        // Sets self as tableview delegate
        gifTableView
            .rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
        setupBindings()
    }
}







//MARK: - Setup
private extension GIFTableViewController {
    func setupBindings() {
        setupViewModel()
        setupKeyboard()
    }
    
    func setupViewModel() {
        
        let searchString = gifSearchBar.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
//        pagination:********************************************************************************************************
        let pageTrigger = gifTableView.rx
            .contentOffset
            .filter {
                [weak self] offset in
                
                // https://github.com/apple/swift-evolution/blob/master/proposals/0079-upgrade-self-from-weak-to-strong.md
                
                guard let strongSelf = self else { return false }
                
                return ((strongSelf.gifTableView.contentOffset.y + strongSelf.gifTableView.frame.size.height) >=
                    (strongSelf.gifTableView.contentSize.height - strongSelf.startLoadingOffset))
                
            }
            .flatMap { _ in return Observable.just() }
        
        viewModel.setUpObservables(pageTrigger: pageTrigger, searchString: searchString)
        // Bind collection view to GIF results now that view model is set up
        setupCollectionView()
    }
    
    //xxxxx rename!!!!
    func setupCollectionView() {
        
        // bind our GIF set to individual collection cells
//        viewModel.gifs
//            .bindTo(gifTableView.rx.items(cellIdentifier: "Tcell", cellType: GIFTableViewCell.self)) {
//                (row, element, cell) in
//                cell.viewModel = element
//            }
//            .addDisposableTo(disposeBag)

        viewModel.gifs
            .bindTo(gifTableView.rx.items) {
                
                (tableView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                    // or some other logic to determine which cell type to create
                    
                let cell = self.gifTableView.dequeueReusableCell(withIdentifier: "Tcell", for: indexPath) as! GIFTableViewCell
                    // Configure the cell
                cell.viewModel = element
                
                //setup the buttons:
                cell.likeButton.rx.tap
                    .subscribe(onNext: {
                        let currentGifIDString = "\(element.gifID)"
                        
                        print("click")
                        print(currentGifIDString)
                        
                        if (element.matchGif(gifIDInput: currentGifIDString)) {
                            // git is liked already, remove it:
                            element.removeExistingGif(withCoreDataGif: currentGifIDString)
                            cell.likeButton.isSelected = false
//                            cell.likeButtonImageView.image = UIImage(named: "00")
                            
                        } else {
                            // like gif and store it:
                            element.addNewGif(withCoreDataGif: currentGifIDString)
                            cell.likeButton.isSelected = true
//                            cell.likeButtonImageView.image = UIImage(named: "01")
                        }
                    })
                    .addDisposableTo(cell.disposeBag)
                
                cell.rx_disposeBag = cell.disposeBag
                
                
                return cell
            }
            .addDisposableTo(disposeBag)
        
        
        // bind our GIF set being empty to displaying the default view
        viewModel.gifs
            .map { gifs in gifs.count != 0 }
            .bindTo(defaultView.rx.isHidden)
            .addDisposableTo(disposeBag)
    }
    
    
    func setupKeyboard() {
        gifTableView
            .rx.itemSelected
            .subscribe(onNext: { indexPath in
                if self.gifSearchBar.isFirstResponder == true {
                    self.view.endEditing(true)
                }
                
                self.gifTableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.blue
            })
            .addDisposableTo(disposeBag)
        
        
    }
}
