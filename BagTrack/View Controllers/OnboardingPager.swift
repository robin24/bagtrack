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
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
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

}

extension OnboardingPager:UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if counter >= 0 {
            counter -= 1
            return controllers[counter]
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if counter + 1 < controllers.count {
            counter += 1
            return controllers[counter]
        }
        return nil
    }
}
