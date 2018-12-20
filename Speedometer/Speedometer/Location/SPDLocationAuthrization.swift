//
//  SPDLocationAuthrization.swift
//  Speedometer
//
//  Created by Ai Yamamoto on 2018-12-18.
//  Copyright © 2018 Ai Yamamoto. All rights reserved.
//

import Foundation
import CoreLocation

extension NSNotification.Name {
    static let SPDLocationAuthorized =
        NSNotification.Name(rawValue: "NSNotification.Name.SPDLocationAuthorized")
}

protocol SPDLocationAuthorizationDelegate: class {
    
    func authorizationDenied(for locationAuthorization: SPDLocationAuthorization)
}
protocol SPDLocationAuthorization: class {
    var delegate: SPDLocationAuthorizationDelegate? { get set }
    func checkAuthorization()
}

class SPDDefaultLocationAuthorization {
    weak var delegate: SPDLocationAuthorizationDelegate?
    let locationManager: SPDLocationManager
    init(locationManager: SPDLocationManager) {
        self.locationManager = locationManager
        locationManager.authorizationDelegate = self
    }
}

extension SPDDefaultLocationAuthorization: SPDLocationAuthorization {
    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            <#code#>
        }
    }
}

extension SPDDefaultLocationAuthorization: SPDLocationManagerAuthorizationDelegate {
    func locationManager(_ manager: SPDLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            NotificationCenter.default.post(name: .SPDLocationAuthorized, object: self)
        case .denied, .restricted:
            delegate?.authorizationDenied(for: self)
        default:
            break
        }
    }
}
