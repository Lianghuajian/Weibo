//
//  PhotoBrowserTransitioningDelegate.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/16.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
//MARK: - 图片present的代理
protocol PhotoBrowserPresentDelegate : NSObjectProtocol{
    
    func PhotoBrowserPresentFromRect(indexPath : IndexPath) -> CGRect
    func PhotoBrowserPresentToRect(indexPath : IndexPath) -> CGRect
    ///返回当前ImageView（在present中作为替身，完成动画后会被deinit）
    func PhotoPresentForAnimation(indexPath : IndexPath) -> UIImageView
    
}
//MARK: - 图片dismiss的代理
/// 我们要拿到参与制作动画的替身及其位置，以及当前indexPath
protocol PhotoBrowserDismissDelegate : NSObjectProtocol{
    ///返回当前ImageView（在dismiss中作为替身，完成动画后会被deinit）
    func PhotoDimissForAnimation() -> UIImageView?
    func CurrentIndexPath() -> IndexPath?
}
//MARK: - 实现转场的代理
class PhotoBrowserTransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
    
    //设置Photo展现的代理
    weak var PhotoPresentDelegate : PhotoBrowserPresentDelegate?
    //设置Photo解除视图的代理
    weak var PhotoDismissDelegate : PhotoBrowserDismissDelegate?
    //当前点击item的index，用于计算图片位置
    var indexPath : IndexPath?
    //一键设置present和dismiss代理
    func setPhotoDelegate(indexPath : IndexPath ,
                          presentDelegate : PhotoBrowserPresentDelegate,
                          dismissDelegate : PhotoBrowserDismissDelegate){
        
        self.PhotoPresentDelegate = presentDelegate
        self.PhotoDismissDelegate = dismissDelegate
        self.indexPath = indexPath
    }
    
    var forPresented = false
    
    //返回完成present转场动画的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        forPresented = true
        return self
    }
    
    //返回完成dismiss转场动画的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        forPresented = false
        return self
    }
}
//MARK: - 实现转场动画的代理
extension PhotoBrowserTransitioningDelegate: UIViewControllerAnimatedTransitioning {
    ///动画的时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /// 转场动画
    ///
    /// - Parameter transitionContext: 展现对象的上下文
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //一，拿到跳转中from和to的控制器
        //MainVC
        transitionContext.viewController(forKey: .from)
        //PhotoBrowser
        transitionContext.viewController(forKey: .to)
        //二，拿到跳转中from和to的View
        transitionContext.view(forKey: .from)
        //MainVC的View
        forPresented ? AnimationForPresent(transitionContext: transitionContext) : AnimationForDismiss(transitionContext: transitionContext)
    }
    //present转场动画
    func AnimationForPresent( transitionContext: UIViewControllerContextTransitioning){
        
        guard let indexPath = indexPath , let PhotoRectDelegate = PhotoPresentDelegate else {
                return
        }
        
        let toView = transitionContext.view(forKey: .to)
        //PhotoBrowser里面的collectionView
        transitionContext.containerView.addSubview(toView!)
        
        //拿到imageView/转场前rect/转场后rect
        let imageView = PhotoRectDelegate.PhotoPresentForAnimation(indexPath: indexPath)
        
        imageView.frame = PhotoRectDelegate.PhotoBrowserPresentFromRect(indexPath: indexPath)
        
        toView?.alpha = 0
        
        transitionContext.containerView.addSubview(imageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = PhotoRectDelegate.PhotoBrowserPresentToRect(indexPath: indexPath)
            toView?.alpha = 1
        }) { (_) in

        //四，通知系统完成present，继续后面的操作
        imageView.removeFromSuperview()
        transitionContext.completeTransition(true)
        }
       
    }
    ///dismiss转场动画
    func AnimationForDismiss( transitionContext: UIViewControllerContextTransitioning){
        
        guard let PhotoPresentDelegate = PhotoPresentDelegate ,
            let PhotoDismissDelegate = PhotoDismissDelegate ,
            let imageView = PhotoDismissDelegate.PhotoDimissForAnimation()
            else
        {
            return
        }

        let fromView = transitionContext.view(forKey: .from)!
        
        fromView.removeFromSuperview()
        //把假的ImageView添加到contentView
        //里面已经设置好图片大小了
        
        transitionContext.containerView.addSubview(imageView)
        
        let indexpath = PhotoDismissDelegate.CurrentIndexPath()!
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            imageView.frame = PhotoPresentDelegate.PhotoBrowserPresentFromRect(indexPath: indexpath)
//            print(transitionContext.containerView.frame)
        }) { (_) in
//          imageView.isHidden = true
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
