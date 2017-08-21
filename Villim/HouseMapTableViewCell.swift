//
//  HouseMapTableViewCell.swift
//  Villim
//
//  Created by Seongmin Park on 7/26/17.
//  Copyright © 2017 Villim. All rights reserved.
//

import UIKit
import GoogleMaps

protocol MapDelegate {
    func onMapSeeMore()
}

class HouseMapTableViewCell: UITableViewCell, GMSMapViewDelegate {

    let markerSize = 80.0
    
    var mapDelegate : MapDelegate!
    
    var container : UIView!
    var mapView   : GMSMapView!
    var latitude  : Double = 0.0
    var longitude : Double = 0.0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = VillimValues.backgroundColor
        
        container = UIView()
        self.contentView.addSubview(container)
        
        makeConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populateView() {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        container.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        
        /* Create custom marker iamge. */
        let circle = UIImage(named: "custom_marker")!
        let markerView = UIImageView(image: circle)
        markerView.frame = CGRect(x:0, y:0, width:markerSize, height:markerSize)
        markerView.clipsToBounds = false
        marker.iconView = markerView
        marker.tracksViewChanges = true
        marker.map = mapView
        
        makeConstraints()
    }

    func makeConstraints() {
        
        container?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        mapView?.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapDelegate.onMapSeeMore()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
