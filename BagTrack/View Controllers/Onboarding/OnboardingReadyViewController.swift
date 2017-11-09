//
//  OnboardingReadyViewController.swift
//  BagTrack
//
//  Created by Robin Kipp on 24.10.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit

class OnboardingReadyViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var textView: UITextView!

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = NSLocalizedString("Congratulations, you’re all set!\n\nWe hope you enjoy using BagTrack.", comment: "Shown to the user at the end of the onboarding process.")
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, textView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
