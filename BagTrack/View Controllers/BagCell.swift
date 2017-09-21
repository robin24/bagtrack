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
    weak var delegate:BagCellDelegate?
    var bag:Bag! {
        didSet {
            configureCell(for: bag)
        }
    }

    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(for bag:Bag) {
        nameLabel.text = bag.name
        proximityLabel.text = bag.proximityForDisplay()
        trackingSwitch.isOn = bag.isTrackingEnabled
    }
    @IBAction func onTrackingSwitchToggled(_ sender: UISwitch) {
        delegate?.bagCell(self, didToggleTrackingFor: bag)
    }

}
