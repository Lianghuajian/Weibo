//
//  SearchViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/10/16.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class SearchViewController: UIInputViewController {
    
    
    
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        DispatchQueue.main.async {
            
            self.searchBar.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 64)
            
            self.searchBar.placeholder = "search"
                   
            self.view.addSubview(self.searchBar)
            
            self.searchBar.delegate = self
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.setShowsCancelButton(true, animated: true)
        self.searchBar.becomeFirstResponder()
    }
    
}


extension SearchViewController : UISearchBarDelegate
{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        do {
            dismiss(animated: true, completion: nil)
        }
      
    }
    
}
