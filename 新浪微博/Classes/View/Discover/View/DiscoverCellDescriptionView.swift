//
//  DiscoverCellDescriptionView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/8/26.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class DiscoverCellDescriptionView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    func setUpUI() {
        self.addSubview(titleLabel)
        self.addSubview(viewCountsLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(DiscoverCellMargins)
            make.top.equalTo(self.snp.top).offset(DiscoverCellMargins)
            make.height.equalTo(16)
            make.width.equalTo(screenWidth-DiscoverCellMargins*2)
        }
        viewCountsLabel.font = UIFont.systemFont(ofSize: 13)
        viewCountsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(DiscoverCellMargins)
            make.height.equalTo(13)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var videoModel : VideoModel?
    {
        didSet{
            titleLabel.text = videoModel?.title
            viewCountsLabel.text = videoModel?.play_count == nil ? "0 views" : videoModel!.play_count! + " views"
        }
    }
    lazy var titleLabel = UILabel()
    lazy var viewCountsLabel = UILabel()
}
