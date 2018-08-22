//
//  TodayViewCell.swift
//  Weda
//
//  Created by OLUNUGA Mayowa on 21/08/2018.
//  Copyright © 2018 OLUNUGA Mayowa. All rights reserved.
//

import UIKit

class TodayViewCell: UITableViewCell {

    @IBOutlet weak var lableTemperature: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
