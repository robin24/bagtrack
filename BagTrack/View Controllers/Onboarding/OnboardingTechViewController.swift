//
//  OnboardingTechViewController.swift
//  BagTrack
//
//  Created by Robin Kipp on 24.10.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit

class OnboardingTechViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var textView: UITextView!

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = NSLocalizedString("iBeacons are small, portable devices that send out Bluetooth Low Energy signals at regular intervals.\n\nCarrying such a device in your bag will allow BagTrack to automatically monitor the distance between you and your bag, sending you a push notification whenever you might be about to leave your belongings behind.\n\nIn order to start tracking, you will need your iBeacon’s UUID, its major and minor value, and its identifier. Please check your device’s manual or the manufacturer’s website in order to find this information.", comment: "Onboarding message providing information on how to use BagTrack.")
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, textView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
