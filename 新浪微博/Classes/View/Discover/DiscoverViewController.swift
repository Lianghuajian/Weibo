
//
//  DiscoverTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/3.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
let DiscoverTableViewCellID = "DiscoverTableViewCellID"
class DiscoverViewController: VisitorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorview?.setUpInfo(imagename: "visitordiscover_image_message", text: "登录后，最新和最热微博尽在掌握，不再会与实事潮流擦肩而过。")
        
        prepareForTableView()
        
    }
    func loadVideo() {
        VideoModel.loadVideoModel(completion: {data,error in
            if error != nil
            {
                return
            }
            if data != nil
            {
                self.videoModelList = self.videoModelList == nil ? data : self.videoModelList! + data!
                self.tableView.mj_header.endRefreshing()
                self.tableView.reloadData()
            }
        })
    }
    func prepareForTableView(){
    tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: loadVideo)
    (tableView.mj_header as? MJRefreshStateHeader)?.lastUpdatedTimeLabel.isHidden = true
    tableView.tableFooterView = UIView()
    tableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier:DiscoverTableViewCellID)
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view.addSubview(tableView)
    self.tableView.mj_header.beginRefreshing()
    
    }
    
    func releasePlayer() {
       
        player?.removeFromSuperview()
        player = nil
    }
    
    // MARK: - 属性
    var videoModelList : [VideoModel]?
    
    lazy var tableView = UITableView.init(frame: self.view.bounds, style: .plain)
    
    var player : WMPlayer? = WMPlayer()
    
    var currentCell : DiscoverTableViewCell?
}
extension DiscoverViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoModelList?.count ?? 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverTableViewCellID, for: indexPath) as! DiscoverTableViewCell
        cell.clickBlock = {[weak self] bgImageView,videoModel in
            self?.releasePlayer()
            self?.currentCell = bgImageView?.superview?.superview as? DiscoverTableViewCell
            if bgImageView == nil && videoModel == nil
            {
                return
            }
            let playerMD = WMPlayerModel()
            playerMD.title = videoModel!.title
            playerMD.videoURL = URL.init(string:videoModel!.video_url!)
            playerMD.indexPath = indexPath
            self?.player = WMPlayer()
            self?.player!.playerModel = playerMD
            bgImageView?.addSubview(self!.player!)
            self?.player!.snp.makeConstraints({ (make) in
                make.edges.equalTo(bgImageView!.snp.edges)
            })
            self?.player?.delegate = self
            self?.player!.play()
        }
        cell.videoModel = videoModelList?[indexPath.row]
        cell.videoModel?.indexPath = indexPath
        cell.bottomView.delegate = self
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.tableView {
            if self.player == nil
            {
                return
            }
            if self.player?.superview != nil
            {
                guard let currentIndexPath = currentCell?.videoModel?.indexPath else
                {
                    return
                }
                let rectInTableView = self.tableView.rectForRow(at:currentIndexPath)
                let rectInSuperView = self.tableView.convert(rectInTableView, to: self.tableView.superview)
                
                if rectInSuperView.origin.y < -currentCell!.coverImageView.frame.height || rectInSuperView.origin.y > screenHeight
                {
                    self.releasePlayer()
                }
            }
            
        }
    }
}

extension DiscoverViewController : WMPlayerDelegate
{
    func wmplayer(_ wmplayer: WMPlayer!, clickedClose backBtn: UIButton!) {
        self.player?.pause()
        releasePlayer()
    }
    func toOrientation(orientation:UIInterfaceOrientation){
    //获取到当前状态条的方向
        let currentOrientation : UIInterfaceOrientation = UIApplication.shared.statusBarOrientation;
    self.player?.removeFromSuperview();
        if player == nil
        {
            return
        }
    //根据要旋转的方向,使用Masonry重新修改限制
    if (UIInterfaceOrientation.portrait == orientation) {
    self.currentCell?.coverImageView.addSubview(self.player!)
    self.player?.isFullscreen = false;
    self.player?.backBtnStyle = BackBtnStyle.close
    self.player!.mas_makeConstraints({ (make) in
        make?.edges.equalTo()(self.player!.superview)
    })
    
    }else{
    UIApplication.shared.keyWindow?.addSubview(self.player!)
    self.player!.isFullscreen = true;
    self.player!.backBtnStyle = .close;
    if(currentOrientation == UIInterfaceOrientation.portrait){
    if (self.player!.playerModel.verticalVideo) {
        self.player!.mas_makeConstraints({ (make) in
            make?.edges.equalTo()(self.player!.superview)
        })
    }else{
        self.player!.mas_makeConstraints({ (make) in
            make?.width.equalTo()(screenHeight)
            make?.height.equalTo()(screenWidth)
            make?.center.equalTo()(self.player!.superview)
        })
    }
    
    }else{
    if (self.player!.playerModel.verticalVideo) {
   
        self.player!.mas_makeConstraints({ (make) in
            make?.edges.equalTo()(self.player!.superview)
        })
    }else{
   
        self.player!.mas_makeConstraints({ (make) in
            make?.width.equalTo()(screenWidth)
            make?.height.equalTo()(screenHeight)
            make?.center.equalTo()(self.player!.superview)
        })
    }
    
    }
    }
        if (self.player!.playerModel.verticalVideo) {
            self.setNeedsStatusBarAppearanceUpdate()
        }else{
            UIApplication.shared.setStatusBarOrientation(orientation, animated: false)  //更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
            //给你的播放视频的view视图设置旋转
            UIView.animate(withDuration: 0.4) {
                self.player?.transform = CGAffineTransform.identity
                self.player?.transform = WMPlayer.getCurrentDeviceOrientation()
                self.player?.layoutIfNeeded()
                self.setNeedsStatusBarAppearanceUpdate()
            }
          
        }
    }
    func wmplayer(_ wmplayer: WMPlayer!, singleTaped singleTap: UITapGestureRecognizer!) {
        if wmplayer.isFullscreen == false
        {
        let vc = VideoViewController()
        vc.playerModel = wmplayer.playerModel
        vc.player = wmplayer
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        releasePlayer()
        }else
        {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    func wmplayer(_ wmplayer: WMPlayer!, clickedPlayOrPause playOrPauseBtn: UIButton!) {
        
    }
    func wmplayer(_ wmplayer: WMPlayer!, clickedFullScreenButton fullScreenBtn: UIButton!) {
        if (wmplayer.isFullscreen) {
            self.toOrientation(orientation: UIInterfaceOrientation.portrait)
        }else{
          self.toOrientation(orientation: .landscapeRight)
        }
    }
}

extension DiscoverViewController : DiscoverCellBottomViewClickDelegate
{
    func clickCommentButton(bottomView: DiscoverCellBottomView) {
        
    }
}
