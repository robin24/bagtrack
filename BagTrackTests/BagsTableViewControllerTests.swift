//
//  BagsTableViewControllerTests.swift
//  BagTrackTests
//
//  Created by Robin Kipp on 16.11.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import XCTest
import CoreLocation
@testable import BagTrack

class BagsTableViewControllerTests: XCTestCase {

    let bag = Bag(name: "Test Bag", proximityUUID: UUID(uuidString: "39EF51FA-F162-4A11-8DF4-F636D20679F8")!, majorValue: CLBeaconMajorValue(1), minorValue: CLBeaconMinorValue(1), beaconID: "TestBag123")
    let dataModel = DataModel.sharedInstance

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBagStates() {
        XCTAssertNotNil(bag)
        XCTAssertEqual(bag.proximity, .unknown)
        bag.proximity = .immediate
        XCTAssertEqual(bag.proximityForDisplay(), "Immediate")
        bag.proximity = .near
        XCTAssertEqual(bag.proximityForDisplay(), "Near")
        bag.proximity = .far
        XCTAssertEqual(bag.proximityForDisplay(), "Far")
        bag.isTrackingEnabled = false
        XCTAssertEqual(bag.proximityForDisplay(), "Tracking off")
    }

    func testDataModel() {
        XCTAssertNotNil(dataModel)
        XCTAssertEqual(dataModel.bags.count, 0)
        dataModel.bags.append(bag)
        dataModel.saveToDisk()
        var bagsFromDisk = dataModel.loadBags()
        XCTAssertEqual(dataModel.bags, bagsFromDisk)
        dataModel.bags.remove(at: 0)
        dataModel.saveToDisk()
        bagsFromDisk = dataModel.loadBags()
        XCTAssertEqual(bagsFromDisk.count, 0)
    }

}
