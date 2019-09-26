//
//  UserDetailViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/11.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

private let margin = 10
//用于判断导航条的隐藏与否
let kNavBarBottom = WRNavigationBar.navBarBottom()
private let NAVBAR_COLORCHANGE_POINT:CGFloat = screenHeight*0.377 - CGFloat(kNavBarBottom * 2)

class UserDetailViewController: UIViewController {
   
    var statusViewModel : StatusViewModel?
    {
        didSet
        {
            headerView.statusViewModel = statusViewModel
        }
    }
    //MARK: - 生命周期
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagingView.frame = self.view.bounds
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        DispatchQueue.main.async {
        self.setUpUI()
        //        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (categoryView.selectedIndex == 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    //MARK: - 初始化控件和布局视图
    func setUpUI() {
        //初始化分类view
        prepareCategoryView()
        //初始化各容器视图
        preparePagingView()
        //初始化导航栏
        prepareNavigationBar()
    }

    func prepareNavigationBar()
    {
//        self.automaticallyAdjustsScrollViewInsets = false
        pagingView.mainTableView.contentInsetAdjustmentBehavior = .never
        let topSafeMargin = UIApplication.shared.keyWindow!.jx_layoutInsets().top
        let naviHeight = UIApplication.shared.keyWindow!.jx_navigationHeight()
        //导航栏隐藏就是设置pinSectionHeaderVerticalOffset属性即可，数值越大越往下沉
        pagingView.pinSectionHeaderVerticalOffset = Int(naviHeight)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "··· ", style: .done, target: nil, action: nil)
        
        // 设置导航栏颜色
        navBarBarTintColor = UIColor.init(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
        
        // 设置初始导航栏透明度
        navBarBackgroundAlpha = 0
        
        // 设置导航栏按钮和标题颜色
        navBarTintColor = .white
        
    }
    
    @objc func naviBack(){
        self.navigationController?.popViewController(animated: true)
    }
    func prepareCategoryView() {
        categoryView.titles = titles
        categoryView.backgroundColor = UIColor.white
        categoryView.titleSelectedColor = .orange
        categoryView.titleColor = .black
        categoryView.isTitleColorGradientEnabled = true
        categoryView.isTitleLabelZoomEnabled = true
        categoryView.delegate = self
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorLineViewColor = .orange
        lineView.indicatorLineWidth = 30
        categoryView.indicators = [lineView]
        let lineWidth = 1/UIScreen.main.scale
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.lightGray
        bottomLineView.frame = CGRect(x: 0, y: categoryView.bounds.height - lineWidth, width: categoryView.bounds.width, height: lineWidth)
        bottomLineView.autoresizingMask = .flexibleWidth
        categoryView.addSubview(bottomLineView)
    }
    
    func preparePagingView()  {
        pagingView.mainTableView.gestureDelegate = self
        
        self.view.addSubview(pagingView)
        
        categoryView.contentScrollView = pagingView.listContainerView.collectionView
        
        //防止他在右滑过程中pop出navigation栈
        pagingView.listContainerView.collectionView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
    }
    
    //MARK: - 成员变量
    //占屏幕高度比例0.377
    weak var nestContentScrollView: UIScrollView?
    
    lazy var headerView : UserHeadView = {
        
        let uhv = UserHeadView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight*0.377))
        
        return uhv
    }()
    
    ///分类的视图 高度为屏幕高的0.074
    lazy var categoryView = JXCategoryTitleView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight*0.074))
    ///分类名称数组
    lazy var titles = ["Profile","Weibo","Album"]
    
    lazy var pagingView = JXPagingView.init(delegate: self)
    
    var isNeedHeader = false
    
    var isNeedFooter = false
    
}
//MARK: - CategoryView的代理
extension UserDetailViewController : JXCategoryViewDelegate
{
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index==0)
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didClickedItemContentScrollViewTransitionTo index: Int){
        //请务必实现该方法
        //因为底层触发列表加载是在代理方法：`- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath`回调里面
        //所以，如果当前有5个item，当前在第1个，用于点击了第5个。categoryView默认是通过设置contentOffset.x滚动到指定的位置，这个时候有个问题，就会触发中间2、3、4的cellForItemAtIndexPath方法。
        //如此一来就丧失了延迟加载的功能
        //所以，如果你想规避这样的情况发生，那么务必按照这里的方法处理滚动。
        self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        
        
        //如果你想相邻的两个item切换时，通过有动画滚动实现。未相邻的两个item直接切换，可以用下面这段代码
        /*
         let diffIndex = abs(categoryView.selectedIndex - index)
         if diffIndex > 1 {
         self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
         }else {
         self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
         }
         */
    }
}
//MARK: - PagingView的代理
extension UserDetailViewController : JXPagingViewDelegate
{
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return Int(headerView.bounds.height)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headerView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(categoryView.bounds.size.height)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return categoryView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let tableview = UserStatusTableView()
        tableview.naviController = self.navigationController
        tableview.statusViewModel = self.statusViewModel
        return tableview
    }
    
}
//MARK: - PagingView的滚动代理
extension UserDetailViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //禁止Nest嵌套效果的时候，上下和左右都可以滚动
        if otherGestureRecognizer.view == nestContentScrollView {
            return false
        }
        //禁止categoryView左右滑动的时候，上下和左右都可以滚动
        if otherGestureRecognizer == categoryView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder())
    }
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        if (offsetY > NAVBAR_COLORCHANGE_POINT)
        {
            let alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / CGFloat(kNavBarBottom)
            navBarBackgroundAlpha = alpha
            navBarTintColor = UIColor.black.withAlphaComponent(alpha)
            navBarTitleColor = UIColor.black.withAlphaComponent(alpha)
            statusBarStyle = .default
            title = statusViewModel?.user?.screen_name
        }
        else
        {
            navBarBackgroundAlpha = 0
            navBarTintColor = .white
            navBarTitleColor = .white
            statusBarStyle = .lightContent
            title = ""
        }
   }
}
