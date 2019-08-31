//
//  CommentViewModel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/9.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class CommentViewModel: NSObject {
    var commentModel : CommentModel?
    
    var isRepliedComment : Bool?
    {
        return commentModel?.reply_comment != nil
    }
    
    lazy var rowHeight : CGFloat =
    {
       let cell = CommentCell.init(style: .default, reuseIdentifier: "CommentCellID")
        cell.commentViewModel = self
        
        return cell.contentLabel.frame.maxY + 12
    }()
    
    convenience init(commentModel : CommentModel)
    {
        self.init()
        self.commentModel = commentModel
    }
    
}
