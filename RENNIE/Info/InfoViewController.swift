//
//  InfoViewController.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 06/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LLSpinner

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var img_banner: UIImageView!
    @IBOutlet weak var view_general: UIView!
    @IBOutlet weak var view_activityBanner: UIActivityIndicatorView!
    
    @IBOutlet weak var tbl_policies: UITableView!
    
    var festival : Festival!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var policies = [(String, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view_general.layer.borderColor = UIColor.white.cgColor
        self.view_general.layer.borderWidth = 1
        
        self.loadBanner(bannerImage: self.festival.files_info)
        self.fetchEvents()
        
    }
    
    
    func loadBanner( bannerImage : String!) {
        
        let imageURL = self.appDelegate.siteBaseURL + bannerImage
        
        if let image = self.appDelegate.imageChache.object(forKey: imageURL as NSString) {
            self.img_banner.image = image
            return
        }
        
        self.view_activityBanner.startAnimating()
        self.img_banner.image = nil
        
        Alamofire.request(imageURL).responseData { (response) in
            
            self.view_activityBanner.stopAnimating()
            if response.error == nil {
                
                if let data = response.data {
                    
                    let image = UIImage(data: data)
                    self.img_banner.image = image
                    
                    if image != nil {
                        self.appDelegate.imageChache.setObject(image!, forKey: imageURL as NSString)
                    }
                    
                }
            }
            
        }
        
    }
    
    func fetchEvents() {
        
        let requestURL = self.appDelegate.baseURL + "get_polices/d8263a0a1045391cbe5923cc1ba5a589e8f843770a6b5088d3bbf066ef5b4a64"
        
        let param = [
            "festival_id" :  self.festival.FestivalID!
        ]
        
        LLSpinner.spin()
        Alamofire.request(requestURL, method : .get, parameters: param).responseJSON { response in
            
            LLSpinner.stop()
            
            if response.result.value == nil {
                let alert = UIAlertController(title: "Warning", message: "Unable To Perform Festival Request!", preferredStyle: .alert)
                
                let okAction  = UIAlertAction(title: "OK", style: .default, handler: nil)
                let retry = UIAlertAction(title: "Retry", style: .cancel, handler: { (action) in
                    self.fetchEvents()
                })
                
                alert.addAction(okAction)
                alert.addAction(retry)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            else  {
                
                let response = JSON(response.result.value!)
                
                if response["response"].intValue == -1 || response["response"].intValue == 0 {
                    
                    let alert = UIAlertController(title: "Warning", message: response["message"].stringValue, preferredStyle: .alert)
                    let okAction  = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                    
                else if response["response"].intValue == 1 {
                    
                    let listPolicy = response["data"]
                    
                    for policy in listPolicy {
                        
                        print(policy.0 + " ", policy.1.stringValue)
                        
                        if !policy.1.stringValue.isEmpty  {
                            self.policies.append( ( policy.0, policy.1.stringValue )  )
                        }
                        
                    }
                }
                
                self.tbl_policies.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.policies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // first type of cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "policyCell", for: indexPath) as! PolicyTableViewCell
        
        let keyImage = self.policies[indexPath.row].0.replacingOccurrences(of: "/", with: "")
        cell.img_logo.image = UIImage(named: keyImage)
        cell.txt_detail.text = self.policies[indexPath.row].1
        
        return cell
    }
    
    
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

}
