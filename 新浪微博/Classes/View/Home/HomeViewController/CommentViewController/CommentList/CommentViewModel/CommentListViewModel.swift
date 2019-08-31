//
//  CommentListViewModel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/9.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class CommentListViewModel: NSObject {
    
    var viewModels = [CommentViewModel]()
    ///正常评论条数，而不是加上评论别人评论的条数
    var commentCounts : Int?
    {
       
       let n = viewModels.filter { (vm) -> Bool in
            //不是评论别人的评论的评论就过滤出来
            return !vm.isRepliedComment!
        }.count
        
        return n
    }
    
    var rowHeight : CGFloat
    {
        get
        {
            guard let cc = commentCounts else {
                return 0
            }
            
            var sum : CGFloat = 0
            
            for i in 0..<cc {
                sum += viewModels[i].rowHeight
            }
            
            return sum
        }
    }
}
