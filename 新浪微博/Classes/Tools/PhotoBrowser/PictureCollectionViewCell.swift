//
//  PictureCollectionViewCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/13.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
//MARK: - 点击图片代理
protocol TouchPictureDelegate : NSObjectProtocol {
    
    func touchPicture()
    
    func photoBrowserDidZoom(scale : CGFloat)
    
}

class PictureCollectionViewCell: UICollectionViewCell {
    
    var picturesSize = CGSize()
    
    //MARK: - 生命周期
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("PictureCollectionView初始化错误，不能使用xib去加载")
    }
   
    //MARK: - 功能函数
    @objc func touchImage() {
        print("touch")
        pictureDelegate?.touchPicture()
    }
    
    func setPlaceHolder(image:UIImage?,size : CGSize = CGSize.zero)  {
        
        placeholderImageView.isHidden = false
        
        placeholderImageView.image = image
        
        if size == .zero
        {
          placeholderImageView.sizeToFit()
        }else
        {
            placeholderImageView.frame = CGRect.init(x: 0, y: 0, width: size.width, height:
                          size.height)
        }
        
        
        placeholderImageView.center = scrollview.center
    }
    ///重设 scrollView 内容属性
    private func resetScrollView(){
        //重设imageView的内容属性，因为他会被cell复用 - scorllView在处理缩放的时候，是调整代理方法返回视图的transform来实现的
        imageview.transform = CGAffineTransform.identity
        self.scrollview.contentInset = UIEdgeInsets.zero
        self.scrollview.contentOffset = CGPoint.zero
        self.scrollview.contentSize = CGSize.zero
    }
    
    /// 设置图片位置
    ///
    /// - Parameter image: 需要设置的图片
    func setPosition(image: UIImage)  {
        //自动设置大小
        let size = self.displaySize(image: image)
        //判断图片高度是否高于scrollView
        if size.height < scrollview.bounds.height {
            //上下文居中显示
            self.imageview.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
           
            //调整控件位置，但是不会影响控件的滚动
            //比如屏幕500高，图片300高，我们要图片y在100，那么就可以据中了
            let y = (scrollview.bounds.height-size.height)*0.5
            //内容边距，及图片在scorllView的位置
            self.scrollview.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
            
        }else{
            //否则按照图片高度来
            self.imageview.frame = CGRect(x: 0, y: 0, width: size.width, height:size.height)
            scrollview.contentSize = size
        }
        
    }
    
    /// 让图片按比例适配屏幕
    /// 比如宽是500，屏幕宽是400 ，这时候图片宽要设置成400,高度也要*4/5才可以不改变图片的比例
    /// - Parameter image: 传入的图片
    /// - Returns: 应该显示的size
    func displaySize(image : UIImage?) -> CGSize {
        if image == nil
        {
            return CGSize.zero
        }
        
        let w = scrollview.bounds.width
        //高跟着图片宽度与w的比例走
        let h = image!.size.height*w/image!.size.width
        return CGSize.init(width: w, height: h)
    }
    
    func bmiddle(urlStirng: String) -> URL {
        
        let string = urlStirng.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
        //动图不动 则返回下面语句
        return URL(string: string)!
        
    }

        func scale(image : UIImage?, to size : CGSize ) -> UIImage?
        {
    
            UIGraphicsBeginImageContext(size)
            
            image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
    
            UIGraphicsEndImageContext()
    
            return newImage
    
        }
    
    var pictrueUrl : URL?
    {
        didSet{
            
            if pictrueUrl == nil
            {
                return
            }
           //0,恢复scrollView()
            resetScrollView()
           //1,加载缩略图地址
           let tmpImage =  SDWebImageManager.shared().imageCache?.imageFromCache(forKey:pictrueUrl?.absoluteString)
            
           let newSize = displaySize(image: tmpImage)
            
           let newImage = scale(image: tmpImage, to: newSize)
           
           setPlaceHolder(image: newImage)
            
            //2,加载大图
            let bigurl = bmiddle(urlStirng: pictrueUrl!.absoluteString)
            //大多数第三方的progress闭包都是异步执行
            //他们回调次数太多，如果太多ui涉及progress同步会造成主线程卡顿
            //大多数是添加个菊花让用户等待
            var gifURL : URL?
            
            picturesSize = newSize
            
            if pictrueUrl!.absoluteString.contains("gif")
            {
                gifURL = URL.init(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1569690015484&di=ead4099b09539baff1532c7e3014c1de&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20160419%2F2512293c057d45aa8450fa3810fc1263_th.jpg")
                
            }
            
            self.imageview.sd_setImage(with: gifURL == nil ? bigurl : gifURL!, placeholderImage: nil, options: [SDWebImageOptions.refreshCached,SDWebImageOptions.retryFailed], progress: { (current, total, _) in
                
                DispatchQueue.main.async {
                    self.placeholderImageView.progress = CGFloat(current)/CGFloat(total)
                }
                
            }) { (image, _, _, _) in
                if image == nil{
                    SVProgressHUD.showInfo(withStatus: "图像加载失败")
                    return
                }
                
                self.placeholderImageView.isHidden = true
                
                self.setPosition(image: image!)
            }
        }
    }
    
    //MARK: - 成员变量
    lazy var scrollview = UIScrollView()
    lazy var imageview = FLAnimatedImageView()
    lazy var placeholderImageView = ProgressImageView()
    weak var pictureDelegate : TouchPictureDelegate?
    var lastPosition = CGPoint.zero
    var isDragging = false
}

//MARK: - 布局
extension PictureCollectionViewCell{
    
    func setupUI(){
        
        //1,添加控件
        contentView.addSubview(scrollview)
        scrollview.addSubview(imageview)
        scrollview.addSubview(placeholderImageView)
        
        //2,布局
        var bounds = self.bounds
        bounds.size.width -= 20
        scrollview.frame = bounds
        
        //3,设置scrollView缩放属性
        scrollview.minimumZoomScale = 0.5
        
        scrollview.maximumZoomScale = 2
        
        scrollview.delegate = self
        
        //4,添加点击手势到imageView
        imageview.isUserInteractionEnabled = true
        //点击手势
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchImage)))
        //拖拽手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panPicture))
        
        panGesture.delegate = self
        
        imageview.addGestureRecognizer(panGesture)
        
    }
    
    @objc func panPicture(gesture:UIPanGestureRecognizer) {
        
        if lastPosition == .zero
        {
            lastPosition = gesture.location(in: self)
            return
        }
        
        let currentPosition = gesture.location(in: self)
        //向下拉
        if lastPosition.y < currentPosition.y
        {
            isDragging = true
            print("向下拉")
            lastPosition = .zero
        }
    
    }
    
}
extension PictureCollectionViewCell : UIGestureRecognizerDelegate
{
    //降低优先级
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        return true
//
//    }
    
    //同时响应
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
//MARK: - 滚动代理
extension PictureCollectionViewCell : UIScrollViewDelegate
{
    ///返回用于放大缩小的view
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageview
    }
    
    /// 缩放完成后执行一次
    ///
    /// - Parameters:
    ///   - scrollView: scrollView
    ///   - view: view被缩放的视图
    ///   - scale: 被缩放的比例
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        if scale < 1 {
            pictureDelegate?.touchPicture()
        }
        
        //print("view?.bounds = \(view?.bounds)")
        var offsetY = (scrollView.bounds.height - view!.frame.height)*0.5
        //出屏幕就变0 否则就停在用户停止放大的地方
        offsetY = offsetY < 0 ? 0 : offsetY
        
        var offsetX = (scrollView.bounds.width - view!.frame.width)*0.5
        //出屏幕就变0 否则就停在用户停止放大的地方
        offsetX = offsetX < 0 ? 0 : offsetX
        
        print("offsetY = ",offsetY , "offsetX = ",offsetX)
        //让他停留在缩放后的位置
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        
    }
    
    ///只要缩放就会被调用
    /*
     *transform在改变
     *frame = center + bounds * transform
    */
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        pictureDelegate?.photoBrowserDidZoom(scale: imageview.transform.a)
    }
    
}

func downsample(imageAt imageURL:URL,to pointSize:CGSize,scale:CGFloat)->UIImage{
    
    let imageSourceOptions = [kCGImageSourceShouldCache : false] as CFDictionary
    //创建一个图片资源，但是我们告诉系统先不要缓存
    let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL , imageSourceOptions)!
    //缓存实际展示大小 = 长宽*像素(scale是像素点,iphone一般是1，2，3)
    
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    
    let downsampleOptions =
        [kCGImageSourceShouldCacheImmediately : true,
         kCGImageSourceCreateThumbnailFromImageAlways : true,
         kCGImageSourceCreateThumbnailWithTransform : true,
         kCGImageSourceThumbnailMaxPixelSize:maxDimensionInPixels] as CFDictionary
    
    let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
    
    return UIImage.init(cgImage: downsampledImage)
    
}
