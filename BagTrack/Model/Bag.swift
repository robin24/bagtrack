
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
        case isTrackingEnabled
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
    var isTrackingEnabled:Bool

    // MARK: - Methods

    init(name:String, proximityUUID:UUID, majorValue:CLBeaconMajorValue, minorValue:CLBeaconMinorValue, beaconID:String) {
        self.name = name
        self.proximityUUID = proximityUUID
        self.majorValue = majorValue
        self.minorValue = minorValue
        self.beaconID = beaconID
        self.proximity = .unknown
        self.isTrackingEnabled = true
    }
    func proximityForDisplay() -> String {
        if !isTrackingEnabled {
            return "Tracking off"
        }
        switch proximity {
        case .far: return "Far"
        case .immediate: return "Immediate"
        case .near: return "Near"
        case .unknown: return "Unknown"
        }
    }
}

// MARK: - Equality operator overloading

extension Bag:Equatable {
    static func ==(lhs:Bag, rhs:Bag) -> Bool {
        return lhs.name == rhs.name && lhs.proximityUUID == rhs.proximityUUID && lhs.majorValue == rhs.majorValue && lhs.minorValue == rhs.minorValue && lhs.beaconID == rhs.beaconID && lhs.region == rhs.region && lhs.proximity == rhs.proximity && lhs.isTrackingEnabled == rhs.isTrackingEnabled
    }
    static func ==(bag:Bag, beacon:CLBeacon) -> Bool {
        return bag.proximityUUID == beacon.proximityUUID && Int(bag.majorValue) == Int(beacon.major) && Int(bag.minorValue) == Int(beacon.minor)
    }
}
