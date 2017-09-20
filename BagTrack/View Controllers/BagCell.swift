//
//  BagCell.swift
//  BagTrack
//
//  Created by Robin Kipp on 20.09.17.
//  Copyright © 2017 Robin Kipp. All rights reserved.
//

import UIKit

class BagCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var proximityLabel: UILabel!

    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
