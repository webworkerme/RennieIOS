//
//  StateTableViewCell.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 31/10/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_stateName: UILabel!
    
    
    func setStateData( state : TState ) {
        lbl_stateName.text = state.stateName
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
