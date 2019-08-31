//
//  MessageTableViewCellTypeTwo.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/16.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

//消息的Cell，带有时间
class MessageTableViewCellTypeTwo: UITableViewCell {
    
    let cellHeight = screenHeight*0.115
    
    let cellMargin = screenWidth*0.04
    
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
        //1,添加控件
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
        self.contentView.addSubview(dateLabel)
        //2,添加约束
        iconImageView.snp.makeConstraints { (make) in
        make.top.equalTo(self.contentView.snp.top).offset(cellHeight*0.125)
        make.left.equalTo(self.contentView.snp.left).offset(cellMargin)
        make.height.equalTo(cellHeight*0.75)
        make.width.equalTo(cellHeight*0.75)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(cellMargin)
        make.left.equalTo(self.iconImageView.snp.right).offset(cellMargin)
            
        }
        detailLabel.snp.makeConstraints { (make) in
        make.top.equalTo(self.titleLabel.snp.bottom).offset(cellMargin/2)
        make.left.equalTo(self.iconImageView.snp.right).offset(cellMargin)
        make.width.equalTo(screenWidth*0.63)
        }
        dateLabel.snp.makeConstraints { (make) in
        make.right.equalTo(self.contentView.snp.right).offset(-cellMargin)
        make.top.equalTo(cellMargin)
        }
    }
    
    //MARK: - 懒加载属性
    ///左侧图标：占据cell高度0.75
    lazy var iconImageView : UIImageView = {
       let iv = UIImageView.init()
        iv.layer.cornerRadius = cellMargin*0.375
        iv.clipsToBounds = true
       return iv
    }()
    ///
    var pictureArr : [String] = ["messagescenter_subscription","messagescenter_messagebox"]
    var titleArr : [String] = ["Subcribe Messages","Stranges' Messages"]
    
    var row : Int? {
        didSet{
           iconImageView.image = UIImage.init(named: pictureArr[row!-3])
           titleLabel.text = titleArr[row!-3]
        }
    }
    
    lazy var titleLabel : UILabel = {
        let label = UILabel.init(size: cellMargin+2, content: "", color: .black, alignment: .left, lines: 1, breakMode: .byTruncatingTail)
        return label
    }()
    
    lazy var detailLabel : UILabel = {
            let label = UILabel.init(size: cellMargin+1, content: "你还记得吗今天是父亲节,快跟父亲问好吧", color: UIColor.init(red: 195.0/255.0, green: 195.0/255.0, blue: 195.0/255.0, alpha: 1), alignment: .left, lines: 1, breakMode: .byTruncatingTail)
            return label
        }()
    lazy var dateLabel : UILabel = {
        let label = UILabel.init(size: cellMargin-2, content: "17:45", color: UIColor.init(red: 195.0/255.0, green: 195.0/255.0, blue: 195.0/255.0, alpha: 1), alignment: .center, lines: 1, breakMode: .byTruncatingTail)
        return label
    }()
}
