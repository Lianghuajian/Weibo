//
//  DetailTableViewCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/13.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
/*
 *第三行cell
 */
let detailCellID = "detailCellID"

///Cell加载所需数据:存储结构[(label名字，图片名字)]
fileprivate let dict = [("Albums","popover_icon_album"),("Weibo Wallet","wblive_icon_buy"),("My Story","story_redpack_head"),("Weibo Store","story_icon_shoppingbag"),("Likes","story_icon_liked"),("Fanstop","YXLBuffing"),("Fans service","popover_icon_text"),("Help","video_my_video_service")]
class DetailTableViewCell: UITableViewCell {
    let cellHeight = screenHeight*0.310
    //MARK: - 生命周期
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        prepareCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
        prepareCollectionView() 
    }
    
    //MARK: - 视图布局
    func setUpUI() {
        //0,设置cell
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: screenWidth)
        self.selectionStyle = .none
        //1,添加控件
        self.addSubview(spaView)
        self.addSubview(collectionView)
        //2,设置布局
        spaView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp_left)
            make.top.equalTo(self.contentView.snp_top)
            make.width.equalTo(screenWidth)
            make.height.equalTo(screenHeight*0.017)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.spaView.snp.bottom)
            make.left.equalTo(self.contentView.snp.left)
            make.width.equalTo(screenWidth)
            make.height.equalTo(cellHeight-spaHeight)
        }
    }
    
    func prepareCollectionView()
    {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailCollectionCell.self, forCellWithReuseIdentifier: detailCellID)
    }
    //MARK: - 懒加载属性
    ///头部分割线
    lazy var spaView :UIView = {
        let view = UIView()
        view.backgroundColor = spaColor
        return view
    }()
    ///CollectionView
    lazy var collectionView : UICollectionView =
        {
            let cv = UICollectionView.init(frame: CGRect.init(x: 0, y: spaHeight, width: screenWidth, height:(cellHeight-screenHeight*0.017)), collectionViewLayout: DetailCollectionViewFlowLayout())
            return cv
    }()
    
    fileprivate class DetailCollectionViewFlowLayout : UICollectionViewFlowLayout {
        open override func prepare() {
            super.prepare()
            itemSize = CGSize.init(width: screenWidth/4, height: screenWidth/4)
            scrollDirection = .horizontal
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            collectionView?.isPagingEnabled = false
            collectionView?.isScrollEnabled = false
        }
    }
}

extension DetailTableViewCell : UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellID, for: indexPath) as! DetailCollectionCell
        item.itemLabel.text = dict[indexPath.row].0
        item.itemImageView.image = UIImage.init(named: dict[indexPath.row].1)
        item.itemImageView.tintColor = UIColor.randomColor
//        item.backgroundColor = UIColor.randomColor
        return item
    }
}

class DetailCollectionCell: UICollectionViewCell {
    //MARK: - 生命周期
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    //MAKR: - 视图布局
    func setUpUI(){
        //1,添加控件
        self.addSubview(itemLabel)
        self.addSubview(itemImageView)
        //2,添加布局
        itemImageView.snp.makeConstraints { (make) in
        make.centerX.equalTo(self.contentView.snp.centerX)
        make.centerY.equalTo(self.contentView.snp.centerY).offset(-10)
        make.height.equalTo(40)
        make.width.equalTo(40)
        }
        itemLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.itemImageView.snp.centerX)
            make.top.equalTo(self.itemImageView.snp.bottom).offset(10)
            make.width.equalTo(self.contentView.snp.width)
            make.height.equalTo(11.5)
        }
    }
    //MARK: - 懒加载属性
    lazy var itemLabel : UILabel = {
        let label = UILabel.init(size: 11.5, content: "", color: .black, alignment: .center, lines: 0, breakMode: .byTruncatingTail)
        
        return label
    }()
    lazy var itemImageView : UIImageView = {
        let iv = UIImageView()
        iv.sizeToFit()
        return UIImageView()
    }()
}
