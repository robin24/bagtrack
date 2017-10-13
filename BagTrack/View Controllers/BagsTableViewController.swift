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
    var manager:CLLocationManager!

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            performSegue(withIdentifier: "onboardingSegue", sender: nil)
        }
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        dataModel = DataModel.sharedInstance
        manager = CLLocationManager()
        manager.delegate = self
        for bag in dataModel.bags {
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
    @IBAction func onAddButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addBag", sender: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.bags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bagCell", for: indexPath) as! BagCell
        let bag = dataModel.bags[indexPath.row]
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editBag", sender: indexPath)
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bag = dataModel.bags[indexPath.row]
            stopMonitoring(for: bag)
            dataModel.bags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "onboardingSegue" {
            return
        }
        guard let navController = segue.destination as? UINavigationController else {
            fatalError("Error: segue to unexpected view controller.")
        }
        guard let controller = navController.topViewController as? BagDetailTableViewController else {
            fatalError("Error: navigation controller contains unexpected top view controller.")
        }
        controller.delegate = self
        if segue.identifier == "editBag" {
            controller.title = NSLocalizedString("Edit Bag", comment: "Window title shown when editing a bag.")
            let indexPath = sender as! IndexPath
            controller.bag = dataModel.bags[indexPath.row]
            controller.indexPath = indexPath
        }
    }

}

// MARK: - NewBagDelegate

extension BagsTableViewController:BagDetailDelegate {
    func bagDetailController(_ controller: BagDetailTableViewController, didFinishAdding bag: Bag) {
        dataModel.bags.append(bag)
        startMonitoring(for: bag)
        let indexPath = IndexPath(row: dataModel.bags.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    func bagDetailController(_ controller: BagDetailTableViewController, didFinishEditing bag: Bag, at indexPath: IndexPath) {
        dataModel.bags.remove(at: indexPath.row)
        dataModel.bags.insert(bag, at: indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! BagCell
        cell.bag = bag
        cell.configureCell(for: bag)
    }
}

// MARK: - BagCellDelegate

extension BagsTableViewController:BagCellDelegate {
    func bagCell(_ cell: BagCell, didToggleTrackingFor bag: Bag) {
        if bag.isTrackingEnabled {
            stopMonitoring(for: bag)
            bag.isTrackingEnabled = false
            bag.proximity = .unknown
            cell.proximityLabel.text = bag.proximityForDisplay()
        } else {
            bag.isTrackingEnabled = true
            startMonitoring(for: bag)
            cell.proximityLabel.text = NSLocalizedString("Searching...", comment: "Searching after tracking is enabled.")
        }
    }
}
// MARK: - CLLocationManagerDelegate

extension BagsTableViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for index in 0 ..< dataModel.bags.count {
            let bag = dataModel.bags[index]
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
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        present(Helpers.showAlert(.locationError, error: error), animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        present(Helpers.showAlert(.locationError, error: error), animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        present(Helpers.showAlert(.locationError, error: error), animated: true, completion: nil)
    }
}
