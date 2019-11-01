//
//  AlertControllerViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/10/17.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.superview?.subviews.forEach({ (v) in
            v.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hide(gesture:))))
        })
        self.view.superview?.isUserInteractionEnabled = true
    }
   
    @objc func hide(gesture : UIGestureRecognizer)
    {
        
        self.dismiss(animated: true, completion: nil)
    }

}
