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

    var mapView   : GMSMapView!
    var latitude  : Double = 0.0
    var longitude : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = VillimValues.backgroundColor
        self.tabBarController?.title = NSLocalizedString("", comment: "")
        
        let location = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: latitude)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
