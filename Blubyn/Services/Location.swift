//
//  Location.swift
//  Wheelstreet
//
//  Created by JOGENDRA on 26/12/17.
//  Copyright © 2017 Kush Taneja. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

class Location: NSObject {

  static let shared = Location()
  var locationManager = CLLocationManager()

  func locationManagerSetup() {
    // Ask for Authorisation from the User.
    locationManager.requestAlwaysAuthorization()

    // If location services is enabled get the users location
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestLocation()
    }
    else {
      showLocationDisabledPopUp()
    }
  }


  // Show the popup to the user if we have been deined access
  func showLocationDisabledPopUp() {
    
    let alertController = UIAlertController(title: "Location Access Disabled",
                                            message: "Blubyn needs location prermissions to improve flight and hotel results, navigation and support",
                                            preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    cancelAction.setValue(UIColor.appThemeColor, forKey: "titleTextColor")
    alertController.addAction(cancelAction)
    
    let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    openAction.setValue(UIColor.appThemeColor, forKey: "titleTextColor")
    alertController.addAction(openAction)
    
    UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}

extension Location: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      manager.stopUpdatingLocation()
    }
    else {
      manager.requestLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    manager.requestLocation()
  }

  // If we have been deined access give the user the option to change it
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if(status == CLAuthorizationStatus.denied) {
      showLocationDisabledPopUp()
    }
  }
}
