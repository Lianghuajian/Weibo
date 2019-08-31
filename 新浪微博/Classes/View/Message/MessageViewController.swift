//
//  MassageTableViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/3.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
//var currenPage = 1
fileprivate let titleCellID = "titleCellID"
fileprivate let titleItemSize = CGSize.init(width: screenWidth*0.25, height: 30)

let backColor = UIColor.init(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)

class MessageViewController: VisitorViewController {
    //MARK: - 生命周期

    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.shared.userLoginStatus {
            self.navigationItem.title = "消息"
            visitorview?.setUpInfo(imagename: "visitordiscover_image_message", text: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知。")
            return
        }
       self.navigationItem.title = nil
        //添加数据
        setUp()
        preparePageViewController()
        prepareTitleCollectionView()
        setFirstViewController()
    }
    //MAKR: - 控件布局
    func setUp()
    {
        titles = ["Notice","Massage"]
        
//            let tbv = UITableViewController.init()
//            if i == 0{
//             tbv.view.backgroundColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1)
//            tbv.tableView.isHidden = true
//            }else {
//            tbv.tableView.backgroundColor = backColor
//            }
            controllers.append(NotifyViewController())
            controllers.append(MessageTableViewController())
    }
    
    func preparePageViewController()
    {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.view.subviews.forEach { (v) in
            (v as? UIScrollView)?.delegate = self
        }
    }
    override func viewSafeAreaInsetsDidChange() {

        super.viewSafeAreaInsetsDidChange()
        if controllers.isEmpty
        {
            return
        }
        let insets = self.view.safeAreaInsets

        self.pageViewController.view.frame = CGRect.init(x: 0, y: insets.top, width: screenWidth, height:screenHeight -  insets.bottom + insets.top)
        //让notifyTableViewControllerd的label在safeArea中间
        (controllers.first as! NotifyViewController).label.frame =  CGRect.init(x: screenWidth/2-80, y: (screenHeight-insets.top-insets.bottom)/2-10,width: 160 ,height:20)
        
        
    }
    func prepareTitleCollectionView()
    {
        self.navigationItem.titleView = titleCollectionView
        
        titleCollectionView.frame = CGRect.init(x: screenWidth * 0.25, y: 0, width: screenWidth*0.5, height: 44)
        titleCollectionView.addSubview(bottomTail)
        titleCollectionView.delegate = self
        titleCollectionView.dataSource = self
        titleCollectionView.register(TitleCollectionCell.self, forCellWithReuseIdentifier: titleCellID)
//        print(navigationController?.navigationItem)
    }
    func setFirstViewController(){
    self.pageViewController.setViewControllers([controllers[currentIndex]], direction: .forward, animated: true, completion: nil)
    }
    //MARK: - 懒加载属性
    ///pageViewController
    lazy var pageViewController: UIPageViewController = {
        let pgvc = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing:0])
        return pgvc
    }()

    ///头部标题数组
    lazy var titles = [String]()
    ///存储当前VC的index
    var currentIndex = 1
    
    ///存储将要移动到的VC的index
    var pendingIndex = 0
    
    ///控制器数组
    lazy var controllers = [UIViewController]()
    ///头部collectionView
    lazy var titleCollectionView : UICollectionView = {
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: TitleFlowLayout())
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var bottomTail : UIView = {
        let v = UIView.init(frame: CGRect.init(x: titleItemSize.width*0.325 + (CGFloat(currentIndex)*titleItemSize.width), y: 34, width: titleItemSize.width*0.35, height: 4))
       
        v.backgroundColor = .orange
        v.layer.cornerRadius = 2.5
        v.clipsToBounds = true
        return v
    }()
    ///头部collectionView的item布局
    private class TitleFlowLayout : UICollectionViewFlowLayout
    {
        override func prepare() {
            super.prepare()
            itemSize = titleItemSize
            scrollDirection = .horizontal
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            collectionView?.allowsMultipleSelection = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
    func currentItemRect(i : Int) ->CGRect
    {
        return CGRect.init(x: titleItemSize.width*0.325 + (CGFloat(i)*titleItemSize.width), y: 34, width: titleItemSize.width*0.35, height: 4)
    }
}

//MARK: - titleCollectionView代理
extension MessageViewController : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellID, for: indexPath) as! TitleCollectionCell
        if currentIndex == indexPath.row
        {
            cell.title.textColor = .orange
        }else
        {
            cell.title.textColor = .black
        }
        switch indexPath.row {
        case 0:
            cell.title.text = "Notice"
        case 1:
            cell.title.text = "Message"
        default:
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row > currentIndex
        {       currentIndex = indexPath.row
            pageViewController.setViewControllers([controllers[currentIndex]], direction: .forward, animated: true)
        }else
        {
                currentIndex = indexPath.row
            pageViewController.setViewControllers([controllers[currentIndex]], direction: .reverse, animated: true)
        }
        
        let newRect = self.currentItemRect(i: indexPath.row)
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomTail.frame = newRect
        }) { (finished) in
            if finished
            {
                collectionView.reloadData()
            }
        }
    }
}

//MARK: - pageViewController代理
extension MessageViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource
{
    
    //往前滚
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = controllers.firstIndex(of: viewController),index != 0 else {
            return nil
        }
        index -= 1
        return controllers[index]
    }
    //往后滚
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = controllers.firstIndex(of: viewController),index < titles.count-1 else{
            return nil
        }
        index += 1
        
        return controllers[index]
    }
    
    //将要滑动，更新currentIndex
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = self.controllers.firstIndex(of: pendingViewControllers.first!)!
    }
    //滑动结束，把titleCV滚动到新的地方
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //看看动画完成后当前展示的view和想要展示的view是不是一样，如果一样就证明的确翻页了，更新titleCollectionView
        if controllers.firstIndex(of: pageViewController.viewControllers!.first!) == pendingIndex
        {
            self.currentIndex = pendingIndex
            
            self.titleCollectionView.scrollToItem(at: IndexPath.init(row: self.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomTail.frame = self.currentItemRect(i: self.currentIndex)
            }) { (finished) in
                if finished
                {
                    self.titleCollectionView.reloadData()
                }
            }
        }
    }
}


//MARK: - 自定义titleCell
class TitleCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    func setUpUI()
    {
        self.contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView.snp.center)
            make.height.equalTo(self.contentView.snp.height)
            make.width.equalTo(self.contentView.snp.width)
        }
    }
    lazy var title = UILabel.init(size: 16, content: "", color: .black, alignment: .center, lines: 1, breakMode: .byTruncatingTail)
}
extension MessageViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //头部collectionView也会进来，所以要规避一下
//        if scrollView.isKind(of: UICollectionView.self)
//        {
//            return
//        }
//        if currentIndex == 0
//        {
//            if scrollView.contentOffset.x < screenWidth
//            {
//                scrollView.contentOffset = CGPoint.init(x: screenWidth,y: 0)
//            }
//        }else if currentIndex == 1
//        {
//            if scrollView.contentOffset.x > screenWidth
//            {
//                scrollView.contentOffset = CGPoint.init(x:screenWidth,y:0)
//            }
//        }
    }
}
