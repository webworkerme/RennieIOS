//
//  MapViewController.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 07/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MapViewController: UIViewController {
    
    @IBOutlet weak var view_activity: UIActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var img_map: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var festival : Festival!
    var location : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.appDelegate.products.keys.contains("map") {
            self.mapView.isHidden = false
            self.img_map.isHidden = true
        }
        else {
            self.mapView.isHidden = true
            self.img_map.isHidden = false
            self.loadMapImage(mapImage: self.festival.file_map)
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.location = CLLocation(latitude: self.festival.FestivalLat, longitude: self.festival.FestivalLong)
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
        
        if self.mapView.isHidden == true {
            return
        }
        
        if Int(self.location.coordinate.latitude) == 0 && Int(self.location.coordinate.longitude) == 0 {
            
            let alert = UIAlertController(title: "Location", message: "There is no location of this festival.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true)
            
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.location.coordinate
        annotation.title = self.festival.FestivalName
        annotation.subtitle = self.festival.FestivalLocation
        mapView.addAnnotation(annotation)
        
    }
    
    
    func loadMapImage(mapImage : String) {
        
        let imageURL = self.appDelegate.siteBaseURL + mapImage
        
        if let image = self.appDelegate.imageChache.object(forKey: imageURL as NSString) {
            self.img_map.image = image
            return
        }
        
        self.view_activity.startAnimating()
        
        Alamofire.request(imageURL).responseData { (response) in
            
            self.view_activity.stopAnimating()
            
            if response.error == nil {
                if let data = response.data {
                    let image = UIImage(data: data)
                    
                    if image != nil {
                        self.img_map.image = UIImage(data: data)
                        self.appDelegate.imageChache.setObject(image!, forKey: imageURL as NSString)
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func btn_back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
