//
//  RetweetedStatusCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/1.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
//我们继承了原有类
//要显示的话我们要做如下操作
/*
 controller中的重用cellID
 行高中的cellID
 */
///转发微博
class RetweetedStatusCell: StatusCell {
    
    override var viewModel: StatusViewModel?{
        didSet{
            let text = viewModel?.retweetedStatusText ?? ""
            
            retweetlabel.attributedText = EmoticonsViewModel.shared.emoticonText(string: text, font: retweetlabel.font)
            //断点调试 发现先调用父类方法再调用子类
        //重写父类属性，不用super去调用，系统会自动调用父类操作，子类只需要专注子类的操作就可以了，类的继承
            pictureView.snp.updateConstraints{ (make) in
                let topofs = (viewModel?.thumbnails?.count)! > 0 ? StatusCellMargins : 0
                make.top.equalTo(retweetlabel.snp.bottom).offset(topofs)
            }
            pictureView.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        }
    }
    
    //MAKR: - 成员变量
    ///转发微博的背景
    lazy var backbutton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        return button
    }()

    ///转发微博的文字
    lazy var retweetlabel : HLLabel = HLLabel.init(content: "",
                                                   color: .black,
                                                   size: screenHeight*0.0243,
                                                   screenInset: StatusCellMargins)
    }

///设置布局
extension RetweetedStatusCell{
    
     override func setUpUI() {
        //我们的目的是在原有布局上面添加新的布局，改变不同view的位置
        //先调用父类方法 
        super.setUpUI()
        //添加控件 注意转发微博要在图片下面
        contentView.insertSubview(backbutton, belowSubview: pictureView)
        
        contentView.insertSubview(retweetlabel, aboveSubview: backbutton)
        
        backbutton.snp.makeConstraints { (make) in
        make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargins)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        retweetlabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargins)
            make.left.equalTo(contentView.snp.left).offset(StatusCellMargins)
        }
        
        pictureView.snp.makeConstraints { (make) in
        make.top.equalTo(retweetlabel.snp.bottom).offset(StatusCellMargins)
            make.left.equalTo(retweetlabel.snp.left)
            make.height.equalTo(200)
            make.width.equalTo(90)
        }
        //父类实现了对应的代理方法
        retweetlabel.delegate = self
    }
}
