//
//  NewFeatureCollectionViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/11.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SnapKit

private let NewFeatureCellID = "NewFeatureCellID"
private let NewFeatureCount = 4
class NewFeatureCollectionViewController: UICollectionViewController {
    
    init(){
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UIScreen.main.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("不能使用xib加载")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(NewFeatureCell.self, forCellWithReuseIdentifier: NewFeatureCellID)
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return NewFeatureCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewFeatureCellID, for: indexPath) as! NewFeatureCell
        
        // Configure the cell
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.black : UIColor.white
        
        cell.imageIndex = indexPath.item
        
        return cell
    }
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //求页数
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        
        if page != NewFeatureCount - 1
        {
            return
        }
        
        let cell = collectionView.cellForItem(at: IndexPath(item: page, section: 0)) as! NewFeatureCell
        
        cell.showButtonAnimation()
    }
    
}

//MARK: - 自定义cell
private class NewFeatureCell : UICollectionViewCell{
    //懒加载 把昂贵的计算布局控件过程放到使用时候再去计算 默认mutating
    private lazy var iconview = UIImageView()
    
    private lazy var startbutton = UIButton.init(text: "开始体验", textColor: .white, backImage: "new_feature_finish_button",isBack:true)
    
    var imageIndex : Int = 0 {
        
        didSet{
            self.iconview.image = UIImage.init(named: "new_feature_\(imageIndex+1)")
            startbutton.isHidden = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        SetUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("不能使用xib去加载cell")
    }
    
    func SetUpUI(){
        //先添加button到imageView才能设置约束
        addSubview(iconview)
        
        addSubview(startbutton)
        
        iconview.frame = UIScreen.main.bounds
        
        startbutton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.7)
        }
        
        startbutton.addTarget(self, action: #selector(clickStartButton), for: .touchUpInside)
        
    }
    
    
}
//MARK: - NewFeatureCell中的button动画及监听
extension NewFeatureCell
{
    @objc func clickStartButton(){
        //nil Object说明发送notificationname
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBSwitchVCControllerNotification), object: nil)
    }
    func showButtonAnimation() {
        
        startbutton.isHidden = false
        
        startbutton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        startbutton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 1.8,           //动画时长
            delay: 0,                    //延时时间
            usingSpringWithDamping: 0.8, //弹力系数,0~1,越小越弹
            initialSpringVelocity: 10,   //初始速度，模拟重力加速器
            options: [],                 //动画选项
            animations: {
                self.startbutton.transform = CGAffineTransform.identity
                
        }) { (_) in
            print("done animate")
            self.startbutton.isUserInteractionEnabled = true
        }
        
    }
}
