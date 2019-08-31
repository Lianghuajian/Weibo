//
//  DiscoverCellTopView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/8/26.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
let DiscoverCellMargins : CGFloat = 12
class DiscoverCellTopView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        let topLayoutGuide = UILayoutGuide()
        let leftLayoutGuide = UILayoutGuide()
        let rightLayoutGuide = UILayoutGuide()
        self.addLayoutGuide(topLayoutGuide)
        self.addLayoutGuide(rightLayoutGuide)
        self.addLayoutGuide(leftLayoutGuide)
        topLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLayoutGuide.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topLayoutGuide.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        topLayoutGuide.heightAnchor.constraint(equalToConstant: DiscoverCellMargins).isActive = true
        
        leftLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        leftLayoutGuide.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        leftLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        leftLayoutGuide.widthAnchor.constraint(equalToConstant: DiscoverCellMargins).isActive = true
        
        rightLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        rightLayoutGuide.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        rightLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        rightLayoutGuide.widthAnchor.constraint(equalToConstant: DiscoverCellMargins).isActive = true
        
        
        self.addSubview(iconImageView)
        self.addSubview(nameLabel)
        iconImageView.isUserInteractionEnabled = true
        iconImageView.layer.cornerRadius = CellIconWidth*0.5
        iconImageView.layer.masksToBounds = true
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.equalTo(leftLayoutGuide.snp.right)
            make.width.equalTo(CellIconWidth)
            make.height.equalTo(CellIconWidth)
        }
        
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 1;
        nameLabel.textAlignment = .left
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImageView.snp.top)
make.left.equalTo(self.iconImageView.snp.right).offset(DiscoverCellMargins)
            make.width.equalTo(screenWidth*0.4)
            make.height.equalTo(0.4*CellIconWidth)
        }
    }
    
    var videoModel : VideoModel?
    {
        didSet
        {
            self.iconImageView.sd_setImage(with: URL.init(string: videoModel!.avatar_thumb!), completed: nil)
            self.nameLabel.text = videoModel?.nickname
        }
        
    }
    
    lazy var iconImageView = UIImageView()
    
    lazy var nameLabel = UILabel()
    
}
