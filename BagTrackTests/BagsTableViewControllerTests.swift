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

    var bundle:Bundle!
    var storyboard:UIStoryboard!
    var subject:BagsTableViewController!
    var bag:Bag!
    var dataModel:DataModel!

    override func setUp() {
        super.setUp()
        bundle = Bundle(for: BagsTableViewController.self)
        storyboard = UIStoryboard(name: "Main", bundle: bundle)
        subject = storyboard.instantiateViewController(withIdentifier: "MyBags") as! BagsTableViewController
        let testUUID = UUID(uuidString: "39EF51FA-F162-4A11-8DF4-F636D20679F8")!
        let major = CLBeaconMajorValue(1)
        let minor = CLBeaconMinorValue(1)
        bag = Bag(name: "Test Bag", proximityUUID: testUUID, majorValue: major, minorValue: minor, beaconID: "TestBag123")
        dataModel = DataModel.sharedInstance
    }

    override func tearDown() {
        subject = nil
        storyboard = nil
        bundle = nil
        bag = nil
        dataModel = nil
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

    func testTracking() {
        XCTAssertNotNil(subject)
        XCTAssertNotNil(subject.view)
        subject.dataModel.bags.append(bag)
        XCTAssertEqual(subject.dataModel.bags.count, 1)
    }
    
    
}
