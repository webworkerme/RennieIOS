//
//  FestivalTableViewCell.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 31/10/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import Alamofire

class FestivalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_festival: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var view_activity: UIActivityIndicatorView!
    @IBOutlet weak var img_logo: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func setFestivalData( festival : Festival ) {
        
        self.lbl_name.text = festival.FestivalName
        
        // setting dates
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "YYYYMMDD"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/DD/YY"
        let startDateInput = inputFormatter.date(from: festival.StartDate)
        let endDateInput = inputFormatter.date(from: festival.EndDate)
        let startDate = outputFormatter.string(from: startDateInput!)
        let endDate = outputFormatter.string(from: endDateInput!)
        self.lbl_date.text = "\(startDate) - \(endDate)"
        self.lbl_city.text = festival.StateName
        
        self.loadImage(festival: festival)
    }
    
    func loadImage ( festival : Festival) {
        
        self.img_logo.image = UIImage(named: "imageIcon")
        
        let imageURL = self.appDelegate.siteBaseURL + festival.files_profile
        
        if let image = self.appDelegate.imageChache.object(forKey: imageURL as NSString ) {
            self.img_logo.image = image
            return
        }
        
        self.view_activity.startAnimating()
        
        Alamofire.request(imageURL).responseData { (response) in
            
            self.view_activity.stopAnimating()
            if response.error == nil {
                
                if let data = response.data {
                    
                    let image = UIImage(data: data)
                    
                    if image != nil {
                        
                        self.img_logo.image = image
                        self.appDelegate.imageChache.setObject(image!, forKey: imageURL as NSString)
                    }
                    
                }
            }
        }
        
    }
    
    //
    
    func loadImage ( wishData : WishData) {
        
        self.img_logo.image = UIImage(data: wishData.wishImage )
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
