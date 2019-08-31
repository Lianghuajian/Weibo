//
//  DiscoverTableViewCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/8/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
class DiscoverTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI()
    {
        self.selectionStyle = .none
        self.contentView.addSubview(coverImageView)
        self.coverImageView.addSubview(playButton)
        self.contentView.addSubview(topView)
        self.contentView.addSubview(bottomView)
        self.contentView.addSubview(descriptionView)
        let sepView = UIView()
        self.contentView.addSubview(sepView)
        sepView.backgroundColor = backColor
        sepView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top)
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.height.equalTo(DiscoverCellMargins)
        }
        
        self.topView.snp.makeConstraints { (make) in
        make.top.equalTo(sepView.snp.bottom)
        make.left.equalTo(self.contentView.snp.left)
        make.right.equalTo(self.contentView.snp.right)
        make.height.equalTo(CellIconWidth+2*DiscoverCellMargins)
        }
        
        self.coverImageView.isUserInteractionEnabled = true
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.backgroundColor = .black
        playButton.setImage(UIImage.init(named: "video_play_btn_bg"), for: .normal)
        playButton.addTarget(self, action: #selector(startPlayVideo), for: .touchUpInside)
        
        playButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.coverImageView.snp.center)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        descriptionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bottomView.snp.top)
            make.left.equalTo(self.contentView.snp.left)
            make.width.equalTo(screenWidth)
            make.height.equalTo(descriptionView.titleLabel.font.pointSize + descriptionView.viewCountsLabel.font.pointSize + DiscoverCellMargins * 3)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.bottom.equalTo(self.contentView.snp.bottom)
            //手指点击宽度
            make.height.equalTo(CellIconWidth)
        }
        
        coverImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left)
            make.top.equalTo(self.topView.snp.bottom)
            make.bottom.equalTo(self.descriptionView.snp.top)
            make.width.equalTo(self.contentView.snp.width)
        }
        
    }
    var videoModel : VideoModel?
    {
        didSet
        {
            coverImageView.sd_setImage(with: URL.init(string: videoModel!.cover_url ?? ""), completed: nil)
            topView.videoModel = videoModel
            descriptionView.videoModel = videoModel
        }
    }
   
    var clickBlock : ((UIImageView?,VideoModel?)->Void)?
    
    lazy var coverImageView = UIImageView()
    lazy var playButton = UIButton()
    lazy var topView = DiscoverCellTopView()
    lazy var bottomView = DiscoverCellBottomView()
    lazy var descriptionView = DiscoverCellDescriptionView()
    @objc func startPlayVideo() {
        
        if (clickBlock != nil) {
            clickBlock!(coverImageView,videoModel)
        }
    }
}

