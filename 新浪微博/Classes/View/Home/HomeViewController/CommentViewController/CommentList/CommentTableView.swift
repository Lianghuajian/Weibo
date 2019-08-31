//
//  CommentTableView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/9.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

internal let CommentCellID = "CommentCellID"

class CommentTableView: UITableView {
    
    var commentListViewModel : CommentListViewModel?
    {
        didSet
        {
        self.reloadData()
        }
    }
    
    //MARK: - 生命周期
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化空间及布局视图
    func setUpUI()
    {
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView.init()
        self.backgroundColor = .lightGray
        self.register(CommentCell.self, forCellReuseIdentifier: CommentCellID)
    }
    
}
//MARK: - 数据源及代理
extension CommentTableView : UITableViewDelegate,UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return commentListViewModel?.viewModels[indexPath.row].rowHeight ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentListViewModel?.commentCounts ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = commentListViewModel?.viewModels[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCellID, for: indexPath)
        
        (cell as! CommentCell).commentViewModel = vm
        
        return cell
        
    }
    
    
    
}
