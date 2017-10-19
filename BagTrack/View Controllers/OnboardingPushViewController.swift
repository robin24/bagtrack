//
//  OnboardingPushViewController.swift
//  BagTrack
//
//  Created by Robin Kipp on 13.10.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit
import UserNotifications

class OnboardingPushViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var allowButton: UIButton!
    var center:UNUserNotificationCenter!
    var pushActivationFailed = false

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        center = UNUserNotificationCenter.current()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onAllowButtonTapped(_ sender: UIButton) {
        if pushActivationFailed {
            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
                fatalError("Error retrieving settings URL.")
            }
            UIApplication.shared.open(settingsURL, options: [:]) { _ in
                DispatchQueue.main.async {
                    self.textView.text = NSLocalizedString("Thank you!", comment: "Shown when returning to the app from the settings screen.")
                    self.allowButton.isHidden = true
                } }
            return
        }
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.textView.text = NSLocalizedString("Thank you for enabling push notifications!", comment: "Shown after push notifications were enabled.")
                    self.allowButton.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.textView.text = NSLocalizedString("Oops, something went wrong! We were unable to activate push notifications. Please tap “Settings” now to enable notifications, or tap “Next” if you prefer to do so later.", comment: "Shown when unable to activate notifications.")
                    self.pushActivationFailed = true
                    self.allowButton.setTitle("Settings", for: .normal)
                }
            } }
    }
}
