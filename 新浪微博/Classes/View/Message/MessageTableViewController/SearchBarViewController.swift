//
//  SearchBarViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/8/18.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class SearchBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar?.delegate = self
        // Do any additional setup after loading the view.
       
        prepareSearchBar()
    }
    func prepareSearchBar()  {
       let viewAboveSearchBar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight * 0.035))
        viewAboveSearchBar.backgroundColor = UIColor.init(red: 201.0/255.0, green: 201.0/255.0, blue: 206.0/255.0, alpha: 1)
        self.view.addSubview(viewAboveSearchBar)
        self.view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(viewAboveSearchBar.snp.bottom)
            make.height.equalTo(screenHeight*0.08)
            make.left.equalTo(viewAboveSearchBar.snp.left)
            make.width.equalTo(screenWidth)
        }
    }
    var searchBar : LHJSearchBar = {
//       let sb = LHJSearchBar.init(frame: CGRect.init(x: 0, y: screenHeight * 0.035, width: screenWidth, height: 44), placeHolder: "Search", leftImage: nil, showsCancelButton: true, tintColor: backColor)
        let sb = LHJSearchBar.init(frame: CGRect.zero, placeHolder: "Search", leftImage: nil, showsCancelButton: true, tintColor: backColor)
        sb.setBackgroundImage(UIImage.init(), for: .any, barMetrics: .default)
        sb.backgroundColor = UIColor.init(red: 201.0/255.0, green: 201.0/255.0, blue: 206.0/255.0, alpha: 1)
        return sb
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchBarViewController : UISearchBarDelegate
{

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        defer {
            dismiss(animated: true, completion: nil)
        }
        searchBar.resignFirstResponder()
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        searchBar.resignFirstResponder()
    }
}
