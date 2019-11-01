
//
//  UIImage+Extension.swift
//  1-图片选择器
//
//  Created by 梁华建 on 2019/4/12.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

extension UIImage{
    
    func scaleTo(width : CGFloat) -> UIImage {
        if width > size.height
        {
            return self
        }
        
        let height = size.height*width/size.width
        let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
//    func writeToPhotosAlbum(completion : ((_ isSuccess : Bool , _ error : NSError?) -> Void)?) {
//        
//        UIImageWriteToSavedPhotosAlbum(self, self, #selector(finishSavingToPhotosAlbum(UIImage:error:contextInfo:)), nil)
//        
//    }
////签名规则
//// - (void)image:(UIImage *)image
////    didFinishSavingWithError:(NSError *)error
////                 contextInfo:(void *)contextInfo
//    @objc func finishSavingToPhotosAlbum(UIImage : UIImage , error : NSError , contextInfo : AnyObject)
//    {
//        
//    }
}
