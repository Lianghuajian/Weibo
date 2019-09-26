//
//  CommentKeyBoardView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/30.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

private let margin = 13
protocol CommentKeyBoardViewDelegate : NSObjectProtocol
{   ///注意一定要给该view的statusViewModel赋值，否则评论会无法找到该微博而崩溃
    func didClickSend(commentKeyBoardView:CommentKeyBoardView , content : String)
}
///评论的键盘view 注意一定要给该view的statusViewModel赋值，否则评论会崩溃
class CommentKeyBoardView: UIView {

    static let recommendHeight :CGFloat = 116.5
    
    var statusViewModel : StatusViewModel?
   
    //MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    //MARK: - 初始化控件及布局
    func setUpUI(){
        self.backgroundColor = backColor
        //1.添加子控件
        self.addSubview(textView)
        self.addSubview(sendButton)
        self.addSubview(toolBar)
        self.addSubview(tickButton)
        self.addSubview(repostButton)
        textView.addSubview(textViewPlaceHolder)
        //2.布局子控件
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(margin)
            make.top.equalTo(self.snp.top).offset(margin/2)
            make.width.equalTo(screenWidth*0.75)
            make.height.equalTo(70)
        }
        
        tickButton.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(margin)
            make.left.equalTo(textView.snp.left)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
        repostButton.snp.makeConstraints { (make) in
            make.left.equalTo(tickButton.snp.right)
            make.top.equalTo(tickButton.snp.top)
            make.width.equalTo(90)
            make.height.equalTo(tickButton.snp.height)
        }
        
        toolBar.snp.makeConstraints { (make) in
        make.left.equalTo(repostButton.snp.right).offset(margin)
            make.top.equalTo(textView.snp.bottom)
            make.right.equalTo(self.snp.right)
            
            make.height.equalTo(40)
        }
        
        sendButton.snp.makeConstraints { (make) in
        make.left.equalTo(textView.snp.right).offset(margin-5)
            make.bottom.equalTo(textView.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
        //3.设置控件
        tickButton.addTarget(self, action: #selector(clickTickbutton), for: .touchUpInside)
        repostButton.addTarget(self, action: #selector(clickTickbutton), for: .touchUpInside)
        textView.delegate = self
        //添加按钮到toolBar
        let imageDict = [["imageName":"compose_toolbar_picture","action":"clickAddPhoto"],["imageName":"compose_mentionbutton_background"],
                         ["imageName":"compose_trendbutton_background"], ["imageName":"compose_emoticonbutton_background","action":"clickEmoticon"],
                         ["imageName":"compose_add_background"]]
        toolBar.backgroundColor = backColor
        
        var items = [UIBarButtonItem]()
        
        for dict in imageDict{
            
            //判断actionname
            let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, actionName: dict["action"])
            
            items.append(item)
            //设置弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            
        }
        items.first?.isEnabled = false
        items.removeLast()
        toolBar.setShadowImage(nil, forToolbarPosition: .top)
        toolBar.setBackgroundImage(nil, forToolbarPosition: .top, barMetrics: .default)
        toolBar.clipsToBounds = true
        toolBar.items = items
        
        sendButton.addTarget(self, action: #selector(didClickSend), for: .touchUpInside)
        
    }
    @objc func clickAddPhoto()
    {
        
    }
    @objc func didClickSend() {
        delegate?.didClickSend(commentKeyBoardView: self, content: self.textView.emoticonText())
    }
    
    @objc private func clickEmoticon()
    {
        
        textView.resignFirstResponder()
        //如果用户当前是表情键盘那么就把inputView置为nil,在becomeFirstResponder的时候会把键盘置为inputView
        //如果当前用户是系统键盘那么就把inputView置为表情键盘，在becomeFirstResponder的时候就不会使用系统键盘
        if textView.inputView == nil
        {
            textView.inputView = emoticonView
            
            DispatchQueue.main.async {
                (self.toolBar.items?[self.toolBar.items!.count-3].customView as! UIButton).setImage(UIImage.init(named: "compose_keyboardbutton_background"), for: .normal)
            }
        }
        else
        {
            textView.inputView = nil
            DispatchQueue.main.async {
                (self.toolBar.items?[self.toolBar.items!.count-3].customView as! UIButton).setImage(UIImage.init(named: "compose_emoticonbutton_background"), for: .normal)
            }
        }
        textView.becomeFirstResponder()
    }
    @objc func clickTickbutton(){
        tickTimes += 1
        if tickTimes%2 == 0
        {
            tickButton.isTick = false
        }else
        {
            tickButton.isTick = true
        }
    }
    
    //MARK: - 成员变量
    var tickTimes = 2
    lazy var textView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    }()
    lazy var emoticonView = EmoticonView.init { [weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon: emoticon)
    }
    lazy var textViewPlaceHolder : UILabel = {
        let label = UILabel.init(content: "Write a comment", size: 14)
        label.textColor = .gray
        label.textAlignment = .left
        label.frame = CGRect.init(x:4, y: 6, width: 140, height: 20)
        return label
    }()
    
    lazy var sendButton : UIButton = {
      let btn = UIButton()
        btn.setTitleColor(.lightGray, for: .normal)
        btn.setTitle("Send", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    btn.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return btn
    }()
    weak var delegate : CommentKeyBoardViewDelegate?
    
    lazy var toolBar = UIToolbar()
    
    lazy var tickButton : PickButton = {
       let pbtn = PickButton()
       pbtn.layer.borderColor = UIColor.lightGray.cgColor
       pbtn.layer.borderWidth = 1
       return pbtn
    }()
    
    lazy var repostButton : UIButton = {
    let btn = UIButton()

        btn.setTitleColor(.black, for: .normal)

        btn.setTitle("Also repost", for: .normal)

        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)

    return btn
    }()
   
    
    
    
}
extension CommentKeyBoardView : UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != nil
        {
            sendButton.setTitleColor(.orange, for: .normal)
            textViewPlaceHolder.isHidden = true
            return
        }
        else
        {
            sendButton.setTitleColor(.black , for: .normal)
           textViewPlaceHolder.isHidden = false
        }
    
    }
   
}
class PickButton: UIButton {
    
    var isTick : Bool = false
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        if isTick
        {
            UIColor.green.set()
            let width = rect.size.width
            let height = rect.size.height
            let path = UIBezierPath.init()
            path.lineWidth = 1.5
            path.move(to: CGPoint.init(x:width*0.23, y: height*0.5))
            path.addLine(to: CGPoint.init(x:width*0.45, y:height*0.7))
            path.addLine(to: CGPoint.init(x:width*0.79, y:height*0.25))
            path.stroke()
        }
    }
}
