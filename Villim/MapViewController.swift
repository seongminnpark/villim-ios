//
//  MapViewController.swift
//  Villim
//
//  Created by Seongmin Park on 8/3/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    let markerSize : CGFloat = 200.0
    
    var mapMarkerExact : Bool = false
    var mapView   : GMSMapView!
    var latitude  : Double = 0.0
    var longitude : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = true
        self.edgesForExtendedLayout = UIRectEdge.all
        self.extendedLayoutIncludesOpaqueBars = true

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.view.backgroundColor = VillimValues.backgroundColor
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if !mapMarkerExact {
            let circleImage = UIImage(named: "custom_marker")!
            let markerView = UIImageView(image: circleImage)
            markerView.frame = CGRect(x:0, y:markerSize, width:markerSize, height:markerSize)
            marker.groundAnchor = CGPoint(x:0.5, y:0.5)
            marker.iconView = markerView
            marker.tracksViewChanges = true
        }
        
        marker.map = mapView
        
        self.view.addSubview(mapView)
        
        makeConstraints()
        
    }
    
    func makeConstraints() {
        
        mapView?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
    }

}
