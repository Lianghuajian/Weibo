//
//  ProfileTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/3.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

import SVProgressHUD
let IconTableViewCellID = "IconTableViewCell"
let InfoTableViewCellID = "InfoTableViewCell"
let DetailTableViewCellID = "DetailTableViewCell"
let normalCellID = "normalCellID"
//总共有多少个Cell
let cellConunt = 5

class ProfileViewController: VisitorViewController {
    enum CellID : String{
        case
        IconTableViewCellID = "IconTableViewCell",
        InfoTableViewCellID = "InfoTableViewCell",
        DetailTableViewCellID = "DetailTableViewCell"
    }
    var userAccountViewModel = UserAccountViewModel.shared
    var statusViewModel : StatusViewModel?
    
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        print(userAccountViewModel.accountPath)
        
        if !UserAccountViewModel.shared.userLoginStatus {
            visitorview?.setUpInfo(imagename: "visitordiscover_image_profile", text: "登录后，你的微博，相册，个人资料会显示在这里，展示给别人。")
            
            return
        }
        
        guard let uid = userAccountViewModel.account?.uid else { return  }
    
        NetworkTool.shared.loadUserInfo( uid: uid){ (data, error) in
            if error != nil
            {
                return
            }
            guard let dict = data as? [String : AnyObject] else{
                print("格式错误")
                return
            }
            
            do
            {
                let d = try JSONSerialization.data(withJSONObject: dict, options: [])
                
                let user = try JSONDecoder().decode(User.self, from: d)
                
               guard let status = user.status else
               {
                return
                }
                status.user = user
                self.statusViewModel = StatusViewModel.init(status: status)
            }catch
            {
                
            }
            
        }
        setUpUI()
       
    }
    
    func prepareTableView(){
       
    }
    
    //MARK: - 成员变量
    lazy var tableView : UITableView = UITableView.init()
    lazy var refreshButton : UIButton = {
        let button = UIButton.init(text: "更新用户", textColor: .blue, backImage: nil, isBack: false)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    lazy var logoutButton : UIButton =  {
        let button = UIButton.init(text: "退出", textColor: .red, backImage: nil, isBack: false)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    var spaView1 : UIView = {
        let spaView = UIView()
        spaView.backgroundColor = spaColor
        return spaView
    }()
    var spaView2 : UIView = {
        let spaView = UIView()
        spaView.backgroundColor = spaColor
        return spaView
    }()
}

extension ProfileViewController : UITableViewDelegate,UITableViewDataSource
{
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellConunt
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return screenHeight*0.157
        case 1:
            return screenHeight*0.093
        case 2:
            return screenWidth * 0.5 + screenHeight*0.017 // 加上条
        default :
            return 44+spaHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: CellID.IconTableViewCellID.rawValue)
            (cell as! IconTableViewCell).viewModel = userAccountViewModel
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: CellID.InfoTableViewCellID.rawValue)
            (cell as! InfoTableViewCell).viewModel = userAccountViewModel
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: CellID.DetailTableViewCellID.rawValue)
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: normalCellID)
            cell.contentView.addSubview(spaView1)
            spaView1.snp.makeConstraints { (make) in
                make.top.equalTo(cell.contentView.snp.top)
                make.left.equalTo(cell.contentView.snp.left)
                make.width.equalTo(screenWidth)
                make.height.equalTo(spaHeight)
            }
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: screenWidth)
            cell.contentView.addSubview(refreshButton)
            refreshButton.snp.makeConstraints { (make) in
                make.centerX.equalTo(cell.contentView.snp.centerX)
                make.centerY.equalTo(spaView1.snp.bottom).offset(22)
            }
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: normalCellID)
            cell.contentView.addSubview(spaView2)
            spaView2.snp.makeConstraints { (make) in
                make.top.equalTo(cell.contentView.snp.top)
                make.left.equalTo(cell.contentView.snp.left)
                make.width.equalTo(screenWidth)
                make.height.equalTo(spaHeight)
            }
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: screenWidth)
            cell.contentView.addSubview(logoutButton)
            logoutButton.snp.makeConstraints { (make) in
                make.centerX.equalTo(cell.contentView.snp.centerX)
                make.centerY.equalTo(spaView2.snp.bottom).offset(22)
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: normalCellID)
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0...1:
            if statusViewModel == nil
            {
                SVProgressHUD.showInfo(withStatus: "网速不太好哦")
                break
            }
            let vc = UserDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.statusViewModel = statusViewModel
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break;
        }
    }
}

//MARK: - 布局视图
extension ProfileViewController {
    func setUpUI(){
     
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            
            make.right.equalTo(self.view.snp.right)
            
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = spaColor
        tableView.register(IconTableViewCell.self, forCellReuseIdentifier:IconTableViewCellID)
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier:InfoTableViewCellID)
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier:DetailTableViewCellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: normalCellID)
        
        refreshButton.addTarget(self, action: #selector(refresh) , for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        
    }
    
    //MARK: - 按钮监听方法
    ///刷新用户数据
    @objc func refresh(){
        guard let uid = UserAccountViewModel.shared.account?.uid else {
            return
        }
        UserAccountViewModel.shared.loadUserInfo(uid:uid) { (status) in
            if status{
                print("用户更改信息后刷新数据成功")
            }
        }
    }
    ///退出登陆
    @objc func logout(){
        //UserAccountViewModel.
        //        FileManager.default.file
        //        if FileManager.default.fileExists(atPath: UserAccountViewModel.shared.accountPath.absoluteString)
        //        {
        do{
            //1,删除用户数据
            try FileManager.default.removeItem(at: UserAccountViewModel.shared.accountPath)
            print("清除用户数据成功")
            //2,更新UserAccountViewModel.shared
            UserAccountViewModel.upDateUserAccount()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBSwitchVCControllerNotification), object: nil)
        }catch
        {
            print("清除用户数据失败\(error)")
        }
    }
}
