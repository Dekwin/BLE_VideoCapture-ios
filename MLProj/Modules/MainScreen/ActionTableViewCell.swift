//
//  ActionTableViewCell.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/23/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(withAction action: BLERequestAction) {
        titleLabel.text = "\(action.command)"
        infoLabel.text = "\(action.isPerformable ? "P" : "NP") - \(action.date)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
