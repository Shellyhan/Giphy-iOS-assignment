//
//  GIFTableViewController.swift
//  iOSAssignment
//
//  Created by Shelly Han on 2017-11-18.
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
    var viewModel = GifTableViewModel(provider: RxMoyaProvider<GiphyEndpoint>())
    
    var okToScroll = false
    
    
    //MARK: - Private properties
    fileprivate let startLoadingOffset: CGFloat = 5.0
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var gifSearchBar: UISearchBar!
    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var gifTableView: UITableView!
    
    
// to trigger the table view reload after core data changed:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if okToScroll {
            let newIndexPath = IndexPath(row: 6, section: 0)
            self.gifTableView.scrollToRow(at: newIndexPath, at: .none, animated: false)
        }
    }

    
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
        // Bind tableview to GIF results now that view model is set up
        setupTableView()
    }
    

    func setupTableView() {
        
        // bind our GIF set to individual tableview cells
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
                        let currentGifIDString = "\(element.gifURL)"
                        
//                        print("------click-------")
//                        print(currentGifIDString)
//                        print("-----------------")
                        
                        if (element.matchGif(gifIDInput: currentGifIDString)) {
                            // gif is liked already, remove it:
                            element.removeExistingGif(withCoreDataGif: currentGifIDString)
                            cell.likeButton.isSelected = false
                            
                        } else {
                            // like gif and store it:
                            element.addNewGif(withCoreDataGif: currentGifIDString)
                            cell.likeButton.isSelected = true
                        }
                    })
                    .addDisposableTo(cell.disposeBag)
                
                cell.rx_disposeBag = cell.disposeBag
                
                
                return cell
            }
            .addDisposableTo(disposeBag)
        
        
        // bind our GIF set being empty to displaying the default view
        viewModel.gifs
            .map { gifs in
                self.okToScroll = true
                return gifs.count != 0
            }
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
            })
            .addDisposableTo(disposeBag)
        
        
    }
}
