//
//  OnboardingPager.swift
//  BagTrack
//
//  Created by Robin Kipp on 12.10.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit

class OnboardingPager: UIPageViewController {

    var controllers:[UIViewController] = []
    var counter = 0
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "canContinue")
        controllers.append(storyboard!.instantiateViewController(withIdentifier: "onboardingWelcome"))
        controllers.append(storyboard!.instantiateViewController(withIdentifier: "onboardingTech"))
        controllers.append(storyboard!.instantiateViewController(withIdentifier: "onboardingLocation"))
        controllers.append(storyboard!.instantiateViewController(withIdentifier: "onboardingPush"))
        controllers.append(storyboard!.instantiateViewController(withIdentifier: "onboardingReady"))
        setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onBackButtonTapped(_ sender: UIBarButtonItem) {
        counter -= 1
        setViewControllers([controllers[counter]], direction: .reverse, animated: true, completion: nil)
        UserDefaults.standard.set(true, forKey: "canContinue")
        nextButton.title = NSLocalizedString("Next", comment: "Next button.")
        if counter == 0 {
            backButton.isEnabled = false
        }
    }
    @IBAction func onNextButtonTapped(_ sender: UIBarButtonItem) {
        if !UserDefaults.standard.bool(forKey: "canContinue") {
            present(Helpers.showAlert(.missingSteps, error: nil), animated: true, completion: nil)
            return
        }
        if counter + 1 < controllers.count {
            counter += 1
            setViewControllers([controllers[counter]], direction: .forward, animated: true, completion: nil)
            backButton.isEnabled = true
            if counter + 1 == controllers.count {
                nextButton.title = NSLocalizedString("Done", comment: "Done button.")
            }
        } else {
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            UserDefaults.standard.removeObject(forKey: "canContinue")
            dismiss(animated: true, completion: nil)
        }
    }

}
