//
//  MessageTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/16.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

//let TypeOnecellID = "TypeOnecellID"
//let TypeTwocellID = "TypeTwocellID"
class MessageTableViewController: UIViewController {
    enum CellID : String{
        case TypeOneCellID = "TypeOneCellID",TypeTwoCellID = "TypeTwoCellID"
    }
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        prepareRefreshControl()
        prepareSearchBar()
    }
    //MARK: - 准备控件
    func prepareRefreshControl()
    {
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: startRefreshing)
        (tableView.mj_header as? MJRefreshStateHeader)?.lastUpdatedTimeLabel.isHidden = true
    }
    @objc func startRefreshing() {
        
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { (_) in
            self.tableView.mj_header.endRefreshing()
        }
    }
    func prepareSearchBar() {
//        topSearchBar.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
        
        topSearchBar.delegate = self
//        topSearchBar.showsCancelButton
//        topSearchBar.value(forKeyPath: "cancelButton")
//        let button : UIButton = topSearchBar.value(forKey:"cancelButton") as! UIButton
//
//        button.setTitle("cancel", for: .normal)
//
//        topSearchBar.setValue(button, forKey: "cancelButton")
        
        //        var count : UInt32 = 0
        //        let propertylist = class_copyPropertyList(UISearchBar.self, &count)
//        for i in 0..<count {
//            let char_b = property_getName(propertylist![Int(i)])
//            if let key = String.init(cString: char_b, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as String?{
//                               print(key)
//                }
//        }
        
    }
    func prepareTableView(){
        
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: self.view.frame.height - tabBarController!.tabBar.frame.height)

        self.tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.always
        //把多余的cell去掉
        self.tableView.tableHeaderView = topSearchBar
  
        self.tableView.estimatedSectionFooterHeight = 0

        self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 46))
        self.tableView.backgroundColor = backColor
        self.tableView.rowHeight = screenHeight*0.115
        self.tableView.register(MessageTableViewCellTypeOne.self, forCellReuseIdentifier: CellID.TypeOneCellID.rawValue)
        self.tableView.register(MessageTableViewCellTypeTwo.self, forCellReuseIdentifier: CellID.TypeTwoCellID.rawValue)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
    }
   
    //MARK: - 懒加载属性
    lazy var topSearchBar : LHJSearchBar = {
        let sb = LHJSearchBar.init(frame:CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight*0.08)
            , placeHolder: "Search", leftImage: nil, showsCancelButton: false, tintColor: .clear)
        sb.backgroundColor = backColor
        return sb
    }()
    
    lazy var tableView = UITableView.init(frame: CGRect.zero, style: .plain)
    
    lazy var placeHolderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancelEditingSearchBar(topSearchBar)
    }
}

extension MessageTableViewController :UITableViewDataSource,UITableViewDelegate
{
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        switch indexPath.row {
        case 0...2:
            cell = tableView.dequeueReusableCell(withIdentifier:CellID.TypeOneCellID.rawValue , for: indexPath)
            (cell as! MessageTableViewCellTypeOne).row = indexPath.row
        default:
            cell = tableView.dequeueReusableCell(withIdentifier:CellID.TypeTwoCellID.rawValue , for: indexPath)
            (cell as! MessageTableViewCellTypeTwo).row = indexPath.row
        }
        return cell
    }
    
}
extension MessageTableViewController : UISearchBarDelegate
{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let vc = SearchBarViewController()
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true) {
            
        }
        vc.searchBar.becomeFirstResponder()
        //我们这里返回false，使用另一个viewController去处理查询，这样就不会弹出键盘了
        return false
    }
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//    // 设置取消按钮
//    UIView.animate(withDuration: 0.4) {
//        searchBar.showsCancelButton = true
//
//        for v in searchBar.subviews {
//
//            for _v in v.subviews {
//
//                if let _cls = NSClassFromString("UINavigationButton") {
//
//                    if _v.isKind(of: _cls) {
//                        guard let btn = _v as? UIButton else { return }
//
//                        btn.setTitle("取消", for: .normal)
//                        btn.setTitleColor(UIColor.white, for: .normal)
//                        return
//                    }
//                }
//
//            }
//
//        }
//    }
//    }
    
    
    fileprivate func cancelEditingSearchBar(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
     cancelEditingSearchBar(searchBar)
    }
}
