//
//  FestivalViewController.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 06/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import Alamofire
import StoreKit

class FestivalViewController: UIViewController {
    
    @IBOutlet weak var view_activity: UIActivityIndicatorView!
    @IBOutlet weak var img_backGround: UIImageView!
    
    var festival : Festival!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadBackground(homeImage: festival.files_home)
        
    }
    
    @IBAction func btn_back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func loadBackground(homeImage : String) {
        
        let imageURL = self.appDelegate.siteBaseURL + homeImage
        
        if let image = self.appDelegate.imageChache.object(forKey: imageURL as NSString) {
            self.img_backGround.image = image
            return
        }
        
        self.view_activity.startAnimating()
        Alamofire.request(imageURL).responseData { (response) in
            
            self.view_activity.stopAnimating()
            if response.error == nil {
                if let data = response.data {
                    let image = UIImage(data: data)
                    
                    if image != nil {
                        self.img_backGround.image = UIImage(data: data)
                        self.appDelegate.imageChache.setObject(image!, forKey: imageURL as NSString)
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func btn_info(_ sender: Any) {
        performSegue(withIdentifier: "sw_info", sender: nil)
    }
    
    
    @IBAction func btn_events(_ sender: Any) {
        performSegue(withIdentifier: "sw_events", sender: nil)
    }
    
    
    @IBAction func btn_map(_ sender: Any) {
        performSegue(withIdentifier: "sw_map", sender: nil)
    }
    
    
    @IBAction func btn_wish(_ sender: Any) {
        
        performSegue(withIdentifier: "sw_wishList", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sw_info" {
            
            let dest = segue.destination as! InfoViewController
            dest.festival = self.festival
            
        }
        else if segue.identifier == "sw_events" {
            
            let dest = segue.destination as! EventsViewController
            dest.festival = self.festival
            
        }
        else if segue.identifier == "sw_map" {
            
            let dest = segue.destination as! MapViewController
            dest.festival = self.festival
            
        }
        else if segue.identifier == "sw_wishList" {
            let dest = segue.destination as! WishListViewController
            dest.festival = self.festival
        }
        
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}


extension FestivalViewController {
    
    func fetchProducts() {
        
        let productIDs = Set(self.appDelegate.productSet)
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
        
    }
    
    func purchase(productID: String) {
        
        if let product = self.appDelegate.products[productID] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
        
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}


extension FestivalViewController: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers.forEach { product in
            print("Invalid: \(product)")
        }
        
        response.products.forEach { product in
            print("Valid: \(product)")
            self.appDelegate.products[product.productIdentifier] = product
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error for request: \(error.localizedDescription)")
    }
    
    
    func requestDidFinish(_ request: SKRequest) {
        print("Request did finish!")
    }
    
    
}
