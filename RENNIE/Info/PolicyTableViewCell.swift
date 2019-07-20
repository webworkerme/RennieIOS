//
//  PolicyTableViewCell.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 30/12/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit

class PolicyTableViewCell: UITableViewCell {

    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var txt_detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
