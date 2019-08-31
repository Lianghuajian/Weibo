//
//  ComposeViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/10.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import QorumLogs
//MARK: - 撰写控制器
class ComposeViewController: UIViewController {
    
    //MARK: - 监听方法
    @objc private func clickCancel(){
        
        textview.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func clickPush()
    {
        print(textview.emoticonText())
        clickCancel()
        //该功能接口已经被禁止现在
        //        AFNetworkTool.sharedTool.postStatus(content: textview.emoticonText()) { (response, error) in
        //            if let error = error{
        //                print(error)
        //                return
        //            }
        //            print(response)
        //        }
        //        let image = PicturePickerController.pictureArray
        //上传图片
        //        AFNetworkTool.sharedTool.postStatus(content: textview.emoticonText(), image: image.last)
        //            { (response, error) in
        //                            if let error = error{
        //                                print(error)
        //                                return
        //                            }
        //                print(response!)
        //            }
        //        }
    }
    @objc private func clickEmoticon()
    {
        
        textview.resignFirstResponder()
        //如果用户当前是表情键盘那么就把inputView置为nil,在becomeFirstResponder的时候会把键盘置为inputView
        //如果当前用户是系统键盘那么就把inputView置为表情键盘，在becomeFirstResponder的时候就不会使用系统键盘
        if textview.inputView == nil
        {
            textview.inputView = emoticonview
            
            DispatchQueue.main.async {
                (self.toolbar.items?[self.toolbar.items!.count-3].customView as! UIButton).setImage(UIImage.init(named: "compose_keyboardbutton_background"), for: .normal)
            }
        }
        else
        {
            textview.inputView = nil
            DispatchQueue.main.async {
                (self.toolbar.items?[self.toolbar.items!.count-3].customView as! UIButton).setImage(UIImage.init(named: "compose_emoticonbutton_background"), for: .normal)
            }
        }
        textview.becomeFirstResponder()
    }
    
    @objc private func clickAddPhoto()
    {
        if PicturePickerController.view.bounds.size.height == 0
        {
            //退掉键盘
            textview.resignFirstResponder()
            //防止多次重新布局
            if PicturePickerController.view.bounds.height>0{
                return
            }
            PicturePickerController.view.snp.updateConstraints { (make) in
                make.height.equalTo(view.bounds.height*0.6)
            }
            //跟新文本约束参照对象，改变参照物需要用remake不能用update
            textview.snp.remakeConstraints { (make) in
                //safeAreaLayoutGuide 这个属性用来防止被navigationBar等物体遮挡
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.bottom.equalTo(PicturePickerController.view.snp.top)
            }
            UIView.animate(withDuration: 0.5)
            {
                self.view.layoutIfNeeded()
            }
        }else {
            
            textview.snp.remakeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.bottom.equalTo(toolbar.snp.top)
            }
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    //MARK: - 生命周期
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //选完照片不会再弹出键盘
        if PicturePickerController.view.frame.height == 0{
            textview.becomeFirstResponder()
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.setupUI()
        }
        //添加键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeKeyBoardChanged), name: UIResponder.keyboardWillChangeFrameNotification , object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    ///监听键盘
    @objc func ComposeKeyBoardChanged(notification : NSNotification) {
        //print(notification)
        //1,拿到键盘每次完成布局后的高度
        let rect = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        //UIKeyboardAnimationCurveUserInfoKey
        //获取目标的动画时长
        let duration = (notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
        //动画曲线数值 curve = 7
        let curve = (notification.userInfo!["UIKeyboardAnimationCurveUserInfoKey"] as! NSNumber).intValue
        
        //UIKeyboardAnimationDurationUserInfoKey
        let offset = -UIScreen.main.bounds.height + rect.origin.y
        
        //2,更新约束
        toolbar.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(offset)
        }
        //3.动画，键盘改变的时候，键盘会从缩到屏幕下放再上来，这时候toolbar约束跟着改变，就会出现toolbar弹跳的效果（及动画运动曲线过长）
        UIView.animate(withDuration: duration) {
            //1,我们在拿到其将要运动到的地方，直接插入一个动画，系统会终止之前的动画，直接运行后面动画的位置
            //2,animateBlock其实是对CAAnimation的封装，改变view的layer
            //3,进行这一步骤后duration没有效果
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: curve)!)
            self.view.layoutIfNeeded()
        }
        
    }
    
    //MARK: - 懒加载控件
    ///键盘上面的toolbar
    lazy var toolbar = UIToolbar()
    ///键盘输入的textVview
    lazy var textview : UITextView =
        {
            let tv = UITextView.init()
            tv.delegate = self
            tv.font = UIFont.systemFont(ofSize: 18)
            tv.textColor = UIColor.darkGray
            tv.alwaysBounceVertical = true
            tv.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
            return tv
    }()
    
    ///占位标签
    lazy var placeHolderLabel = UILabel.init(content: "分享新鲜事...", color: .lightGray, size: 18)
    
    //表情键盘
    lazy var emoticonview = EmoticonView
        { [weak self] (emoticon) in
            //获取当前文本，并拼接上表情包
            self?.textview.insertEmoticon(emoticon: emoticon)
    }
    
    ///相册
    lazy var PicturePickerController = PicturePickerCollectionViewController()
}
//MARK: - 设置界面
extension ComposeViewController
{
    ///布局视图
    func setupUI()
    {
        //ios7-11需要设置下面为false，否则他认为你collection默认有个导航条
        //1，设置背景颜色
        view.backgroundColor = .white
        prepareNavigationBar()
        prepareToolBar()
        prepareTextView()
        preparePicturePicker()
    }
    
    ///布局图片选择器
    func preparePicturePicker() {
        //如果不添加到childView，响应链会断掉
        self.addChild(PicturePickerController)
        
        self.view.insertSubview(PicturePickerController.view, belowSubview: toolbar)
        
        PicturePickerController.view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(0)
        }
        
    }
    
    ///布局键盘ToolBar
    func prepareToolBar()  {
        
        //1,添加控件
        self.view.addSubview(toolbar)
        
        //2,布局控件
        toolbar.snp.makeConstraints
            { (make) in
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.bottom.equalTo(view.snp.bottom)
                make.height.equalTo(44)
        }
        
        //3,添加按钮
        let imageDict = [["imageName":"compose_toolbar_picture","action":"clickAddPhoto"],["imageName":"compose_mentionbutton_background"],
                         ["imageName":"compose_trendbutton_background"], ["imageName":"compose_emoticonbutton_background","action":"clickEmoticon"],
                         ["imageName":"compose_add_background"]]
        
        var items = [UIBarButtonItem]()
        
        for dict in imageDict{
            
            //判断actionname
            let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, actionName: dict["action"])
            
            items.append(item)
            //设置弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            
        }
        
        items.removeLast()
        
        toolbar.items = items
        
    }
    
    ///布局textview
    func prepareTextView(){
        //1，添加子控件
        view.addSubview(textview)
        textview.addSubview(placeHolderLabel)
        //2，设置布局
        textview.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.toolbar.snp.top)
        }
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textview.snp.top).offset(8)
            make.left.equalTo(textview.snp.left).offset(5)
        }
    }
    
    ///布局导航栏
    func prepareNavigationBar()
    {
        //1,设置navBar的左右按钮
        //取消按钮
        let leftItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(clickCancel))
        leftItem.tintColor = .orange
        navigationItem.leftBarButtonItem = leftItem
        //发微博按钮
        let rightItem = UIBarButtonItem.init(title: "发布", style: .plain, target: self, action: #selector(clickPush))
        rightItem.tintColor = .orange
        navigationItem.rightBarButtonItem = rightItem
        
        //2,标题视图
        let titleView = UIView.init(frame: CGRect.init(x:0, y: 0, width: 200, height: 36))
        
        navigationItem.titleView = titleView
        
        //3,标题文字
        let titleLabel = UILabel.init(content: "发微博", color: .gray, size: 15)
        
        let nameLabel = UILabel.init(content: UserAccountViewModel.shared.account?.screen_name ?? "", color: .darkGray, size: 13)
        
        titleView.addSubview(titleLabel)
        
        titleView.addSubview(nameLabel)
        
        //4,设置文字标题约束
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.center.x)
            make.top.equalTo(titleView.snp.top)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.center.x)
            make.bottom.equalTo(titleView.snp.bottom)
        }
        
    }
}
//MAKR: -textView的代理方法
extension ComposeViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = true
    }
}
