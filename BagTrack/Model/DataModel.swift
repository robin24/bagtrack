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
        let filePath = getFilePath()
        do {
            try data.write(to: filePath, options: .atomic)
        } catch {
            print("Error writing data to disk: \(error)")
        }
    }
    func loadBags() -> [Bag] {
        print("Loading bags...")
        let filePath = getFilePath()
        guard let data = try? Data.init(contentsOf: filePath) else {
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
    private func getFilePath() -> URL {
        let homeDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = homeDir[0].appendingPathComponent("Bags.plist", isDirectory: false)
        return filePath
    }
}
