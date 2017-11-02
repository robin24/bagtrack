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
        case invalidData, noLocationPermission, noPushPermission, locationError, missingSteps
    }
    static func showAlert(_ type:alertTypes, error:Error?) -> UIAlertController {
        let titleString = NSLocalizedString("Error", comment: "Error dialog title.")
        var alertString = ""
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK button."), style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Settings button."), style: .default) { _ in
            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
                fatalError("Error retrieving settings URL.")
            }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil) }
        var hasOKAction = true
        var hasSettingsAction = false
        switch type {
        case .invalidData: alertString = NSLocalizedString("The data you provided is incorrect, please double-check and try again.", comment: "Invalid data error.")
        case .noLocationPermission:
            alertString = NSLocalizedString("BagTrack needs to access your location in the background in order to function. Please tap on “Settings” and set “Location” to “Always.”", comment: "Location access disabled.")
            hasOKAction = false
            hasSettingsAction = true
        case .noPushPermission:
            alertString = NSLocalizedString("BagTrack does not currently have the permission to send push notifications and therefore cannot alert you when you might be about to loose your bags. Please enable push notifications in Settings.", comment: "Push notifications disabled")
            hasSettingsAction = true
        case .locationError:
            guard let error = error else {
                fatalError("Attempted to present location alert without providing an error")
            }
            alertString = NSLocalizedString("An error has occurred while monitoring location information. \(error.localizedDescription)", comment: "Error while monitoring location.")
        case .missingSteps: alertString = NSLocalizedString("Please follow the on-screen instructions before continuing.", comment: "Shown when the user tries to proceed to the next onboarding screen without completing a necessary action.")
        }
        let alert = UIAlertController(title: titleString, message: alertString, preferredStyle: .alert)
        if hasOKAction {
            alert.addAction(okAction)
        }
        if hasSettingsAction {
            alert.addAction(settingsAction)
        }
        return alert
    }
}
