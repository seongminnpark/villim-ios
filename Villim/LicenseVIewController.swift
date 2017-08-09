//
//  LicenseVIewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/9/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class LicenseVIewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = VillimValues.backgroundColor
        
        /* Set up navigation bar */
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.title = NSLocalizedString("license_information", comment: "")
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
