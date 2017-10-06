//
//  BagCell.swift
//  BagTrack
//
//  Created by Robin Kipp on 20.09.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit

// MARK: - BagCellDelegate
protocol BagCellDelegate:class {
    func bagCell(_ cell:BagCell, didToggleTrackingFor bag:Bag)
}
class BagCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var trackingLabel:UILabel!
    weak var delegate:BagCellDelegate?
    var bag:Bag! {
        didSet {
            configureCell(for: bag)
        }
    }

    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(for bag:Bag) {
        nameLabel.text = bag.name
        proximityLabel.text = bag.proximityForDisplay()
        trackingSwitch.isOn = bag.isTrackingEnabled
        trackingSwitch.isAccessibilityElement = false
        trackingLabel.isAccessibilityElement = false
        if trackingSwitch.isOn {
            let action = UIAccessibilityCustomAction(name: NSLocalizedString("Disable Tracking", comment: "Accessibility action to disable tracking."), target: self, selector: #selector(toggleSwitchAccessibilityAction(_:)))
            self.accessibilityCustomActions = [action]
        } else {
            let action = UIAccessibilityCustomAction(name: NSLocalizedString("Enable Tracking", comment: "Accessibility action to enable tracking."), target: self, selector: #selector(toggleSwitchAccessibilityAction(_:)))
            self.accessibilityCustomActions = [action]
        }

    }
    @IBAction func onTrackingSwitchToggled(_ sender: Any) {
        delegate?.bagCell(self, didToggleTrackingFor: bag)
    }
    @objc func toggleSwitchAccessibilityAction(_ sender:Any) {
        trackingSwitch.isOn = !trackingSwitch.isOn
        delegate?.bagCell(self, didToggleTrackingFor: bag)
        if trackingSwitch.isOn {
            let action = UIAccessibilityCustomAction(name: NSLocalizedString("Disable Tracking", comment: "Accessibility action to disable tracking."), target: self, selector: #selector(toggleSwitchAccessibilityAction(_:)))
            self.accessibilityCustomActions = [action]
        } else {
            let action = UIAccessibilityCustomAction(name: NSLocalizedString("Enable Tracking", comment: "Accessibility action to enable tracking."), target: self, selector: #selector(toggleSwitchAccessibilityAction(_:)))
            self.accessibilityCustomActions = [action]
        }
    }

}
