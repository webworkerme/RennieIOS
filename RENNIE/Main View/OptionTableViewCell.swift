//
//  OptionTableViewCell.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 06/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_option: UILabel!
    
    
    func setOption(option : String) {
        self.lbl_option.text = option
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
