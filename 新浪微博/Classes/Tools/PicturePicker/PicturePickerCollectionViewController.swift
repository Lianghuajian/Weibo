//
//  PicturePickerCollectionViewController.swift
//  1-图片选择器
//
//  Created by 梁华建 on 2019/4/12.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

private let PictureIdentifier = "PictureIdentifier"

class PicturePickerCollectionViewController: UICollectionViewController {
    
    let maxSelections = 9
    
    //总图片数组
    lazy var pictureArray = [UIImage]()
    //当前选择cell的index
    var selectIndex = 0
    
    init() {
        super.init(collectionViewLayout: PictureFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //collectionview != view
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(PictureItem.self, forCellWithReuseIdentifier: PictureIdentifier)
        
        collectionView.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        // Do any additional setup after loading the view.
    }

    private class PictureFlowLayout : UICollectionViewFlowLayout{
        override func prepare()
        {
            super.prepare()
            
            let count : CGFloat = 4
            
            let margin = UIScreen.main.scale*count
            
            let w = (collectionView!.bounds.width - (count+1)*margin)/count
            
            self.itemSize = CGSize.init(width: w, height: w)

            sectionInset = UIEdgeInsets.init(top: margin, left: margin, bottom: 0, right: margin)
            
            minimumInteritemSpacing = margin
            
            minimumLineSpacing = margin
            
        }
        
    }
}

//MARK: - item点击事件代理
extension PicturePickerCollectionViewController : PictureItemProtocol{
    
    func didClickAdd(cell : PictureItem) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            return
        }
        
       let pickerVC = UIImagePickerController()
        
        selectIndex = collectionView?.indexPath(for: cell)?.item ?? 0
        
        pickerVC.delegate = self
        
        pickerVC.allowsEditing = true
        
        present(pickerVC, animated: true, completion: nil)
        
    }
    
    func didClickDelete(cell : PictureItem) {
        
        let indexpath = collectionView!.indexPath(for: cell)!
        
        if indexpath.item == pictureArray.count{
            
            return
        }
        
        pictureArray.remove(at: indexpath.item)
        //deleteItems会把items删除，并且去检查itemCount是否跟删除后的一样，如果不一样就报错
        collectionView.deleteItems(at: [indexpath])
        //牺牲动画效果,规避检查机制
//        collectionView.reloadData()
//        if pictureArray.count == maxSelections{
//            collectionView.insertItems(at: [indexpath])
//        }
    }
}
//MARK: - 选择相册的代理方法
extension PicturePickerCollectionViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        //ios相册图片属于高清，我们要重新绘制他，达到压缩效果，绘制出来像素低点
        let scaleImage = image.scaleTo(width: 600)
        
        //判断是添加图片还是更换图片
        if selectIndex >= pictureArray.count{
//              print("进来了")
            pictureArray.append(scaleImage)
        }else{
            pictureArray[selectIndex] = scaleImage
        }
        
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: -PictureItem的代理方法
@objc protocol PictureItemProtocol {
    
    @objc optional func didClickAdd(cell : PictureItem)
    @objc optional func didClickDelete(cell : PictureItem)
    
}

//MARK: - 自定义PitureItem
//由于我们的Item会被复用，我们会add太多target到self上面，我们要把点击方法绑到控制器
class PictureItem : UICollectionViewCell{
    
    var pictureDelegate : PictureItemProtocol!
    
    var image : UIImage?
    {
        didSet
        {
            
            addButton.setImage(image ?? UIImage.init(named: "compose_pic_add_highlighted"), for: .normal)
            
            //小心cell的复用
            closeButton.isHidden = (image == nil)
        }
    }
    
    //监听方法
    @objc func clickAdd()  {
        pictureDelegate.didClickAdd?(cell: self)
    }
    @objc func clickDelete() {
        pictureDelegate.didClickDelete?(cell:self)
    }
    
    //懒加载控件
    lazy var addButton = UIButton(image: "compose_pic_add_highlighted", backImage: nil)
    
    lazy var closeButton = UIButton(image: "compose_photo_close", backImage: nil)
    
    //初始化方法
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //设置布局
    func setupUI() {
        //1,添加控件
        contentView.addSubview(addButton)
        
        contentView.addSubview(closeButton)
        addButton.frame = self.bounds
        //2,添加约束
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right)
        }
        //3,添加监听
        addButton.addTarget(self, action: Selector(("clickAdd")), for: .touchUpInside)
        closeButton.addTarget(self, action: Selector(("clickDelete")), for: .touchUpInside)
        addButton.imageView?.contentMode = ContentMode.scaleAspectFill
    }
    
}

//MARK: - CollectionView的dataSource
extension PicturePickerCollectionViewController{

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureArray.count+(maxSelections == pictureArray.count ? 0 : 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureIdentifier, for: indexPath) as! PictureItem
        // Configure the cell
        //看看有没有图片，当前图像
        
        cell.image = indexPath.item == pictureArray.count ? nil :  pictureArray[indexPath.item]
        
        cell.pictureDelegate = self
        return cell
    }
    
}
