//
//  MessageTableViewCellTypeOne.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/16.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
/*
 *tableView前三行的cell，固定存在
 */
private let cellHeight = screenHeight*0.115

private let cellMargin = screenWidth*0.04

class MessageTableViewCellTypeOne: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    //MARK: - 准备控件
    func setUpUI(){
        self.accessoryType = .disclosureIndicator
        //1,添加控件
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(titleLabel)
        //2,添加布局
        iconImageView.snp.makeConstraints { (make) in
        make.top.equalTo(self.contentView.snp.top).offset(cellHeight*0.125)
            make.left.equalTo(self.contentView.snp.left).offset(cellMargin)
            make.height.equalTo(cellHeight*0.75)
            make.width.equalTo(cellHeight*0.75)
        }
        titleLabel.snp.makeConstraints { (make) in
        make.top.equalTo(self.contentView.snp.top).offset(cellHeight*0.3)
        make.left.equalTo(self.iconImageView.snp.right).offset(cellMargin)
        }
    }
    
    //MARK: - 懒加载属性
    ///左侧图标：占据cell高度0.75
    lazy var iconImageView : UIImageView = {
        let iv = UIImageView.init()
        iv.backgroundColor = UIColor.randomColor
        iv.layer.cornerRadius = cellHeight*0.375
        iv.clipsToBounds = true
        return iv
    }()
    ///图片数组
    lazy var pictureArr : [String] = {
        let arr = ["messagescenter_at","messagescenter_comments","messagescenter_good"]
        return arr
    }()
    lazy var titleArr : [String] =
        {
            let arr = ["Mentions","Comments","Likes"]
            return arr
    }()
    ///cell所在行数
    var row : Int?{
        didSet{
            iconImageView.image = UIImage.init(named: pictureArr[row!])
            titleLabel.text = titleArr[row!]
        }
    }
    ///
    lazy var titleLabel : UILabel = {
        let label = UILabel.init(size: cellMargin+2, content: "Comments", color: .black, alignment: .center, lines: 1, breakMode: .byTruncatingTail)
        return label
    }()
    

}
