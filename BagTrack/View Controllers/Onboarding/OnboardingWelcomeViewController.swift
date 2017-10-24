//
//  OnboardingWelcome.swift
//  BagTrack
//
//  Created by Robin Kipp on 24.10.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit

class OnboardingWelcomeViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var textView: UITextView!

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = NSLocalizedString("Welcome to BagTrack!\n\nBagTrack utilizes iBeacon technology to keep track of your bags, luggage, and other belongings. An iBeacon and this app is all that’s required.", comment: "Onboarding welcome message.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
