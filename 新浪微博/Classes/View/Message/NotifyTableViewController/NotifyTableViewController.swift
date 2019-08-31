//
//  NotifyTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/16.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class NotifyViewController: UIViewController {
    
    let cellID = "NotifyTableViewCellID"
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //        self.tableView.isHidden = true
        self.view.backgroundColor = backColor
        
        self.view.addSubview(label)
        prepareTableView()
        preparePlaceHodlerView()
        prepareRefreshControl()
    }
    lazy var placeHolderView = UIView()
    lazy var tableView = UITableView()
    //MARK: - 控件初始化和布局
    func preparePlaceHodlerView() {
        
        self.tableView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(tableView.snp.centerX)
            make.top.equalTo(tableView.snp.top).offset((self.view.frame.height - label.frame.size.height - self.tabBarController!.tabBar.frame.size.height)/2)
        }
       
        label.isUserInteractionEnabled = false
    }
    func prepareTableView()  {
        
        self.view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom).offset(-self.tabBarController!.tabBar.frame.size.height)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    func prepareRefreshControl()
    {
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: startRefreshing)
        (tableView.mj_header as? MJRefreshStateHeader)?.lastUpdatedTimeLabel.isHidden = true
    }
    @objc func startRefreshing() {
        
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { (_) in
            self.tableView.mj_header.endRefreshing()
        }
    }///中间提示label，注意该Label的布局放到pageViewController中布局
    lazy var label = UILabel.init(size: 18, content: "还没有收到消息哦", color: .lightGray, alignment: .center, lines: 0, breakMode: .byTruncatingTail)
    
}
extension NotifyViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        return cell
    }
    
}
