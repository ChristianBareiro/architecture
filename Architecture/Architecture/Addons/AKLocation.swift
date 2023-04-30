//
//  AKLocation.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

// USAGE: -
// let manager = AKLocation()
// let disposeBag: DisposeBag = DisposeBag()
//
// manager
//    .onUpdate
//    .subscribe(onNext: { [weak self] dictionary in
//        let coordinates = dictionary["locationCoordinate"] as? CLLocationCoordinate2D
//        // do
//    })
//    .disposed(by: disposeBag)
// manager.onFailure
//    .subscribe(onNext: { [weak self] error in
//        // do smth with error
//    })
//    .disposed(by: disposeBag)


class AKLocation: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var locationCoordinate: CLLocationCoordinate2D?
    var onUpdate: PublishSubject<[String: Any]> = PublishSubject()
    var onFailure: PublishSubject<String> = PublishSubject()
    var isLocationEnabled: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied: return false
        case .authorizedAlways, .authorizedWhenInUse: return true
        @unknown default: return false
        }
    }
    
    override init() {
        super.init()
    }
    
    func startWork() {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        case .notDetermined: break
        default:
            onFailure.onNext("User denied access to location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationCoordinate = manager.location!.coordinate
        onUpdate.onNext(["locationCoordinate": locationCoordinate as AnyObject])
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
        onFailure.onNext(error.localizedDescription)
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}

