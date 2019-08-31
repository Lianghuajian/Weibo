//
//  CommentCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/9.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
private let cellMargin :CGFloat = 12
protocol clickBlueLinkDelegate : NSObjectProtocol
{
    func didClickURL(url: URL)
}

class CommentCell: UITableViewCell {
    
    var commentViewModel : CommentViewModel?
    {
        didSet
        {
            screenName.setTitle(commentViewModel?.commentModel?.user?.screen_name, for: .normal)
            let text = commentViewModel?.commentModel?.text ?? ""
            
            contentLabel.attributedText = EmoticonsViewModel.shared.emoticonText(string: text, font: contentLabel.font)
            if commentViewModel?.commentModel?.user?.profile_image_url != nil
            {
                let url = URL.init(string: commentViewModel!.commentModel!.user!.profile_image_url!)
                iconImageView.sd_setImage(with: url, completed: nil)
            }
            
            self.layoutIfNeeded()
            
            iconImageView.layer.cornerRadius = iconImageView.bounds.size.width / 2
            
            iconImageView.layer.masksToBounds = true
            
        }
    }
    
    //MARK: - 生命周期
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 初始化控件及布局视图
    func setUpUI() {
        //1.添加控件
        self.contentView.addSubview(screenName)
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(contentLabel)
        //2.自动布局
        self.iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(cellMargin)
            make.top.equalTo(self.contentView.snp.top).offset(cellMargin)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        self.screenName.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.top)
            make.left.equalTo(iconImageView.snp.right).offset(cellMargin)
            make.height.equalTo(20)
        }
        
        self.contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.screenName.snp.bottom)
            make.left.equalTo(self.screenName.snp.left)
            make.right.equalTo(self.contentView.snp.right).offset(-cellMargin)
        }
        
        //3.设置控件
        contentLabel.labelDelegate = self
    }
    
    //MARK: - 懒加载控件
    weak var clickLabelDelegate : clickBlueLinkDelegate?
    
    lazy var screenName : UIButton = {
        let btn = UIButton.init()
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.titleLabel?.textAlignment = .left
        return btn
    }()
    lazy var iconImageView : UIImageView = UIImageView()
    
    lazy var contentLabel : FFLabel = FFLabel.init(size: 15, content: "", color: .black, alignment: .left, lines: 0, breakMode: .byTruncatingTail)
    
}

extension CommentCell : FFLabelDelegate
{
    func labelDidSelectedLinkText(label: FFLabel, text: String)
    {
    if text.hasPrefix("http"){
    //由于我们在微博中点击的链接为短链接(节省资源)，都为httpl开头
        clickLabelDelegate?.didClickURL(url: URL.init(string: text)!)
    }
    }
}

