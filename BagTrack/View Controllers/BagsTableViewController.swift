//
//  BagsTableViewController.swift
//  BagTrack
//
//  Created by Robin Kipp on 14.09.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit
import CoreLocation

class BagsTableViewController: UITableViewController {

    // MARK: - Properties

    var dataModel:DataModel!
    var bags:[Bag] = []
    var manager:CLLocationManager!

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        dataModel = DataModel.sharedInstance
        bags = dataModel.retrieveBags()
        tableView.reloadData()
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        print("Starting monitoring and ranging for \(bags.count) bags.")
        for bag in bags {
            if bag.isTrackingEnabled {
                startMonitoring(for: bag)
            }
        }

    }

    func startMonitoring(for bag:Bag) {
        manager.startMonitoring(for: bag.region)
        print("Region monitoring started.")
        manager.startRangingBeacons(in: bag.region)
        print("Beacon ranging started.")
    }
    func stopMonitoring(for bag:Bag) {
        manager.stopMonitoring(for: bag.region)
        print("Region monitoring stopped.")
        manager.stopRangingBeacons(in: bag.region)
        print("Beacon ranging stopped.")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bagCell", for: indexPath) as! BagCell
        let bag = bags[indexPath.row]
        cell.bag = bag
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    // Override to disable "swipe to delete" action unless in edit mode
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bag = bags[indexPath.row]
            stopMonitoring(for: bag)
            dataModel.deleteBag(at: indexPath.row)
            bags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let navController = segue.destination as? UINavigationController else {
            fatalError("Error: segue to unexpected view controller.")
        }
        guard let controller = navController.topViewController as? NewBagTableViewController else {
            fatalError("Error: navigation controller contains unexpected top view controller.")
        }
        controller.delegate = self
    }

}

// MARK: - NewBagDelegate

extension BagsTableViewController:NewBagDelegate {
    func newBagController(_ controller: NewBagTableViewController, didFinishAdding bag: Bag) {
        dataModel.add(bag: bag)
        startMonitoring(for: bag)
        bags.append(bag)
        tableView.reloadData()
    }
}

// MARK: - BagCellDelegate

extension BagsTableViewController:BagCellDelegate {
    func bagCell(_ cell: BagCell, didToggleTrackingFor bag: Bag) {
        if bag.isTrackingEnabled {
            stopMonitoring(for: bag)
            cell.proximityLabel.text = bag.proximityForDisplay()
            tableView.reloadData()
        } else {
            startMonitoring(for: bag)
            cell.proximityLabel.text = "Searching..."
        }
        dataModel.update(bag: bag, name: nil, proximityUUID: nil, majorValue: nil, minorValue: nil, beaconID: nil, proximity: .unknown, isTrackingEnabled: !bag.isTrackingEnabled)
    }
}
// MARK: - CLLocationManagerDelegate

extension BagsTableViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for index in 0 ..< bags.count {
            let bag = bags[index]
            for beacon in beacons {
                if bag == beacon {
                    print("Ranged beacon matches stored bag.")
                    bag.proximity = beacon.proximity
                    let indexPath = IndexPath(row: index, section: 0)
                    guard let cell = tableView.cellForRow(at: indexPath) as? BagCell else {
                        fatalError("No cell at requested IndexPath.")
                    }
                    cell.proximityLabel.text = bag.proximityForDisplay()
                }
            }
        }
    }
}
