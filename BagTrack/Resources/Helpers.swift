//
//  Helpers.swift
//  BagTrack
//
//  Created by Robin Kipp on 09.10.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit

struct Helpers {
    enum alertTypes {
        case invalidData, noLocationPermission, noPushPermission, locationError
    }
    static func showAlert(_ type:alertTypes, error:Error?) -> UIAlertController {
        let titleString = "Error"
        var alertString:String!
        switch type {
        case .invalidData: alertString = NSLocalizedString("The data you provided is incorrect, please double-check and try again.", comment: "Invalid data error.")
        case .noLocationPermission: alertString = NSLocalizedString("BagTrack requires access to your location in order to function. Please enable location access in Settings.", comment: "Location access disabled.")
        case .noPushPermission: alertString = NSLocalizedString("BagTrack does not currently have the permission to send push notifications and therefore cannot alert you when you might be about to loose your bags. Please enable push notifications in Settings.", comment: "Push notifications disabled")
        case .locationError:
            guard let error = error else {
                fatalError("Attempted to present location alert without providing an error")
            }
            alertString = NSLocalizedString("An error has occurred while monitoring location information. \(error.localizedDescription)", comment: "Error while monitoring location.")
        }
        let alert = UIAlertController(title: titleString, message: alertString, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
}
