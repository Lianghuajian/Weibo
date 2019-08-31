////
////  TitleCollectionViewCell.swift
////  UIPageViewControllerDemo
////
////  Created by 梁华建 on 2019/6/20.
////  Copyright © 2019 梁华建. All rights reserved.
////
//
//import UIKit
//
//class TitleCollectionViewCell: UICollectionViewCell {
//    //MARK: - 生命周期
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUpUI()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setUpUI()
//    }
//
//    //MARK: - 布局视图及初始化控件
//    func setUpUI()
//    {
//        //0,设置cell
//        self.isMultipleTouchEnabled = false
//        //1,添加控件
//        self.contentView.addSubview(titleLabel)
//        //2,添加约束
//    }
//
//    //MARK: - 懒加载属性
//    lazy var titleLabel: UILabel = {
//        let label = UILabel.init(frame: CGRect.init(x: 0, y: 14, width: 60, height: 18))
//        label.textColor = .black
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 16)
//        return label
//    }()
//
//}
