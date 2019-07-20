//
//  AddMarkerViewController.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 07/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class AddMarkerViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var longPressGesture : UILongPressGestureRecognizer!
    let realm = try! Realm()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let markers = realm.objects(Marker.self)
        
        for marker in markers {
            
            let annotation = MKPointAnnotation()
            
            let coordinate = CLLocationCoordinate2D(latitude: marker.lat, longitude: marker.long)
            annotation.coordinate = coordinate
            //Set title and subtitle if you want
            annotation.title = marker.mainTitle
            annotation.subtitle = marker.subTitle
            
            self.mapView.addAnnotation(annotation)
        }
        
        
        if let firstMarker = markers.first {
            
            let center = CLLocationCoordinate2D(latitude: firstMarker.lat, longitude: firstMarker.long)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            self.mapView.setRegion(region, animated: true)
            
        }
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.8
        self.mapView.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            
            // get title here!
            
            let alert = UIAlertController(title: "Alert", message: "Please enter Main title and Subtitle of this location!", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = "Main Title"
            }
            
            alert.addTextField { (textField) in
                textField.placeholder = "Sub Title"
            }
            
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                
                let mainTitle = alert?.textFields![0].text! as! String
                let subTitle = alert?.textFields![1].text! as! String
                
                let marker = Marker(lat: coordinate.latitude, long: coordinate.longitude, mainTitle: mainTitle, subTitle: subTitle)
                
                try! self.realm.write {
                    self.realm.add(marker)
                }
                
                //Now use this coordinate to add annotation on map.
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                //Set title and subtitle if you want
                annotation.title = mainTitle
                annotation.subtitle = subTitle
                self.mapView.addAnnotation(annotation)
                
            }))
            
            alert.addAction(
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            )
            
            
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func btn_back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
}
