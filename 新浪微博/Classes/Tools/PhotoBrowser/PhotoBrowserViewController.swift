//
//  PhotoBrowserViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/13.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SVProgressHUD
fileprivate let pictureCellID = "pictureCellID"

class PhotoBrowserViewController: UIViewController {
    
    ///URL图片数组
    var urls : [URL]
    ///用户选择的当前图片
    var currentIndexPath : IndexPath
    
    //MARK: - 按钮监听方法
    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save(){
        let cell = collectionView.visibleCells[0] as! PictureCollectionViewCell
        //cell中是否有图片
        guard let image = cell.imageview.image else{
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    //保存图片的Selector应有的格式
    @objc func image(image:UIImage,didFinishSavingWithError error : NSError? , contextInfo: AnyObject?) {
        
        let message = (error == nil) ? "保存成功" : "保存失败"
        
        SVProgressHUD.showInfo(withStatus: message)
        
    }
    
    //MARK: - 生命周期
    //loadView:用于设置视图层次结构，系统调用view的getter方法时候发现view为nil就会调用该方法
    override func loadView() {
        
        var bounds = UIScreen.main.bounds
        
        bounds.size.width += 20
        
        view = UIView(frame:bounds)
        
    }
    //viewDidLoad:用于添加数据给UI或其他操作
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //跳转完毕后再进行布局，否则会出现卡屏
        self.setupUI()
        //根据用户点击显示当前图片
        self.collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: false)
        
        
    }
    init(urls:[URL],indexPath : IndexPath) {
        
        self.urls = urls
        
        self.currentIndexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 成员变量
    lazy var collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: PictureCollectionsFlowLayout())
    
    lazy var pageController = UIPageControl()
    
    lazy var saveBtn = UIButton.init(text: "保存", textColor: .white, backImage: nil, isBack: false,backgroundColor : .lightGray)
    
    lazy var closeBtn = UIButton.init(text: "取消", textColor: .white, backImage: nil, isBack: false,backgroundColor : .lightGray)
    //MAKR: - collectionView布局
    private class PictureCollectionsFlowLayout : UICollectionViewFlowLayout{
        override func prepare() {
            
            super.prepare()
            
            itemSize = self.collectionView!.bounds.size
            
            minimumLineSpacing = 0
            
            minimumInteritemSpacing = 0
            
            scrollDirection = .horizontal
            
            collectionView?.bounces = true
            
            collectionView?.isPagingEnabled = true
            
        }
    }
    deinit {
        print(#file,#function)
    }
}

//MARK: - UI布局
extension PhotoBrowserViewController{
    
    func setupUI() {
  
        self.view.addSubview(collectionView)
        
        self.view.insertSubview(pageController, aboveSubview: collectionView)
        
        collectionView.frame = view.bounds
        
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: "pictureCellID")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        pageController.numberOfPages = urls.count
        
        pageController.frame.size = CGSize.init(width: urls.count * 33, height: 44)
        
        pageController.frame.origin = CGPoint.init(x: (screenWidth - pageController.frame.size.width ) / 2 , y:screenHeight * 0.85 )
    
    }
  
}

//MARK: - collectionView的代理方法
extension PhotoBrowserViewController : UICollectionViewDataSource , UICollectionViewDelegate
{
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let currentRow = collectionView.indexPath(for: collectionView.visibleCells[0])?.row else
        {
            return
        }
        pageController.currentPage = currentRow
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureCellID, for: indexPath) as! PictureCollectionViewCell
        
        cell.pictrueUrl = urls[indexPath.item]
        
        cell.pictureDelegate = self
        
        cell.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(pressPictrue(gesture:))))
        
        return cell
    }
    
    @objc func pressPictrue(gesture:UILongPressGestureRecognizer)
    {
        
        let alertController = AlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(title: "发送", style: .default) { (action) in
           
            SVProgressHUD.showSuccess(withStatus: "发送给朋友成功")
        }.addAction(title: "保存", style: .default) { (action) in
            //保存图片
            guard let image = (gesture.view as? PictureCollectionViewCell)?.imageview.image else
            {
                SVProgressHUD.showSuccess(withStatus: "图片失效")
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.finishSavingPhotoToAlbum(image:error:contextInfo:)), nil)
            
        }.addAction(title: "编辑", style: .default) { (action) in
            //保存图片
            SVProgressHUD.showSuccess(withStatus: "编辑图片成功")
        }
        .addAction(title: "取消", style: .default) { (action) in
            //取消
            return
        }
         
        self.present(alertController, animated: true) {
        }
        
    }
    
    @objc func finishSavingPhotoToAlbum(image : UIImage? , error : NSError? , contextInfo : AnyObject?)
    {
        if error != nil {
            dump(error)
            SVProgressHUD.showInfo(withStatus: "保存图片失败")
            return
        }
        SVProgressHUD.showSuccess(withStatus: "保存图片成功")
    }
        
}

//MARK: - 图片点击代理
extension PhotoBrowserViewController : TouchPictureDelegate
{
    func photoBrowserDidZoom(scale: CGFloat) {
        //CollectionViewController里面 view中装载着collectionView
        let ishidden = scale < 1
        
        hideControls(isHidden: ishidden)
        
        if scale < 1 {
            view.alpha = scale
            view.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }else{
            view.alpha = 1
            view.transform = CGAffineTransform.identity
        }
    }
    
    func hideControls(isHidden : Bool)
    {
        closeBtn.isHidden = isHidden
        saveBtn.isHidden = isHidden
        collectionView.backgroundColor = isHidden ? UIColor.clear : UIColor.black
    }
    
    func touchPicture()
    {
        close()
    }
}

//MARK: - 图片dismiss代理
extension PhotoBrowserViewController : PhotoBrowserDismissDelegate{
    ///制作动画的大图替身，做完动画后被deinit
    func PhotoDimissForAnimation() -> UIImageView? {
        
        guard let cell = self.collectionView.visibleCells[0] as? PictureCollectionViewCell else{
            return nil
        }
        
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        
        imageView.image = cell.imageview.image
        
        imageView.frame = cell.scrollview.convert(cell.imageview.frame, to: UIApplication.shared.keyWindow!)
        
        
        return imageView
    }
    
    func CurrentIndexPath() -> IndexPath? {
        return self.collectionView.indexPathsForVisibleItems[0]
    }
    
}
