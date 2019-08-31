//
//  UserStatusTableView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/11.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

private let PlaceHolderCellID = "PlaceHolderCellID"

protocol ScrollViewDelegate : NSObjectProtocol
{
    func tableViewDidScroll(offSet:CGPoint)
}
class UserStatusTableView: UITableView {
    weak var naviController: UINavigationController?
    //MARK: - 生命周期
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化控件和布局控件
    func setUpUI()
    {
        self.delegate = self
        self.dataSource = self
        self.register(RetweetedStatusCell.self, forCellReuseIdentifier: RetweetedStatusCellID)
        self.register(OriginStatusCell.self, forCellReuseIdentifier: OriginStatusCellID)
        self.register(UITableViewCell.self, forCellReuseIdentifier: PlaceHolderCellID)
       
        self.estimatedRowHeight = 400
        self.tableFooterView = UIView()
    }
    
    var scrollDelegate : ScrollViewDelegate?
    
    var statusViewModel : StatusViewModel?
    {
        didSet
        {
            self.reloadData()
        }
    }
    
    deinit {
        listViewDidScrollCallback = nil
    }
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    var lastSelectedIndexPath: IndexPath?
    
}

extension UserStatusTableView : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return statusViewModel?.rowHeight ?? 400
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: statusViewModel!.cellID, for: indexPath)
        (cell as! StatusCell).viewModel = statusViewModel
        
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}

extension UserStatusTableView : JXPagingViewListViewDelegate
{
    func listView() -> UIView {
        return self
    }
    
    func listScrollView() -> UIScrollView {
        return self
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
}
