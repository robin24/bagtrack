//
//  DataModel.swift
//  BagTrack
//
//  Created by Robin Kipp on 15.09.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import Foundation
import CoreLocation

class DataModel {

    // MARK: - Properties
    static let sharedInstance = DataModel()
    private var bags:[Bag]

    // MARK: - Methods

    private init() {
        bags = []
    }
    func add(bag:Bag) {
        print("Adding new bag: \(bag)")
        self.bags.append(bag)
    }
    func saveToDisk() {
        print("Saving bags: \(bags)")
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        guard let data = try? encoder.encode(bags) else {
            print("Error encoding data.")
            return
        }
        let filePath = getFilePath()
        do {
            try data.write(to: filePath, options: .atomic)
        } catch {
            print("Error writing data to disk: \(error)")
        }
    }
    func retrieveBags() -> [Bag] {
        print("Retrieving bags...")
        if !bags.isEmpty {
            print("Returning non-empty array of bags from memory: \(bags)")
            return bags
        } else {
            let filePath = getFilePath()
            guard let data = try? Data.init(contentsOf: filePath) else {
                print("No data found, returning empty array.")
                return bags
            }
            let decoder = PropertyListDecoder()
            do {
                let tempBags = try decoder.decode(Array<Bag>.self, from: data)
                bags = tempBags
            } catch {
                fatalError("Unable to decode saved data: \(error)")
            }
            print("Returning array of bags from disk: \(bags)")
            return bags
        }
    }
    func deleteBag(at index:Int) {
        bags.remove(at: index)
    }
    func update(bag:Bag, name:String?, proximityUUID:UUID?, majorValue:CLBeaconMajorValue?, minorValue:CLBeaconMinorValue?, beaconID:String?, proximity:CLProximity?, isTrackingEnabled:Bool?) {
        for tempBag in bags {
            if tempBag.proximityUUID == bag.proximityUUID {
                if name != nil {
                    bag.name = tempBag.name
                }
                if proximityUUID != nil {
                    bag.proximityUUID = tempBag.proximityUUID
                }
                if majorValue != nil {
                    bag.majorValue = tempBag.majorValue
                }
                if minorValue != nil {
                    bag.minorValue = tempBag.minorValue
                }
                if beaconID != nil {
                    bag.beaconID = tempBag.beaconID
                }
                if proximity != nil {
                    bag.proximity = tempBag.proximity
                }
                if isTrackingEnabled != nil {
                    bag.isTrackingEnabled = tempBag.isTrackingEnabled
                }
            }
        }
    }
    private func getFilePath() -> URL {
        let homeDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = homeDir[0].appendingPathComponent("Bags.plist", isDirectory: false)
        return filePath
    }
}
