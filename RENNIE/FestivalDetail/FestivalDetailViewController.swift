//
//  FestivalDetailViewController.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 10/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import RealmSwift

class FestivalDetailViewController: UIViewController {

    var wish : WishData!
    
    @IBOutlet weak var lbl_festivalName: UILabel!
    
    @IBOutlet weak var img_banner: UIImageView!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_categoryName: UITextField!
    @IBOutlet weak var lbl_lat: UILabel!
    @IBOutlet weak var lbl_lng: UILabel!
    @IBOutlet weak var txt_notes: UITextField!
    
    
    @IBOutlet weak var view_first: UIView!
    @IBOutlet weak var view_second: UIView!
    @IBOutlet weak var view_third: UIView!
    @IBOutlet weak var view_forth: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view_first.layer.borderColor = UIColor.white.cgColor
        self.view_first.layer.borderWidth = 1
        self.view_second.layer.borderColor = UIColor.white.cgColor
        self.view_second.layer.borderWidth = 1
        self.view_third.layer.borderColor = UIColor.white.cgColor
        self.view_third.layer.borderWidth = 1
        self.view_forth.layer.borderColor = UIColor.white.cgColor
        self.view_forth.layer.borderWidth = 1
        
        self.lbl_festivalName.text = self.wish.festivalName
        self.img_banner.image = UIImage(data: self.wish.wishImage  )
        self.txt_name.text = self.wish.storeName
        self.txt_categoryName.text = self.wish.categoryName
        self.lbl_lat.text = "LAT: " + self.wish.lat.description
        self.lbl_lng.text = "LNG: " +  self.wish.lng.description
        self.txt_notes.text = self.wish.notes
        
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
