
//
//  Bag.swift
//  BagTrack
//
//  Created by Robin Kipp on 14.09.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import Foundation
import CoreLocation

class Bag:Codable {

    // MARK: - Properties

    enum CodingKeys:String,CodingKey {
        case name
        case proximityUUID
        case majorValue
        case minorValue
        case beaconID
    }

    var name:String
    var proximityUUID:UUID
    var majorValue:CLBeaconMajorValue
    var minorValue:CLBeaconMinorValue
    var beaconID:String
    var region:CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: proximityUUID, major: majorValue, minor: minorValue, identifier: beaconID)
    }
    var proximity:CLProximity = .unknown

    // MARK: - Methods

    init(name:String, proximityUUID:UUID, majorValue:CLBeaconMajorValue, minorValue:CLBeaconMinorValue, beaconID:String) {
        self.name = name
        self.proximityUUID = proximityUUID
        self.majorValue = majorValue
        self.minorValue = minorValue
        self.beaconID = beaconID
        self.proximity = .unknown
    }
    func proximityForDisplay() -> String {
        switch proximity {
        case .far: return "Far"
        case .immediate: return "Immediate"
        case .near: return "Near"
        case .unknown: return "Unknown"
        }
    }
}

// MARK: - Equality operator overloading

func ==(bag:Bag, beacon:CLBeacon) -> Bool {
    return bag.proximityUUID == beacon.proximityUUID && Int(bag.majorValue) == Int(beacon.major) && Int(bag.minorValue) == Int(beacon.minor)
}
