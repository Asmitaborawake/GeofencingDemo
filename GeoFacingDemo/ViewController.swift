//
//  ViewController.swift
//  GeoFacingDemo
//
//  Created by asmita.borawake on 30/10/18.
//  Copyright © 2018 asmita.borawake. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications
class ViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [ .alert,.sound,.badge]) { (granted, error) in
            
        }
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    @IBAction func addResign(_ sender: Any) {
        print("add regin")
        
        guard let longPress = sender as? UILongPressGestureRecognizer else {
            return
        }
        
        let touchLocation = longPress.location(in: mapView)
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "GeoFancing")
        mapView.removeOverlays(mapView.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinate, radius: region.radius)
        mapView.add(circle)
        
        
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showNotification(title:String,message:String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = .default()
        let request = UNNotificationRequest(identifier: "notify", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        let title = "You enter ther region"
        let message = "Wow there is cool stuff here"
        showAlert(title: title, message: message)
        showNotification(title: title, message: message)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        let title = "You left region"
        let message = "Say by by to all cool stuff"
        showAlert(title: title, message: message)
        showNotification(title: title, message: message)
    }
}

extension ViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circelOverlay = overlay as? MKCircle else { return
            MKOverlayRenderer()
        }
       let circelRender = MKCircleRenderer(circle: circelOverlay)
       circelRender.strokeColor = .red
        circelRender.fillColor = .red
        circelRender.alpha = 0.5
        return circelRender
        
    }
}
