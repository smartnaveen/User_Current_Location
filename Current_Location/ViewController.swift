//
//  ViewController.swift
//  Current_Location
//
//  Created by Mr. Naveen Kumar on 24/04/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
    
    @IBOutlet weak var latituteLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    // LocationManger Stopupdating Location
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
}


// MARK:- Delegate method of CoreLocation
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("User allowed us to access location")
            locationManager.startUpdatingLocation()
        case .notDetermined:
            print("User Notdetermined us to access location")
        case .restricted:
            print("User restricted us to access location")
        case .denied:
            print("User Denied us to access location")
            let alertController = UIAlertController(title: "TITLE", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did location updates is called")
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        latituteLabel.text = "\(coord.latitude)"
        longitudeLabel.text = "\(coord.longitude)"
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error.localizedDescription)")
        locationManager.stopUpdatingLocation()
    }
}
