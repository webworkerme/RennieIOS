//
//  WholeWishListViewController.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 10/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class WholeWishListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var view_festivals: UIView!
    @IBOutlet weak var view_states: UIView!
    
    @IBOutlet weak var view_activity: UIActivityIndicatorView!
    @IBOutlet weak var img_banner: UIImageView!
    @IBOutlet weak var tbl_festivals: UITableView!
    @IBOutlet weak var tbl_states: UITableView!
    @IBOutlet weak var lbl_stateName: UILabel!
    
    let realm = try! Realm()
    var states = [String]()
    
    var allFestivals : Results<WishData>!
    var stateFestivals : Results<WishData>!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allFestivals = realm.objects(WishData.self)
        for object in self.allFestivals {
            
            if !self.states.contains(object.stateName) {
                self.states.append(object.stateName)
            }
        }
        
        if self.states.count != 0 {
            self.loadState(stateName: self.states[0])
        }
        else {
            self.tbl_festivals.isHidden = true
            self.tbl_states.isHidden = true
            
            let alert = UIAlertController(title: "No Data", message: "No data found related to states.", preferredStyle: .alert)
            let okActiion = UIAlertAction(title: "OK", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okActiion)
            present(alert, animated: true)
        }
        
        self.view_festivals.layer.borderColor = UIColor.white.cgColor
        self.view_festivals.layer.borderWidth = 1
        
        self.view_states.layer.borderColor = UIColor.white.cgColor
        self.view_states.layer.borderWidth = 1
        
    }
    
    
    func showStateImage( url : String!) {
        
        let imageURL = self.appDelegate.siteBaseURL + url
        
        if let image = self.appDelegate.imageChache.object(forKey: imageURL as NSString) {
            self.img_banner.image = image
            return
        }
        
        
        self.view_activity.startAnimating()
        self.img_banner.image = nil
        
        Alamofire.request(imageURL).responseData { (response) in
            
            self.view_activity.stopAnimating()
            if response.error == nil {
                
                if let data = response.data {
                    
                    let image = UIImage(data: data)
                    self.img_banner.image = image
                    
                    if image != nil {
                        self.appDelegate.imageChache.setObject(image!, forKey: url! as NSString)
                    }
                    
                }
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            
            if self.stateFestivals == nil {
                return 0
            }
            else {
                return self.stateFestivals.count
            }
            
            
        }
        else if tableView.tag == 2 {
            return states.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "festivalCell", for: indexPath) as! FestivalTableViewCell
            
            cell.lbl_city.text = self.stateFestivals[indexPath.row].stateName
            cell.lbl_date.text = "\(self.stateFestivals[indexPath.row].startDate) - \(self.stateFestivals[indexPath.row].endDate)"
            cell.lbl_name.text = self.stateFestivals[indexPath.row].festivalName
            cell.loadImage(wishData: self.stateFestivals![indexPath.row])
            
            return cell
        }
        else if tableView.tag == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath) as! StateTableViewCell
            cell.lbl_stateName.text = self.states[indexPath.row]
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            // show wish detail like before!
            performSegue(withIdentifier: "sw_stateWishList", sender: self.lbl_stateName.text!)
            
        }
        else if tableView.tag == 2 {
            self.loadState(stateName: self.states[indexPath.row])
        }
        
    }
    
    func loadState (stateName : String) {
        
        // load state with state name
        self.lbl_stateName.text = stateName
        self.stateFestivals = self.allFestivals.filter("stateName == '\(stateName)'")
        self.tbl_festivals.reloadData()
    
        if self.stateFestivals.count != 0 {
            let stateImage = self.stateFestivals[0].stateImage
            self.showStateImage(url: stateImage)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sw_stateWishList" {
            
            let dest = segue.destination as! StateWishListViewController
            dest.stateName = sender as! String
            
        }
        
    }
    
    
    @IBAction func btn_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    

}
