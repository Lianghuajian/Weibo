//
//  UIImage + downsample.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/6.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

extension UIImage
{
    static func downsample(imageAt imageURL:URL,to pointSize:CGSize,scale:CGFloat)->UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache : false] as CFDictionary
        //创建一个图片资源，但是我们告诉系统先不要缓存
        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL , imageSourceOptions)!
        //缓存实际展示大小 = 长宽*像素(scale是像素点,iphone一般是1，2，3)
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions =
            [kCGImageSourceShouldCache : true,
             kCGImageSourceCreateThumbnailFromImageAlways : true,
             kCGImageSourceCreateThumbnailWithTransform : true,
             kCGImageSourceThumbnailMaxPixelSize:maxDimensionInPixels] as CFDictionary
        let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        
        return UIImage.init(cgImage: downsampledImage)
        
    }

}

