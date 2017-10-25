//
//  WebViewController.swift
//  Villim
//
//  Created by Seongmin Park on 7/28/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var webView: UIWebView!
    var urlString : String = ""
    var webViewTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Set navigation bar title */
        self.navigationItem.titleLabel.text = webViewTitle;
        
        // Do any additional setup after loading the view.
        webView = UIWebView(frame: UIScreen.main.bounds)
        webView.delegate = self
        view.addSubview(webView)
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

}
