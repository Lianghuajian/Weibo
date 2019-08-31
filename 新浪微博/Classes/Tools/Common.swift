//
//  Common.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/4.
//  Copyright © 2019 梁华建. All rights reserved.
//
//类似与OC的pch文件
import UIKit
///Users/lianghuajian/Downloads/WMPlayer-master/WMPlayer/WNPlayer/codec
let screenHeight : CGFloat = UIScreen.main.bounds.size.height
let screenWidth : CGFloat = UIScreen.main.bounds.size.width
let CellIconWidth = screenHeight*0.08
let spaHeight = screenHeight * 0.017
//window切换MainVC通知
let WBSwitchVCControllerNotification = "WBSwitchVCControllerNotification"
//MARK: - 通知注册
///statusCell中PictureView的点击通知
let WBPictureCellSelectNotification = "WBPictureCellSelectNotification"
///当前微博选中图片的索引
let WBPictureCellIndexNotification = "WBPictureCellIndexNotification"
///当前微博图片组
let WBPictureArrayNotification = "WBPictureArrayNotification"

///评论按钮的点击通知
let WBCellCommentBottomClickedNotification = "WBCellCommentBottomClickedNotification"
///当前评论按钮相对于windows的位置
let CurrentCommentBottonPoint = "CurrentCommentBottonPoint"
///当前微博的评论数
let WBCellCommentCountsNotification = "WBCellCommentCountsNotification"
//MARK: - 颜色
//设置全局颜色
let appearenceColor = UIColor.orange
//分割条颜色
let spaColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1)
