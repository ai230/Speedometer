//
//  SPDLocationSpeedProvider.swift
//  Speedometer
//
//  Created by Ai Yamamoto on 2018-12-18.
//  Copyright © 2018 Ai Yamamoto. All rights reserved.
//

import Foundation
import CoreLocation

protocol SPDLocationSpeedProviderDelegate: class {
    
    func didUpdate(speed: CLLocationSpeed)
}

protocol SPDLocationSpeedProvider: class {
    var delegate: SPDLocationSpeedProviderDelegate? { get set }
}

class SPDDefaultLocationSpeedProvider {
    weak var delegate: SPDLocationSpeedProviderDelegate?
    let locationProvider: SPDLocationProvider
    
    init(locationProvider: SPDLocationProvider) {
        self.locationProvider = locationProvider
        locationProvider.add(self)
    }
}

private extension SPDDefaultLocationSpeedChecker {
    func checkIfSpeedExceeded() {
        
    }
}

extension SPDDefaultLocationSpeedProvider: SPDLocationSpeedProvider {
    
}

extension SPDDefaultLocationSpeedProvider: SPDLocationConsumer {
    
    func consumeLocation(_ location: CLLocation) {
        let speed = max(location.speed, 0)
        
       delegate?.didUpdate(speed: speed)
    }
}
