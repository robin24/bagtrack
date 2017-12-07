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
    var bags:[Bag] = []
    private enum FilePath {
        case bags
        case vendors
        var fileURL:URL {
            switch self {
            case .bags:
                let homeDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let filePath = homeDir[0].appendingPathComponent("Bags.plist", isDirectory: false)
                return filePath
            case .vendors:
                return Bundle.main.url(forResource: "Beacon-UUIDs", withExtension: "plist")!
            }
        }
    }

    // MARK: - Methods

    private init() {
        bags = loadBags()
    }
    func saveToDisk() {
        print("Saving bags: \(bags)")
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        guard let data = try? encoder.encode(bags) else {
            print("Error encoding data.")
            return
        }
        do {
            try data.write(to: FilePath.bags.fileURL, options: .atomic)
        } catch {
            print("Error writing data to disk: \(error)")
        }
    }
    func loadBags() -> [Bag] {
        print("Loading bags...")
        guard let data = try? Data.init(contentsOf: FilePath.bags.fileURL) else {
            print("No data found, returning empty array.")
            return []
        }
        let decoder = PropertyListDecoder()
        do {
            let tempBags = try decoder.decode(Array<Bag>.self, from: data)
            print("Returning array of bags from disk: \(tempBags)")
            return tempBags
        } catch {
            fatalError("Unable to decode saved data: \(error)")
        }
    }
    func loadVendors() -> [Vendor] {
        print("Loading vendors...")
        guard let data = try? Data.init(contentsOf: FilePath.vendors.fileURL) else {
            fatalError("Unable to retrieve vendor list file.")
        }
        let decoder = PropertyListDecoder()
        do {
            let tempVendors = try decoder.decode(Array<Vendor>.self, from: data)
            print("Returning array of vendors from disk: \(tempVendors)")
            return tempVendors
        } catch {
            fatalError("Unable to decode saved data: \(error)")
        }
    }

}
