//
//  OnboardingLocationViewController.swift
//  BagTrack
//
//  Created by Robin Kipp on 13.10.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit
import CoreLocation

class OnboardingLocationViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    var manager:CLLocationManager!
    var invalidPermissions = false

    // MARK: - Methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            UserDefaults.standard.set(false, forKey: "canContinue")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = NSLocalizedString("BagTrack utilizes location services for iBeacon tracking.\n\nLocation services are used only in order to determine the proximity between you and your belongings. Your geographic location will never be queried by this app.\n\nPlease tap the “Allow Location” button below and choose “Always Allow” in the following prompt in order to continue.", comment: "Onboarding message informing the user about the app's usage of location services.")
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, textView)
        manager = CLLocationManager()
        manager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onAllowButtonTapped(_ sender: UIButton) {
        if invalidPermissions {
            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
                fatalError("Error retrieving settings URL.")
            }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        } else {
            manager.requestAlwaysAuthorization()
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension OnboardingLocationViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        } else if status == .authorizedAlways {
            allowButton.isHidden = true
            UserDefaults.standard.set(true, forKey: "canContinue")
            textView.text = NSLocalizedString("Thank you for enabling location services!", comment: "Shown after location services are enabled.")
        } else {
            allowButton.setTitle(NSLocalizedString("Settings", comment: "Settings button."), for: .normal)
            invalidPermissions = true
            textView.text = NSLocalizedString("Unfortunately, you have chosen an incorrect location access permission. Please, tap on “Settings,” and set “Location” to “Always.”", comment: "Shown on onboarding screen when location permissions are incorrect.")
        }
    }
}
