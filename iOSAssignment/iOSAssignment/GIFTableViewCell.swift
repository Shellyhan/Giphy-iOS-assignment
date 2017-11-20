//
//  GIFTableViewCell.swift
//  GIFApp
//
//  Created by Shelly Han on 2017-11-16.
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
            if (viewModel?.matchGif(gifIDInput: "\(self.viewModel!.gifID)"))! {
                likeButton.isSelected = true
//                likeButtonImageView.image = UIImage(named: "01")
            } else {
                likeButton.isSelected = false
//                likeButtonImageView.image = UIImage(named: "00")
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
    let likeButtonImageView = UIImageView()
    
    //MARK: - View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.isUserInteractionEnabled = false
//        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        gifImageView.kf.indicatorType = .activity
        contentView.addSubview(gifImageView)
    
        likeButton.setImage(UIImage(named: "01"), for: UIControlState.selected)
        likeButton.setImage(UIImage(named: "00"), for: UIControlState.normal)
        contentView.addSubview(likeButton)
//        likeButton.addSubview(likeButtonImageView)

         gifImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(150)
            make.width.lessThanOrEqualTo(250)
            make.center.equalTo(self.contentView)
         }
        likeButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(30)
            make.left.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
        }
//        likeButton.snp.makeConstraints { (make) -> Void in
//            make.height.equalTo(self.contentView)
//            make.width.equalTo(self.contentView)
//            make.left.equalTo(self.contentView)
//            make.top.equalTo(self.contentView)
//        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)

        // Configure the view for the selected state
//        do nothing???
    }
    
    override func prepareForReuse() {
        
        // does nothing, but recommended to call anyway..
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
}

