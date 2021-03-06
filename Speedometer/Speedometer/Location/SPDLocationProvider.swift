//
//  SPDLocationProvider.swift
//  Speedometer
//
//  Created by Ai Yamamoto on 2018-12-18.
//  Copyright © 2018 Ai Yamamoto. All rights reserved.
//

import Foundation
import CoreLocation

protocol SPDLocationConsumer: class {
    func consumeLocation(_ location: CLLocation)
}
protocol SPDLocationProvider: class {
    func add(_ consumer: SPDLocationConsumer)
}

class SPDDefaultLocationProvider {
    let locationManager: SPDLocationManager
    let locationAuthorization: SPDLocationAuthorization
    
    var locationConsumers = [SPDLocationConsumer]()
    
    init(locationManager: SPDLocationManager, locationAuthorization: SPDLocationAuthorization) {
        self.locationManager = locationManager
        self.locationAuthorization = locationAuthorization
        locationManager.delegate = self
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

private extension SPDDefaultLocationProvider {
    func setupNotifications() {
        NotificationCenter.default.addObserver(forName: .SPDLocationAuthorized,
                                               object: locationAuthorization,
                                               queue: .main) { [weak self] (_) in
            self?.locationManager.startUpdatingLocation()
        }
    }
}

extension SPDDefaultLocationProvider: SPDLocationProvider {
    func add(_ consumer: SPDLocationConsumer) {
        locationConsumers.append(consumer)
    }
}

extension SPDDefaultLocationProvider: SPDLocationManagerDelegate {
    func locationManager(_ manager: SPDLocationManager, didUpdateLocations locations: [CLLocation]) {
        let sortedLocations = locations.sorted{ (lhs, rhs) -> Bool in
            return lhs.timestamp.compare(rhs.timestamp) == .orderedDescending
        }
        
        guard let location = sortedLocations.first else { return }
        
        for consumer in locationConsumers {
                consumer.consumeLocation(location)
        }
    }
}
