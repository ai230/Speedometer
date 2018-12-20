//
//  SPDLocationSpeedChecker.swift
//  Speedometer
//
//  Created by Ai Yamamoto on 2018-12-18.
//  Copyright © 2018 Ai Yamamoto. All rights reserved.
//

import Foundation
import CoreLocation

protocol SPDLocationSpeedCheckerDelegate: class {
    func exceedingMaximumSpeedChanged(for speedChecker: SPDLocationSpeedChecker)
}

protocol SPDLocationSpeedChecker: class {
    var delegate: SPDLocationSpeedCheckerDelegate? { get set }
    
    var maximumSpeed: CLLocationSpeed? { get set }
    var isExceedingMaximumSpeed: Bool { get }
}

class SPDDefaultLocationSpeedChecker {
    weak var delegate: SPDLocationSpeedCheckerDelegate?
    var maximumSpeed: CLLocationSpeed? {
        didSet {
            checkIfSpeedExceeded()
        }
    }
    var isExceedingMaximumSpeed: Bool = false {
        didSet {
            delegate?.exceedingMaximumSpeedChanged(for: self)
        }
    }
    var lastLocation: CLLocation?
    let locationProvider: SPDLocationProvider
    
    init(locationProvider: SPDLocationProvider) {
        self.locationProvider = locationProvider
        locationProvider.add(self)
    }
}

private extension SPDDefaultLocationSpeedChecker {
    func checkIfSpeedExceeded() {
        if let maximumSpeed = maximumSpeed, let location = lastLocation {
            isExceedingMaximumSpeed = location > maximumSpeed
        } else {
            isExceedingMaximumSpeed = false
        }
    }
}
extension SPDDefaultLocationSpeedChecker: SPDLocationSpeedChecker {
    
}

extension SPDDefaultLocationSpeedChecker: SPDLocationConsumer {
    
    func consumeLocation(_ location: CLLocation) {
        lastLocation = location
    }
}
