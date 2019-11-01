//
//  LHJSearchBar.swift
//  UISearchBar子类封装-自定义高度
//
//  Created by 梁华建 on 2019/6/16.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class LHJSearchBar: UISearchBar {
    var textFieldFrame : CGRect? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //我们修改searchField的frame
        guard let searchField = self.value(forKey: "searchField") as? UITextField else {
            return
        }
    
        //通过判断是否有展现cancelButton去调整宽度
                if showsCancelButton == false
                {
                    if textFieldFrame != nil
                    {
                        searchField.frame = textFieldFrame!
                    }else
                    {
                        searchField.frame = CGRect.init(x: screenWidth*0.025, y: self.frame.height*0.15, width: screenWidth * 0.95, height: screenHeight*0.054)
                    }

            }else
                {
                    if textFieldFrame != nil
                    {
                        searchField.frame = CGRect.init(x: textFieldFrame!.origin.x, y: textFieldFrame!.origin.y, width: screenWidth * 0.9 - self.cancelButton!.frame.size.width + 10, height: textFieldFrame!.size.height)
                    }else
                    {
                        searchField.frame = CGRect.init(x:screenWidth*0.025, y: self.frame.height*0.15, width:screenWidth * 0.9 - 50 + 10 , height: screenHeight*0.054)
                    }
                }
    }
    
  
    lazy var cancelButton : UIButton? = {
        for v in self.subviews {
            
            for _v in v.subviews {
                
                if let _cls = NSClassFromString("UINavigationButton") {
                    
                    print(_v)
                    if _v.isKind(of: _cls) {
                        guard let btn = _v as? UIButton else { return nil}
                        btn.setTitle("取消", for: .normal)
                        btn.setTitleColor(UIColor.white, for: .normal)
                        
                        return btn
                    }
                }
                
            }
            
        }
        return nil
    }()
    convenience init(frame: CGRect , placeHolder : String? , leftImage : UIImage?, showsCancelButton : Bool , tintColor : UIColor?) {
        self.init(frame: frame)
        self.placeholder = placeHolder
        self.setImage(leftImage, for: .clear, state: .normal)
        self.showsCancelButton = showsCancelButton
        self.tintColor = tintColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
