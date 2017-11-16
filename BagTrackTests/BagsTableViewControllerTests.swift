//
//  BagsTableViewControllerTests.swift
//  BagTrackTests
//
//  Created by Robin Kipp on 16.11.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import XCTest
@testable import BagTrack

class BagsTableViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTracking() {
        let bundle = Bundle(for: BagsTableViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let subject = storyboard.instantiateViewController(withIdentifier: "MyBags") as! BagsTableViewController
        XCTAssertNotNil(subject.view)
    }
    
    
}
