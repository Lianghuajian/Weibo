//
//  PhotoBrowserViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/13.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SVProgressHUD
let pictureCellID = "pictureCellID"

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
    //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
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

        setupUI()
        
    }
    //viewDidLoad:用于添加数据给UI或其他操作
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        //根据用户点击显示当前图片
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    init(urls:[URL],indexPath : IndexPath) {
        
        self.urls = urls
        
        self.currentIndexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载控件
    lazy var collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: PictureCollectionsFlowLayout())
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
}

//MARK: - UI布局
extension PhotoBrowserViewController{
    
    func setupUI() {
        
        //1，添加控件
        self.view.addSubview(collectionView)
        self.view.addSubview(saveBtn)
        self.view.addSubview(closeBtn)
        collectionView.frame = view.bounds
        saveBtn.layer.cornerRadius = 15
        saveBtn.layer.masksToBounds = true
        closeBtn.layer.cornerRadius = 15
        closeBtn.layer.masksToBounds = true
        
        //2，添加布局
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.snp.right).offset(-36)
            make.bottom.equalTo(self.view.snp.bottom).offset(-36)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(16)
            make.bottom.equalTo(self.view.snp.bottom).offset(-36)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        //3，添加监听
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        //4，准备collectionView
        prepareCollectionView()
    }
    ///collectionView的布局
    func prepareCollectionView() {
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: "pictureCellID")
        collectionView.dataSource = self
    }
}

//MARK: - collectionView的代理方法
extension PhotoBrowserViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureCellID, for: indexPath) as! PictureCollectionViewCell
        
        cell.pictrueurl = urls[indexPath.item]
        
        cell.pictureDelegate = self
        
        return cell
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
