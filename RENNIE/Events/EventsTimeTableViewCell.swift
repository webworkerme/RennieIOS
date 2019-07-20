//
//  EventsTimeTableViewCell.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 08/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit

class EventsTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_eventName: UILabel!
    @IBOutlet weak var lbl_eventStage: UILabel!
    @IBOutlet weak var img_bg: UIImageView!
    
    func populateData ( eventName : String , eventStage : String ) {
        
        self.lbl_eventName.layer.borderColor = UIColor.white.cgColor
        self.lbl_eventName.layer.borderWidth = 1
        
        self.lbl_eventStage.layer.borderColor = UIColor.white.cgColor
        self.lbl_eventStage.layer.borderWidth = 1
        
        self.img_bg.layer.borderColor = UIColor.white.cgColor
        self.img_bg.layer.borderWidth = 1
        
        self.lbl_eventName.text = eventName
        self.lbl_eventStage.text = eventStage
        
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
