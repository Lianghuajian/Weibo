//
//  StatusTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/27.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SVProgressHUD

let OriginStatusCellID = "OriginStatusCellID"
let RetweetedStatusCellID = "RetweetedStatusCellID"

class StatusTableViewController: VisitorViewController {
    
    
    //MARK: - 生命周期
    override func viewWillAppear(_ animated: Bool) {
        //键盘高度改变的通知
        super.viewWillAppear(animated); NotificationCenter.default.addObserver(self, selector: #selector(HomeTVCKeyBoardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if !UserAccountViewModel.shared.userLoginStatus {
            self.navigationItem.title = "消息"
            visitorview?.setUpInfo(imagename: "visitordiscover_image_message", text: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知。")
            return
        }
        //没有登录才去设置
        prepareTableView()
        
        prepareCommentKeyBoardView()
        
        //prepareFPSLabel()
        //测试帧数
        //接受通知
        prepareNotification()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated); NotificationCenter.default.removeObserver(self)
    }
    //MARK: - 控件初始化和布局
    func prepareNotification()
    {
        //接收微博中图片点击通知
        //通知单例为了给self发消息强引用self，self中也有通知才能一直监听该事件。
        //注意：block注册的通知不会被移除
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: WBPictureCellSelectNotification), object: nil, queue: nil) { [weak self] (notification) in
            
            guard let indexpath = notification.userInfo?[NSNotification.Name.init(rawValue: WBPictureCellIndexNotification)] as? IndexPath else{
                return
            }
            
            guard let urls = notification.userInfo?[NSNotification.Name.init(rawValue: WBPictureArrayNotification)] as? [URL] else{
                return
            }
            //PictureView的cell，PictureView遵循了PhotoBrowserPresentDelegate，协议的继承性
            guard let cell = notification.object as? PhotoBrowserPresentDelegate else{
                return
            }
            
            let vc = PhotoBrowserViewController(urls: urls, indexPath: indexpath)
            
            vc.modalPresentationStyle = .custom
            
            vc.transitioningDelegate = self?.photoTransitionDelegate
            
            //通过回传的PhotoView把其设置为代理对象
            self?.photoTransitionDelegate.setPhotoDelegate(indexPath: indexpath, presentDelegate: cell, dismissDelegate: vc)
            
            self?.present(vc, animated: true
                , completion: nil)
            
        }
    }
    
    @objc func tapViewOutSideOfKeyBoard(_ sender: UIGestureRecognizer) {
        
        finishComment()
    }
    
   
    
    ///注册原创和转发微博cell
    ///设置预估高度
    ///取消tableView的分割线
    func prepareTableView()
    {
        //1.添加子控件
        self.view.addSubview(tableView)
        //2.设置布局
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom).offset(-self.tabBarController!.tabBar.frame.size.height)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.register(OriginStatusCell.self, forCellReuseIdentifier: OriginStatusCellID)
        
        tableView.register(RetweetedStatusCell.self, forCellReuseIdentifier: RetweetedStatusCellID)
        
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 400
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: loadStatus)
        (tableView.mj_header as? MJRefreshStateHeader)?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: loadStatus)
        
        tableView.mj_header.beginRefreshing()
        tapGesture.delegate = self.viewAboveTableView
    }
    
    func prepareCommentKeyBoardView()
    {
        //1.添加视图
        self.view.insertSubview(viewAboveTableView, aboveSubview: tableView)
        self.view.insertSubview(self.commentKeyBoardView, aboveSubview: viewAboveTableView)
        
        commentKeyBoardView.isUserInteractionEnabled = true
        //2.设置布局
        viewAboveTableView.snp.makeConstraints { (make) in
            make.height.equalTo(screenHeight)
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        self.commentKeyBoardView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
            make.width.equalTo(screenWidth)
            make.height.equalTo(CommentKeyBoardView.recommendHeight)
        }
        
        
        commentKeyBoardView.delegate = self
        viewAboveTableView.addGestureRecognizer(UISwipeGestureRecognizer.init(target: self, action: #selector(tapViewOutSideOfKeyBoard)))
        viewAboveTableView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(tapViewOutSideOfKeyBoard)))
        viewAboveTableView.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(tapViewOutSideOfKeyBoard)))
        
        viewAboveTableView.addGestureRecognizer(self.tapGesture)
        
        viewAboveTableView.isHidden = true
        
    }
    
    //MARK: - 功能函数
    ///加载微博数据，里面会进行本地缓存判断。
    @objc func loadStatus(){
        
        //        tableView.refreshControl?.beginRefreshing()
        
        statusListViewModel.loadStatus(isPullUp:  !tableView.mj_header.isRefreshing)
        { (isSuccess) in
            
            if isSuccess == false
            {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试")
                self.reloadButton.isHidden = false
                return
            }
            
            //            self.addRefreshStatusLabel()
            
            self.reloadButton.isHidden = true
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            //            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false
            //                , block: { (_) in
            //                    self.tableView.refreshControl?.endRefreshing()
            //            })
        }
        
    }
    ///TargetAction通知
    //    @objc func startRefreshing() {
    //        loadStatus()
    //    }
    
    func addRefreshStatusLabel()  {
        
        guard let refreshCount = statusListViewModel.pullDownStatusCount else {
            return
        }
        
        self.refreshStatusLabel.text = refreshCount != 0 ? "刷新到\(refreshCount)条数据" : "没有刷新到数据"
        //我们来改变他的y轴距离去让他显示
        let labelY : CGFloat = 44
        
        let rect = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 44)
        
        self.refreshStatusLabel.frame = rect.offsetBy(dx: 0, dy: -2*labelY)
        
        self.navigationController?.navigationBar.insertSubview(self.refreshStatusLabel, at: 0)
        
        //我们在这里添加label在navibar上面还是下面
        UIView.animate(withDuration: 1.5, animations: {
            self.refreshStatusLabel.frame = rect.offsetBy(dx: 0, dy: labelY)
            
        }, completion: { _ in
            //让动画保持一秒
            DispatchQueue.main.asyncAfter(deadline: .now()
                + 1, execute: {
                    self.refreshStatusLabel.frame = CGRect.init(x: 0, y: -2*labelY, width: self.view.bounds.width, height: 44)
            })
        })
    }
    ///重新加载
    @objc func clickReloadButton(){
        loadStatus()
    }
    
    func finishComment()  {
        self.commentKeyBoardView.textView.resignFirstResponder()
        self.commentKeyBoardView.textView.inputView = nil
        (self.commentKeyBoardView.toolBar.items?[self.commentKeyBoardView.toolBar.items!.count-3].customView as! UIButton).setImage(UIImage.init(named: "compose_emoticonbutton_background"), for: .normal)
        self.isUsingKeyBoard = false
        self.viewAboveTableView.isHidden = true
    }
    
    @objc func HomeTVCKeyBoardWillChange(_ notification : NSNotification)
    {
        
        //拿到键盘改变前后的高度,相对于window
        let rect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        
        var offset : CGFloat = 0
        
        if rect.origin.y == screenHeight
        {
            offset = 0
        }
        else
        {
            //(self.view.frame.height - screenHeight)由于我们的keyBoardView是添加到view上面的，view的高度比window高一点
            offset = screenHeight-rect.origin.y + CommentKeyBoardView.recommendHeight + (self.view.frame.height - screenHeight)
        }
        
        //第一次打开键盘输入字母会再次进入这个方法，即使rect没有改变
        if rect != lastKeyBoardRect
        {
            lastKeyBoardRect = rect
            
            var contentOffset : CGPoint!
            
            if rect.origin.y == screenHeight
            {
                
                //键盘收回到屏幕下方
                //contentOffset = originalContentOffSet
                contentOffset = CGPoint.init(x:0, y: self.tableView.contentOffset.y - (commentViewPosition.y - commentKeyBoardView.frame.origin.y))
                //更新文字
                commentTable[lastTextViewTag] = commentKeyBoardView.textView.emoticonText()
                
            }
            else
            {
                
                //键盘弹出
                if commentKeyBoardView.textView.inputView == nil
                {
                    
                    if isUsingKeyBoard
                    {
                        
                        contentOffset = CGPoint.init(x: 0, y: originalContentOffSet.y + commentViewPosition.y - (rect.origin.y - commentKeyBoardView.bounds.size.height))
                        
                    }else
                    {
                        isUsingKeyBoard = true
                        contentOffset = CGPoint.init(x: 0, y: self.tableView.contentOffset.y + commentViewPosition.y - (rect.origin.y - commentKeyBoardView.bounds.size.height))
                    }
                }
                else
                {
                    //表情键盘等其他键盘的尺寸
                    let otherKeyBoardRect =  commentKeyBoardView.textView.inputView!.bounds.size
                    contentOffset = CGPoint.init(x:0 , y: self.tableView.contentOffset.y - (253.0 - otherKeyBoardRect.height))
                }
            }
            //更新按钮的位置，不然切换键盘的时候会出现高度叠加
            //commentViewPosition = CGPoint.init(x: 0, y: commentKeyBoardView.frame.origin.y)
            //滚动tableView到被textView遮挡
            //contentOffset的Y增加内容则往上滚动，否则往下
            self.tableView.setContentOffset(contentOffset, animated: true)
            
            
            UIView.animate(withDuration: duration) {
                self.commentKeyBoardView.snp.updateConstraints { (make) in
                    make.top.equalTo(self.view.snp.bottom).offset(-offset)
                }
            }
            
            //在这里设置的动画时长会被取消掉，因为动画直接到达了终点
            UIView.animate(withDuration: duration) {
                UIView.setAnimationCurve(UIView.AnimationCurve.init(rawValue: curve)!)
                self.view.layoutIfNeeded()
            }
        }
    }
    //MARK: - 成员变量
    lazy var tableView : UITableView = UITableView.init()
    
    lazy var viewAboveTableView : BackGroundView = {
        let view = BackGroundView.init()
        
        view.backgroundColor = UIColor.init(red: 246.0/255.0,green: 246.0/255.0, blue: 246.0/255.0, alpha: 0.3)
        
        return view
    }()
    
    class BackGroundView: UIView,UIGestureRecognizerDelegate {
       
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            //让其他手势
            return true
        }
    }
    
    var statusListViewModel = StatusListViewModel()
    
    lazy var photoTransitionDelegate = PhotoBrowserTransitioningDelegate()
    ///刷新时的小转轮
    lazy var indicator : UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.style = .whiteLarge
        ind.color = .gray
        return ind
    }()
    ///网络错误时候的重新加载
    lazy var reloadButton : UIButton = {
        let button = UIButton()
        button.setTitle("重新加载", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    ///刷新的Label
    lazy var refreshStatusLabel : UILabel = {
        let label = UILabel.init(content: "", size: 14)
        label.textColor = .black
        label.backgroundColor = UIColor.orange
        return label
    }()
    ///键盘上的textView
    lazy var commentKeyBoardView = CommentKeyBoardView()
    ///键盘出现时的外部点击手势
    lazy var tapGesture : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapViewOutSideOfKeyBoard))
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    ///没点开评论的时候tableView的contentOffSet
    var originalContentOffSet = CGPoint.init(x: 0, y: 0)
    ///评论View的位置
    var commentViewPosition = CGPoint.init(x: 0, y: 0)
    ///防止键盘弹出后打字再次改变高度
    var lastKeyBoardRect : CGRect = CGRect.init()
    ///是否在操作键盘
    var isUsingKeyBoard = false
    ///评论记录表，key为微博的id，下一次评论该微博可以找到之前编辑的内容
    var commentTable = [Int : String]()
    ///保存上一次的StatusID，用于更新评论表的内容
    var lastTextViewTag : Int = 0
    
    var lockForLoadStatus = NSLock.init()
    
}

//MARK: - tableView代理方法
extension StatusTableViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function,indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusListViewModel.statusList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = statusListViewModel.statusList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.cellID, for: indexPath) as! StatusCell
        
        vm.indexPath = indexPath
        
        cell.viewModel = vm
        
        cell.bottomView.tag = vm.status.id
        
        cell.bottomViewDelegate = self
        
        cell.clickLabelDelegate = self
        
        cell.topView.clickdelegate = self
        
        //        if indexPath.row == statusListViewModel.statusList.count-1{
        //            self.tableView.mj_footer
        //        }
        

        return cell
    }
    
    //MARK: - TODORowHeight
    //完成RowHeight的一次计算，由于我们设置了estimatedRowHeight，系统会根据每次能填满屏幕高度的cell去调用几次rowHeight，我们可以提前计算好所以rowHeight，而不是用户去滑动到下一页的时候再去计算。
    //思路：我们可以通过runloop判断当前的ScrollView是处于UITrackingRunLoopMode还是NSDefaultRunLoopMode，如果是第二个及空闲状态，用户什么也不点击也不加载网络，那么就去把剩下的cell高度全部计算出来。
    
    //情况一：设置了EstimateRowHeight
    //系统会根据填满界面Cell的数量，每个cell计算三次高度，其他的cell在用户滑动到再去调用
    //调用顺序：行数 -> 行高 -> cell -> 行高
    //优化思路：我们可以把每一个model封装出一个rowHeight属性，缓存高度，防止多次计算Cell的高度
    
    //情况二：没有设置EstimateRowHeight
    //系统一次计算所有的cell高度，并且每行计算3次，而且用户滑动的时候他仍然会计算高度,每个cell调用三次
    //系统会一次计算整个tableView的contentsize，假如cell的count是18，那么会计算18个cell的高度，这是因为UITableView继承于UIScrollView，为了增加用户滑动的时候的流畅性，会把所有需要的cell高度都提前计算好！
    
    //苹果建议：如果设置了TableView.rowHeight 就不要使用下面方法，两者互斥。
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return statusListViewModel.statusList[indexPath.row].rowHeight
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return indicator
    }
    
}
//MARK: - 转发，评论，点赞点击代理
extension StatusTableViewController : StatusCellBottomViewDelegate
{
    func didClickCommentButton(pointToWindow: CGPoint, statusViewModel: StatusViewModel) {
        commentKeyBoardView.isHidden = false
        commentKeyBoardView.statusViewModel = statusViewModel
        //评论区没有人数
        if statusViewModel.status.comments_count <= 0
        {
            //1.创建文本框
            self.commentViewPosition = pointToWindow
            self.lastTextViewTag = statusViewModel.status.id
            
            ///如果在表中找到上次编辑的评论内容，那么就赋值
            self.commentKeyBoardView.textView.text = self.commentTable.keys.contains(statusViewModel.status.id) ? self.commentTable[statusViewModel.status.id] : nil
            self.lastTextViewTag = statusViewModel.status.id
            self.viewAboveTableView.isHidden = false
            originalContentOffSet = self.tableView.contentOffset
            self.commentKeyBoardView.textView.becomeFirstResponder()
            //            isUsingKeyBoard = false
        }else
        {//评论有人评论，进入对于当前微博的评论View
            let commentVC = CommentViewController()
            //传入当前status的ViewModel,下面的一定有值,我们强行解包
            commentVC.hidesBottomBarWhenPushed = true
            statusListViewModel.statusList.forEach({ (vm) in
                if vm.status.id == statusViewModel.status.id
                {
                    commentVC.statusViewModel = vm
                }
            })
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
    }
    
    func didClickCommentButton(pointToWindow: CGPoint, commentCount: Int, statusID: Int) {
        
        //评论区没有人数
        if commentCount <= 0
        {
            //1.创建文本框
            self.commentViewPosition = pointToWindow
            self.lastTextViewTag = statusID
            ///如果在表中找到上次编辑的评论内容，那么就赋值
            self.commentKeyBoardView.textView.text = self.commentTable.keys.contains(statusID) ? self.commentTable[statusID] : nil
            self.lastTextViewTag = statusID
            self.viewAboveTableView.isHidden = false
            self.commentKeyBoardView.textView.becomeFirstResponder()
        }else
        {//评论有人评论，进入对于当前微博的评论View
            let commentVC = CommentViewController()
            //传入当前status的ViewModel,下面的一定有值,我们强行解包
            commentVC.hidesBottomBarWhenPushed = true
            statusListViewModel.statusList.forEach({ (vm) in
                if vm.status.id == statusID
                {
                    commentVC.statusViewModel = vm
                }
            })
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
    }
}
//MARK: - 评论点击代理
extension StatusTableViewController : CommentKeyBoardViewDelegate
{
    func didClickSend(commentKeyBoardView: CommentKeyBoardView, content: String) {
        
        NetworkTool.shared.postAComments(statusID: commentKeyBoardView.statusViewModel!.status.id, comment: content) { (data, error) in
            if error == nil
            {
                self.finishComment()
                SVProgressHUD.showSuccess(withStatus: String.init(format: "成功评论%@的微博",commentKeyBoardView.statusViewModel!.status.user!.screen_name!))
                
                
                
            }
            
        }
    }
    
}
//MAKR: - 正文蓝色Label点击代理
extension StatusTableViewController : ClickLabelDelegate
{
    func didClickURL(url: URL) {
        let webVC = HomeWebViewController.init(url: url)
        webVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.delegate = self;
        self.navigationController?.pushViewController(webVC, animated:true)
    }
    
}

extension StatusTableViewController : ClickTopViewProtocol
{
    func clickClickTopView(statusTopView: StatusTopView) {
        let vc = UserDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.statusViewModel = statusTopView.viewModel
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func clickCloseButton(statusTopView: StatusTopView) {
        
         let ac = UIAlertController.init(title: "删除微博", message: "确定要删除该条微博吗", preferredStyle: .actionSheet)
        ac.addAction(.init(title: "确定", style: .destructive, handler: { (action) in
            self.tableView.beginUpdates()
            self.statusListViewModel.statusList.remove(at: statusTopView.viewModel!.indexPath!.row)
            self.tableView.deleteRows(at:[statusTopView.viewModel!.indexPath!] , with: .fade)
            self.tableView.endUpdates()
        }))
        ac.addAction(.init(title: "取消", style: .cancel, handler: { (action) in
            return
        }))
        self.present(ac, animated: true,completion: nil)
    }

}

