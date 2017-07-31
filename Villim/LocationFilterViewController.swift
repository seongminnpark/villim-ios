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

    var locationDelegate : LocationFilterDelegate!
    var locationSuggestionTableViewController : LocationSuggestionTableViewController!
    
    var locationSuggestions = [VillimLocation]()
    
    var searchField  : UITextField!
    var popularTitle : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "장소 검색"
        
        /* Search field */
        searchField = UITextField()
        searchField.placeholder = NSLocalizedString("where_to_go", comment: "")
        searchField.returnKeyType = .search
        searchField.autocapitalizationType = .none
        searchField.clearButtonMode = .whileEditing
        searchField.delegate = self
        self.view.addSubview(searchField)
        
        searchField.leftView = UIImageView(image: #imageLiteral(resourceName: "icon_search"))
        searchField.leftView?.frame = CGRect(x: 0, y: 0, width: 20 , height:20)
        searchField.leftViewMode = .always
        
        let location = VillimLocation(name:"강남구", addrFull:"서울시 강남구 청담동 42", addrSummary:"서울특별시 강남구", addrDirection:"", latitude:0.0, longitude:0.0)
        locationSuggestions = [location, location, location, location, location, location]
        
        popularTitle = UILabel()
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
            make.width.equalTo(self.view)
            make.height.equalTo(50)
            make.top.equalTo(topOffset)
            make.centerX.equalToSuperview()
        }
    
        /* Popular title */
        popularTitle.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(searchField.snp.bottom)
        }
        
        /* Tableview */
        locationSuggestionTableViewController.tableView.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(popularTitle.snp.bottom)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
