//
//  StatusCellTableViewCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

let StatusCellMargins : CGFloat = 12

//设置点击链接等返回该文字协议
protocol ClickLabelDelegate : NSObjectProtocol{
    func didClickURL(url:URL)
}

protocol StatusCellBottomViewDelegate : NSObjectProtocol {
    func didClickCommentButton(pointToWindow: CGPoint, statusViewModel : StatusViewModel)
}

class StatusCell: UITableViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    var viewModel : StatusViewModel?
    {
        didSet
        {
            topView.viewModel = viewModel
            let text = viewModel?.status.text ?? ""
            
            contentLabel.attributedText = EmoticonsViewModel.shared.emoticonText(string: text, font: contentLabel.font)
            
            pictureView.viewModel = viewModel
            
            pictureView.snp.updateConstraints{ (make) in
                make.height.equalTo(pictureView.bounds.height)
                make.width.equalTo(pictureView.bounds.width)
            }
            
            bottomView.viewModel = viewModel
        }
    }
    
    func RowHeight(statusVM : StatusViewModel) -> CGFloat
    {
        self.viewModel = statusVM
        //强制更新
        contentView.layoutIfNeeded()
        
        return bottomView.frame.maxY
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //防止别人使用Xib去创建
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 成员变量
    lazy var topView = StatusTopView()
    
    lazy var bottomView = StatusBottomView()
    
    lazy var pictureView = StatusPictureView()

    lazy var contentLabel : HJLabel = HJLabel.init(content: "微博正文",color: .black, size:  screenHeight*0.0246, screenInset:StatusCellMargins)
    
    weak var clickLabelDelegate : ClickLabelDelegate?
    
    weak var bottomViewDelegate : StatusCellBottomViewDelegate?
}

extension StatusCell{
    
    @objc func setUpUI(){
        
        pictureView.backgroundColor = UIColor.white
        
        //1,添加控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomView)
        contentView.addSubview(pictureView)
        bottomView.backgroundColor = UIColor.white
        
        //2,布局
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(CellIconWidth+2*StatusCellMargins)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(StatusCellMargins)
            make.left.equalTo(contentView.snp.left).offset(StatusCellMargins)
        }
        
        bottomView.snp.makeConstraints { (make) in
    make.top.equalTo(pictureView.snp.bottom).offset(StatusCellMargins)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(CellIconWidth)
        }
        //3，设置代理
        contentLabel.delegate = self
        bottomView.delegate = self
    }
}
extension StatusCell : StatusBottomViewClickDelegate
{
    func retweetButtonClick(pointToWindows: CGPoint) {
        
    }
    
    func likeButtonClick(pointToWindows: CGPoint) {
        
    }
    
    func commentButtonClick(pointToWindows: CGPoint) {
        guard let vm = viewModel else {
            return
        };
        bottomViewDelegate?.didClickCommentButton(pointToWindow: pointToWindows, statusViewModel: vm)
    }
    
}
extension StatusCell : HLLabelDelegate{
    func didSelectHighLightedText(label: HJLabel, string: String) {
        if string.hasPrefix("http"){
            //由于我们在微博中点击的链接为短链接(节省资源)，都为httpl开头
            clickLabelDelegate?.didClickURL(url: URL.init(string: string)!)
        }
        
    }

}
