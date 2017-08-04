//
//  LocationFilterViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/30/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

protocol LocationFilterDelegate {
    func onLocationFilterSet(location:String)
}

class LocationFilterViewController: UIViewController, UITextFieldDelegate, LocationSuggestionSelectedListener {

    let sideMargin : CGFloat! = 20.0
    
    var locationDelegate : LocationFilterDelegate!
    var locationSuggestionTableViewController : LocationSuggestionTableViewController!
    
    var locationSuggestions = [VillimLocation]()
    
    var searchField  : UITextField!
    var popularTitle : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = VillimValues.backgroundColor
        self.title = "장소 검색"
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        /* Search field */
        searchField = LocationFilterSearchField()
        searchField.font = UIFont(name: "NotoSansCJKkr-Regular", size: LocationFilterSearchField.iconSize)
        searchField.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        searchField.placeholder = NSLocalizedString("where_to_go", comment: "")
        searchField.returnKeyType = .search
        searchField.autocapitalizationType = .sentences
        searchField.clearButtonMode = .whileEditing
        searchField.delegate = self
        self.view.addSubview(searchField)
        
        searchField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_search"))
        searchField.leftView?.frame = CGRect(x: 0, y: 0, width:
            LocationFilterSearchField.iconSize , height:LocationFilterSearchField.iconSize)
        searchField.leftViewMode = .always
        
        let location = VillimLocation(name:"강남구", addrFull:"서울시 강남구 청담동 42", addrSummary:"서울특별시 강남구", addrDirection:"", latitude:0.0, longitude:0.0)
        locationSuggestions = [location, location, location, location, location, location]
        
        popularTitle = UILabel()
        popularTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
        popularTitle.textColor = UIColor(red:0.02, green:0.02, blue:0.04, alpha:1.0)
        popularTitle.text = NSLocalizedString("popular_location", comment: "")
        self.view.addSubview(popularTitle)
        
        /* Populate tableview */
        locationSuggestionTableViewController = LocationSuggestionTableViewController()
        locationSuggestionTableViewController.itemSelectedListener = self
        locationSuggestionTableViewController.locationSuggestions = locationSuggestions
        self.view.addSubview(locationSuggestionTableViewController.view)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        /* Prevent overlap with navigation controller */
        let navControllerHeight = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let topOffset = navControllerHeight + statusBarHeight
        
        /* Search Field */
        searchField?.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(sideMargin)
            make.right.equalToSuperview().offset(-sideMargin)
            make.top.equalTo(topOffset + sideMargin * 2)
            make.height.equalTo(LocationFilterSearchField.iconSize * 2)
        }
    
        /* Popular title */
        popularTitle.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(sideMargin)
            make.right.equalToSuperview().offset(-sideMargin)
            make.top.equalTo(searchField.snp.bottom).offset(sideMargin)
        }
        
        /* Tableview */
        locationSuggestionTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(popularTitle.snp.bottom).offset(sideMargin/2)
            make.left.equalToSuperview().offset(sideMargin)
            make.right.equalToSuperview().offset(-sideMargin)
            make.bottom.equalToSuperview()
        }
    
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = CGFloat(2.0)
        
        let bottomBorder = CALayer()
        bottomBorder.borderColor = VillimValues.searchFieldBorderColor.cgColor
        bottomBorder.frame = CGRect(x: 0, y: searchField.frame.size.height - width, width:  searchField.frame.size.width, height: searchField.frame.size.height)
        bottomBorder.backgroundColor = UIColor.clear.cgColor
        bottomBorder.borderWidth = width
        searchField.layer.addSublayer(bottomBorder)
        searchField.layer.masksToBounds = true
    }
    
    func locationSuggestionItemSelected(item:String) {
        self.navigationController?.popViewController(animated: true)
        locationDelegate.onLocationFilterSet(location:item)
    }
    
    
    /* Text field listeners */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
        locationDelegate.onLocationFilterSet(location:(searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        /* Make navbar transparent */
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }

}
