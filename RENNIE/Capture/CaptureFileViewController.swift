//
//  CaptureFileViewController.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 09/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import Gallery

import RealmSwift


class CaptureFileViewController: UIViewController, GalleryControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var lbl_festivalName: UILabel!
    
    @IBOutlet weak var txt_storeName: UITextField!
    @IBOutlet weak var txt_categoryName: UITextField!
    @IBOutlet weak var txt_notes: UITextField!
    
    @IBOutlet weak var lbl_lat: UILabel!
    @IBOutlet weak var lbl_lng: UILabel!
    
    @IBOutlet weak var tbl_categories: UITableView!
    
    @IBOutlet weak var btn_save: UIButton!
    @IBOutlet weak var img_capture: UIImageView!
    @IBOutlet weak var view_first: UIView!
    @IBOutlet weak var view_second: UIView!
    @IBOutlet weak var view_third: UIView!
    @IBOutlet weak var view_forth: UIView!
    
    
    var festival : Festival!
    let gallery = GalleryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gallery.delegate = self
        Config.tabsToShow = [ .cameraTab ]
        
        self.lbl_festivalName.text = self.festival.FestivalName
        
        self.lbl_lat.text = "LAT: " + self.festival.FestivalLat.description
        self.lbl_lng.text = "LNG: " + self.festival.FestivalLong.description
        
        self.btn_save.layer.borderColor = UIColor.white.cgColor
        self.btn_save.layer.borderWidth = 1
        self.view_first.layer.borderColor = UIColor.white.cgColor
        self.view_first.layer.borderWidth = 1
        self.view_second.layer.borderColor = UIColor.white.cgColor
        self.view_second.layer.borderWidth = 1
        self.view_third.layer.borderColor = UIColor.white.cgColor
        self.view_third.layer.borderWidth = 1
        self.view_forth.layer.borderColor = UIColor.white.cgColor
        self.view_forth.layer.borderWidth = 1
        self.img_capture.layer.borderColor = UIColor.white.cgColor
        self.img_capture.layer.borderWidth = 1
    
    }
    
    var shouldDisplay = true
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if self.shouldDisplay == true {
            self.shouldDisplay = false
            self.present(gallery, animated: true, completion: nil)
        }
        
    }
    
    
    let categories = [ "CLOTHING", "JEWELERY", "ARMORY", "TRINKETS" ]
    var selectedCategory = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = self.categories[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tbl_categories.isHidden = true
        self.selectedCategory = self.categories[indexPath.row]
        self.txt_categoryName.text = self.selectedCategory
        
    }
    
    
    @IBAction func btn_toggleCategories(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if self.tbl_categories.isHidden == true {
            self.tbl_categories.isHidden = false
        }
        else {
            self.tbl_categories.isHidden = true
        }
        
    }
    
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        
        controller.dismiss(animated: false) {
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        controller.dismiss(animated: true) {
            // picked image to view and database
            images.first?.resolve(completion: { (image) in
                self.img_capture.image = image
            })
        }
    }
    
    
    @IBAction func btn_save(_ sender: UIButton) {
        
        // save everything to local datebase
        
        if self.txt_storeName.text!.isEmpty {
            
            let alert = UIAlertController(title: "Warning", message: "Store name field is empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        else if self.txt_categoryName.text!.isEmpty || self.txt_categoryName.text == "Select Category" {
            
            let alert = UIAlertController(title: "Warning", message: "Category field is empty! Please select 'Category'.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        else if self.img_capture.image == nil {
            
            let alert = UIAlertController(title: "Warning", message: "Please select Image!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        let imageData = self.img_capture.image!.pngData()
        
        let realm = try! Realm()
        
        
        let wish = WishData.init(festivalName : self.festival.FestivalName! ,  stateName: self.festival.StateName!, storeName: self.txt_storeName.text!, categoryName: self.txt_categoryName.text!, notes: self.txt_notes.text!, lat: self.festival.FestivalLat, lng: self.festival.FestivalLong, wishImage: imageData!, startDate: self.festival.StartDate! , endDate: self.festival.EndDate!, stateImage: self.festival.state_image, festivalLogo: self.festival.files_profile)
        
        try! realm.write {
            realm.add(wish)
        }
        
        let alert = UIAlertController(title: "Success", message: "Data is saved in wish list.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    @IBAction func btn_back(_ sender: Any) {
        
        dismiss(animated: true) {
            // save and return data!
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

}

