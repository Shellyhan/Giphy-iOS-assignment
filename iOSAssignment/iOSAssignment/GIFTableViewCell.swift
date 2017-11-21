//
//  GIFTableViewCell.swift
//  iOSAssignment
//
//  Created by Shelly Han on 2017-11-18.
//  Copyright © 2017 ShellyHan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SnapKit

final class GIFTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    
    //MARK: - Public properties
    var viewModel : GifProtocol? {
        didSet {
            gifImageView.kf.setImage(with: viewModel?.gifURL)
            if (viewModel?.matchGif(gifIDInput: "\(self.viewModel!.gifURL)"))! {
                likeButton.isSelected = true
            } else {
                likeButton.isSelected = false
            }
        }
    }
    
    //MARK: - Private properties
    fileprivate lazy var gifImageView : AnimatedImageView = {
        let animatedImageView = AnimatedImageView()
        animatedImageView.contentMode = .scaleAspectFit
        return animatedImageView
    }()
    
    let likeButton = UIButton()
    
    //MARK: - View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gifImageView.kf.indicatorType = .activity
        contentView.addSubview(gifImageView)
        
    
        likeButton.setImage(UIImage(named: "01"), for: UIControlState.selected)
        likeButton.setImage(UIImage(named: "00"), for: UIControlState.normal)
        contentView.addSubview(likeButton)

         gifImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(150)
            make.width.lessThanOrEqualTo(250)
            make.center.equalTo(self.contentView)
         }
        likeButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(30)
            make.right.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
//        Dispose the cell everytime, to avoide duplicated obervable events
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
}

