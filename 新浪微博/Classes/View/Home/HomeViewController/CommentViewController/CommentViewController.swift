//
//  CommentViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/1.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

import SVProgressHUD

fileprivate enum CellID : String
{
   case OriginStatusCellID
   case RetweetedStatusCellID
   case CommentTableViewCellID
}
class CommentViewController: UIViewController {
    //MARK: - 视图模型
    ///只被赋值一次，进来就有值
    var statusViewModel : StatusViewModel?
    {
        didSet{
            commentKeyBoardView.statusViewModel = statusViewModel
        }
    }
    
    var commentListViewModel = CommentListViewModel()
    
    //MARK: - 生命周期
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewControllerKeyBoardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareStatusBottomView()
        prepareTableView()
        prepareCommentKeyBoard()
        
        statusViewModel?.loadComments({[weak self] (viewModels) in
            guard let viewModels = viewModels else
            {
                
                return
                
            }
            self?.commentListViewModel.viewModels = viewModels
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
   
    //MARK: - 初始化控件及模型
    func prepareTableView()
    {
        //1.添加控件
        self.view.addSubview(tableView)
        //2.设置约束
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.bottom.equalTo(self.bottomView.snp.top)
            make.width.equalTo(screenWidth)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 400
        tableView.tableFooterView = UIView.init()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CellID.CommentTableViewCellID.rawValue)
        tableView.register(OriginStatusCell.self, forCellReuseIdentifier: CellID.OriginStatusCellID.rawValue)
        tableView.register(RetweetedStatusCell.self, forCellReuseIdentifier:CellID.RetweetedStatusCellID.rawValue)
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: refreshCommentTableView)
        (tableView.mj_header as? MJRefreshStateHeader)?.lastUpdatedTimeLabel.isHidden = true

    }
    
    @objc func refreshCommentTableView()
    {
        
        self.statusViewModel?.loadComments({[weak self] (viewModels) in
            
            guard let viewModels = viewModels else
            {
                self?.tableView.mj_header.endRefreshing()
                return 
            }
            
            self?.commentListViewModel.viewModels = viewModels
            
            self?.tableView.mj_header.endRefreshing()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        })
        
    }
    func prepareStatusBottomView()
    {
        //1.添加控件
        self.view.addSubview(bottomView)
        
        //2.设置约束
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.width.equalTo(screenWidth)
            make.height.equalTo(44)
        }
        
        bottomView.backgroundColor = .white
        
        bottomView.delegate = self
        
    }
    func prepareCommentKeyBoard()
    {
        //1.创建键盘
        self.view.insertSubview(viewAboveTableView, aboveSubview: self.tableView)
        self.view.insertSubview(commentKeyBoardView, aboveSubview: viewAboveTableView)
      
        viewAboveTableView.addGestureRecognizer(UISwipeGestureRecognizer.init(target: self, action: #selector(tapViewOutSideOfKeyBoard)))
        viewAboveTableView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(tapViewOutSideOfKeyBoard)))
        viewAboveTableView.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(tapViewOutSideOfKeyBoard)))
        
        viewAboveTableView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapViewOutSideOfKeyBoard)))
        
        
        self.viewAboveTableView.snp.makeConstraints { (make) in
            make.height.equalTo(screenHeight)
            make.width.equalTo(screenWidth)
            make.left.equalTo(self.view.snp.left)
            make.top.equalTo(self.view.snp.top)
        }
        commentKeyBoardView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.width.equalTo(screenWidth)
            make.height.equalTo(CommentKeyBoardView.recommendHeight)
        }
        
        
        emoticonLayer.backgroundColor = UIColor.clear.cgColor
        
        self.view.layer.addSublayer(emoticonLayer)
        
        
        commentKeyBoardView.delegate = self
        viewAboveTableView.isHidden = true
    }
    //MARK: - 成员变量
    lazy var tableView = UITableView()
    
    lazy var bottomView: StatusBottomView = {
        let sbv = StatusBottomView()
        
        return sbv
    }()
    
    let emoticonLayer = EmoticonLayer()
    
    lazy var commentKeyBoardView = CommentKeyBoardView()
    ///评论View的位置
    var commentViewPosition = CGPoint.init(x: 0, y: 0)
    ///防止键盘弹出后打字再次改变高度
    var lastKeyBoardRect : CGRect = CGRect.init()
    
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
    
    lazy var viewAboveTableView : BackGroundView = {
        let view = BackGroundView.init()
        
        view.backgroundColor = UIColor.init(red: 246.0/255.0,green: 246.0/255.0, blue: 246.0/255.0, alpha: 0.3)
        
        return view
    }()
    
    @objc func CommentViewControllerKeyBoardWillChange(_ notification : NSNotification)
    {
        //拿到键盘改变前后的高度,相对于window
        let rect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        //第一次打开键盘输入字母会再次进入这个方法，即使rect没有改变
        if rect != lastKeyBoardRect
        {
            
            lastKeyBoardRect = rect
            
//            var contentOffset : CGPoint!
//            
//            if rect.origin.y == screenHeight
//            {
//                //键盘收回到屏幕下方
//                contentOffset = CGPoint.init(x:0 , y: self.tableView.contentOffset.y-(commentViewPosition.y -  (screenHeight-rect.size.height-commentKeyBoardView.frame.height)))
//                //更新文字
////                commentTable[lastTextViewTag] = commentKeyBoardView.textView.text
//            }else
//            {
//                //键盘弹出
//                contentOffset = CGPoint.init(x:0 , y: self.tableView.contentOffset.y+(commentViewPosition.y -  (screenHeight-rect.size.height-commentKeyBoardView.frame.height)))
//            }
            
            var offset : CGFloat = 0
            
            if rect.origin.y == screenHeight
            {
                offset = 0
            }
            else
            {
                offset = screenHeight-rect.origin.y + CommentKeyBoardView.recommendHeight
            }
            
            UIView.animate(withDuration: duration) {
                self.commentKeyBoardView.snp.updateConstraints { (make) in
                    make.top.equalTo(self.view.snp.bottom).offset(-offset)
                }
            }
            
            UIView.animate(withDuration: duration) {
                UIView.setAnimationCurve(UIView.AnimationCurve.init(rawValue: curve)!)
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
//MARK: tableView数据源
extension CommentViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return (statusViewModel!.rowHeight - 44)
        default:
            return commentListViewModel.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell!
        
        switch indexPath.row {
        case 0:
            let vm = statusViewModel
            cell = tableView.dequeueReusableCell(withIdentifier:vm!.cellID , for: indexPath)
            (cell as! StatusCell).viewModel = vm
            (cell as! StatusCell).bottomView.isHidden = true
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier:CellID.CommentTableViewCellID.rawValue , for: indexPath)
            
            (cell as! CommentTableViewCell).commentListViewModel = commentListViewModel
            
            return cell;
        }
        return cell
    }
}

extension CommentViewController : StatusBottomViewClickDelegate
{
    func commentButtonClick(pointToWindows: CGPoint) {
     
    viewAboveTableView.isHidden = false
    commentKeyBoardView.isHidden = false
    commentKeyBoardView.textView.becomeFirstResponder()
    }
    
    @objc func tapViewOutSideOfKeyBoard() {
        
    self.viewAboveTableView.isHidden = true
        
    self.commentKeyBoardView.textView.resignFirstResponder()
        
    self.commentKeyBoardView.isHidden = true
    }
    
    func retweetButtonClick(pointToWindows: CGPoint) {
        
    }
    
    func likeButtonClick(pointToWindows: CGPoint) {
        
    }
    
}
extension CommentViewController : CommentKeyBoardViewDelegate
{
    func didClickSend(commentKeyBoardView: CommentKeyBoardView, content: String) {
    
    emoticonLayer.emit(text: "微笑")
        
    NetworkTool.shared.postAComments(statusID: commentKeyBoardView.statusViewModel!.status.id, comment: content) { (data, error) in
        if error == nil
        {
            self.commentKeyBoardView.textView.resignFirstResponder()
            
            self.viewAboveTableView.isHidden = true
            
            SVProgressHUD.showSuccess(withStatus: String.init(format: "成功评论%@的微博",commentKeyBoardView.statusViewModel!.status.user!.screen_name!))
            
            self.refreshCommentTableView()
        }
        
    }
    }
    
}
