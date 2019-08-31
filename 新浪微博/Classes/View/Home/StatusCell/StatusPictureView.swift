//
//  StatusPictureView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/26.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SDWebImage
import QorumLogs
let pictureMargins : CGFloat = 6
let CollectionViewCellID = "CollectionViewCellID"

class StatusPictureView: UICollectionView {
    
    var viewModel : StatusViewModel?
    {
        didSet{
            sizeToFit()
            //如果不reloadData cell会被重用，不会去调用dataSource方法
            reloadData()
        }
    }
    
    ///sizeToFits内部会调用
    override func sizeThatFits(_ size: CGSize) -> CGSize
    {
        return caculateSize()
    }
    
    init()
    {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = pictureMargins
        layout.minimumInteritemSpacing = pictureMargins
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        //设置自己为数据源，比较小的自定义视图
        dataSource = self
        delegate = self
        register(PictrueViewCell.self, forCellWithReuseIdentifier: CollectionViewCellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - 计算总图片宽高
extension StatusPictureView
{
    ///通过图片数量 计算大小
    func caculateSize() ->CGSize
    {
        let column : CGFloat = 3
        
        let count = viewModel?.thumbnails?.count ?? 0
        //print("viewModel?.thumbnails?.count = \(viewModel?.thumbnails?.count)")
        if count == 0
        {
            return CGSize.zero
        }
        
        let itemwidth = ((UIScreen.main.bounds.size.width - 2 * StatusCellMargins)-2*pictureMargins)/3
        //拿到collectionItem 把他们都设置成正方形
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize.init(width: itemwidth, height: itemwidth)
        
        //1,一张图片的时候特殊处理
        if count == 1 {
            var size = CGSize.init(width: 150, height: 120)
            //key是URL的绝对地址 使用MD5加密
            if let url = viewModel?.thumbnails?.first?.absoluteString {
                //小图
                if let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: url)
                {
                size = image.size
                }
            }
            //过窄图片
            size.width = size.width < 40 ? 40 : size.width
            //过宽图片
            if size.width > 300{
                let w : CGFloat = 300
                let h = size.height * w / size.width
                size = CGSize(width: w, height: h)
            }
            
            layout.itemSize = size
            
            return size
        }
        
        let row = CGFloat((count - 1)/Int(column) + 1)
        
        //2,4张图片的时候显示上下各两个pic
        if count == 4 {
            let w = itemwidth*2+pictureMargins
            return CGSize.init(width: w, height: w)
        }
        
        //3,其他count
        //防止浮点数的影响布局
        let h = row * itemwidth + (row-1)*pictureMargins + 1
        
        let w = column * itemwidth + (column-1)*pictureMargins + 1
        
        //print("H = \(h) ----------------------------------- W = \(w)")
        
        return CGSize.init(width: w, height: h)
        
    }
}
//MARK: - 代理方法
extension StatusPictureView :UICollectionViewDataSource,UICollectionViewDelegate{
    ///点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //发布通知
        
        //把选中的item，index和该条微博所有图片url
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBPictureCellSelectNotification), object: self, userInfo: [WBPictureCellIndexNotification:indexPath,
                                                                                                    WBPictureArrayNotification: viewModel!.thumbnails!])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnails?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CollectionViewCellID , for: indexPath) as! PictrueViewCell
        
        cell.imageURL = viewModel!.thumbnails![indexPath.item]
        //cell.backgroundColor = UIColor.red
        return cell
        
    }
}

//MARK: - Present代理
extension StatusPictureView : PhotoBrowserPresentDelegate
{
    func PhotoPresentForAnimation(indexPath: IndexPath) -> UIImageView {
        
        let iv = UIImageView()
        
        //1,设置填充模式
        iv.contentMode = .scaleToFill
        
        iv.clipsToBounds = true
        
        //2,从本地加载缩略图片
        if let url = self.viewModel?.thumbnails![indexPath.item]{
            //如果本地存在图片就不会去下载
            iv.sd_setImage(with: url, completed: nil)
        }
        return iv
    }
    
    ///获取大图的rect
    func PhotoBrowserPresentToRect(indexPath: IndexPath) -> CGRect {
        
        guard let url = self.viewModel?.thumbnails![indexPath.item].absoluteString else{
            return CGRect.zero
        }
        
        guard  let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: url) else {
            return CGRect.zero
        }
        
        //根据缩略图大小，计算全屏的大小
        //所以这里只需要拿到缩略图就行了
        let w = UIScreen.main.bounds.width
        
        let h = image.size.height * w / image.size.width
        
        let screeenHeight =  UIScreen.main.bounds.height
        
        var y : CGFloat = 0
        
        //处理图片过长的情况
        if h < screeenHeight {
            
            y = (screeenHeight - h) * 0.5
            
        }
        
        let rect = CGRect.init(x: 0, y: y, width: w, height: h)
        
        //测试代码
//        let v = PhotoForAnimation(indexPath: indexPath)
//
//        v.frame = rect
//        
//        UIApplication.shared.keyWindow?.addSubview(v)
        
        return rect
        
    }
    ///获取缩略图的rect
    func PhotoBrowserPresentFromRect(indexPath: IndexPath) -> CGRect {
        
        //1,获取图片所在cell
        let cell = self.cellForItem(at: indexPath)
        
        //2,坐标转换
        //当前cell在UIScreen的位置
        //self(collectionView)是cell的父视图
        let rect = self.convert(cell!.frame, to: UIApplication.shared.keyWindow)
        //测试代码
        //let imageView = PhotoForAnimation(indexPath: indexPath)
        //
        //imageView.frame = rect
        //
        //UIApplication.shared.keyWindow?.addSubview(imageView)
        
        return rect
        
    }
    
}

///MARK :-图片cell
private class PictrueViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(iconView)
        iconView.addSubview(gifView)
        
        gifView.sizeToFit()
        //cell会改变
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
        }
        gifView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.iconView.snp.bottom)
            make.right.equalTo(self.iconView.snp.right)
        }
    }

    var imageURL : URL?{
        didSet{
            iconView.sd_setImage(with: imageURL!, placeholderImage: nil, options: [SDWebImageOptions.retryFailed    //超过15s就记录防止再次访问
                ,SDWebImageOptions.refreshCached//防止URL不变数据源变了，及时更新
                ], completed: nil)
            if (imageURL!.absoluteString as NSString).pathExtension == "gif"
            {
                self.gifView.isHidden = false
            }else
            {
                self.gifView.isHidden = true
            }
        }
    }
    
    //懒加载要指明类型，否则其他地方调用不清楚其属性
    private lazy var iconView : UIImageView = {
        
        let iv =  UIImageView()
        //多出来的裁减掉，留中间
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    //gif标记
    private lazy var gifView : UIImageView = UIImageView.init(image: UIImage.init(named: "timeline_image_gif"))
}

