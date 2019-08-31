////
////  PageViewController.swift
////  UIPageViewControllerDemo
////
////  Created by 梁华建 on 2019/6/20.
////  Copyright © 2019 梁华建. All rights reserved.
////
//
//import UIKit
//
//let titleItemID = "titleItemID"
//
//class PageViewController: UIPageViewController{
//
//    ///titleCollectionView的item大小
//    var titleItemSize : CGSize = CGSize.init(width: 60, height: 44)
//
//    ///存储当前VC的index,默认为0
//    var currentIndex = 0
//
//    ///存储将要移动到的VC的index
//    var pendingIndex = 0
//
//    var onNavigationBar : Bool = false
//
//    convenience init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil,titleItemSize:CGSize,titles:[String], onNavigationBar : Bool) {
//        self.init(transitionStyle: style, navigationOrientation: .horizontal, options: options )
//        self.titleItemSize = titleItemSize
//        self.titleArray = titles
//       titleFlowLayout.itemSize = titleItemSize
//        self.onNavigationBar = onNavigationBar
//    }
//    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
//        super.init(transitionStyle: style, navigationOrientation:.horizontal, options: options)
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//       prepageTitleCollecitonView()
//        self.delegate = self
//        self.dataSource = self
//        // Do any additional setup after loading the view.
//    }
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//
//    }
//    ///视图布局
//    func prepageTitleCollecitonView()
//    {
//
//        titleCV.delegate = self
//
//        titleCV.dataSource = self
//
//        titleCV.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: titleItemID)
//        titleCV.addSubview(bottomTail)
//        if onNavigationBar{
//            self.navigationController?.view.addSubview(titleCV)
//            return
//        }
//
//         self.view.addSubview(titleCV)
//    }
//
//    //MARK: - 懒加载属性
//    ///标题collecitonView
//    lazy var titleCV : UICollectionView =
//    {
//        var cv : UICollectionView!
//
//       if CGFloat(titleArray.count) * titleItemSize.width < screenWidth
//       {
//        //CollectionView居中
//        cv = UICollectionView.init(frame: CGRect.init(x: (screenWidth-CGFloat(titleArray.count) * titleItemSize.width)/2,y:0, width: CGFloat(titleArray.count) * titleItemSize.width, height: 44), collectionViewLayout: titleFlowLayout)
//        cv.backgroundColor = .white
//        return cv
//       }
//
//        cv = UICollectionView.init(frame: CGRect.init(x: 0,y:0, width: UIScreen.main.bounds.size.width, height: 44), collectionViewLayout: titleFlowLayout)
//
//        cv.backgroundColor = .white
//
//        return cv
//    }()
//
//    lazy var bottomTail : UIView = {
//        let v = UIView.init(frame: CGRect.init(x: self.titleItemSize.width/4, y: 34, width: self.titleItemSize.width/2, height: 4))
//        v.backgroundColor = .orange
//        v.layer.cornerRadius = 2.5
//        v.clipsToBounds = true
//        return v
//    }()
//    ///controller数组
//    lazy var controllers = [UIViewController]()
//
//    ///标题名字数组
//    var titleArray : [String]!
//
//    private lazy var titleFlowLayout : TitleFlowLayout = TitleFlowLayout()
//    ///标题collectionView的布局
//    private class TitleFlowLayout : UICollectionViewFlowLayout {
//        override func prepare() {
//            super.prepare()
////            itemSize = CGSize.init(width: 100, height: 44)
//            scrollDirection = .horizontal
//            minimumLineSpacing = 0
//            minimumInteritemSpacing = 0
//            collectionView?.showsHorizontalScrollIndicator = false
//        }
//    }
//
//}
////MARK: - CollectionView的代理方法
//extension PageViewController : UICollectionViewDelegate , UICollectionViewDataSource
//{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return titleArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let item = collectionView.dequeueReusableCell(withReuseIdentifier: titleItemID, for: indexPath) as! TitleCollectionViewCell
//
//        item.titleLabel.frame = CGRect.init(x: 0, y: 10, width: titleItemSize.width , height: 16)
//        if indexPath.row == currentIndex
//        {
//            item.titleLabel.textColor = .orange
//        }else
//        {
//            item.titleLabel.textColor = .black
//        }
//        item.titleLabel.text = titleArray[indexPath.row]
//        return item
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row != currentIndex
//        {
//            if indexPath.row > currentIndex
//            {
//                self.setViewControllers([controllers[indexPath.row]], direction: .forward, animated: true, completion: nil)
//            }else
//            {
//                self.setViewControllers([controllers[indexPath.row]], direction: .reverse, animated: true, completion: nil)
//            }
//            currentIndex = indexPath.row
//            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            collectionView.reloadData()
//            let newRect = currentItemRect(i: indexPath.row)
//            UIView.animate(withDuration: 0.5, animations: {
//                self.bottomTail.frame = newRect
//            }) { (finished) in
//                if finished
//                {
//                    collectionView.reloadData()
//                }
//            }
//        }
//    }
//
//    func currentItemRect(i : Int) ->CGRect
//    {
//        return CGRect.init(x: self.titleItemSize.width/4 + (CGFloat(i)*self.titleItemSize.width), y: 34, width: titleItemSize.width/2, height: 4)
//    }
//// var pendingIndex = 0
//}
//
////MARK: - PageViewController的代理方法
//extension PageViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource
//{
//    //向前滚动
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard var index = self.controllers.firstIndex(of: viewController)  else {
//            return nil
//        }
//
//        if index == 0
//        {
//            return nil
//        }
//
//        index -= 1
//
//        return self.controllers[index]
//    }
//    //向后滚动
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//
//
//        guard var index = self.controllers.firstIndex(of: viewController) else {
//            return nil
//        }
//        if index == self.controllers.count-1
//        {
//            return nil
//
//        }
//        index += 1
//
//        return self.controllers[index]
//    }
//
//    //将要滑动，更新currentIndex
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        pendingIndex = self.controllers.firstIndex(of: pendingViewControllers.first!)!
//    }
//    //滑动结束，把titleCV滚动到新的地方
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        //看看动画完成后当前展示的view和想要展示的view是不是一样，如果一样就证明的确翻页了，更新titleCollectionView
//       if controllers.firstIndex(of: pageViewController.viewControllers!.first!) == pendingIndex
//       {
//        self.currentIndex = pendingIndex
//
//        self.titleCV.scrollToItem(at: IndexPath.init(row: self.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
//
//        UIView.animate(withDuration: 0.5, animations: {
//            self.bottomTail.frame = self.currentItemRect(i: self.currentIndex)
//        }) { (finished) in
//            if finished
//            {
//                self.titleCV.reloadData()
//            }
//        }
//        }
//    }
//}
