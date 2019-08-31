
//
//  CommentTableViewCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/9.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    var commentListViewModel : CommentListViewModel?
    {
        didSet
        {
            tableView.commentListViewModel = commentListViewModel
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
    //MARK: - 初始化空间及布局
    func setUpUI()
    {

        self.contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left)
            make.top.equalTo(self.contentView.snp.top)
            make.width.equalTo(self.contentView.snp.width)
            make.height.equalTo(self.contentView.snp.height)
        }
    }
    
    //MARK: - 成员属性
    lazy var tableView = CommentTableView()
}
