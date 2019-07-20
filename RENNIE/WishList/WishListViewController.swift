//
//  WIshListViewController.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 09/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import RealmSwift

class WishListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var collection_clothing: UICollectionView!
    @IBOutlet weak var collection_jewelery: UICollectionView!
    @IBOutlet weak var collection_armory: UICollectionView!
    @IBOutlet weak var collectioin_trinkets: UICollectionView!
    
    
    @IBOutlet weak var btn_newWish: UIButton!
    @IBOutlet weak var lbl_festivalName: UILabel!
    
    var festival : Festival!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_festivalName.text = self.festival.FestivalName
        self.btn_newWish.layer.borderColor = UIColor.white.cgColor
        self.btn_newWish.layer.borderWidth = 1
        
    }
    
    var clothing :  Results<WishData>!
    var jewewlery : Results<WishData>!
    var armory : Results<WishData>!
    var trinkets : Results<WishData>!
    
    // Load Items!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.clothing = self.realm.objects(WishData.self).filter("stateName == '\(self.festival.StateName!)' AND categoryName == 'CLOTHING'")
        self.jewewlery = self.realm.objects(WishData.self).filter("stateName == '\(self.festival.StateName!)' AND categoryName == 'JEWELERY'")
        self.armory = self.realm.objects(WishData.self).filter("stateName == '\(self.festival.StateName!)' AND categoryName == 'ARMORY'")
        self.trinkets = self.realm.objects(WishData.self).filter("stateName == '\(self.festival.StateName!)' AND categoryName == 'TRINKETS'")
        
        self.collection_clothing.reloadData()
        self.collection_jewelery.reloadData()
        self.collection_armory.reloadData()
        self.collectioin_trinkets.reloadData()
        
    }
    
    
    @IBAction func btn_camera(_ sender: UIButton) {
        performSegue(withIdentifier: "sw_capture", sender: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 && self.clothing != nil {
            return self.clothing.count
        }
        
        else if collectionView.tag == 2 && self.jewewlery != nil {
            return self.jewewlery.count
        }
        
        else if collectionView.tag == 3 && self.armory != nil {
            return self.armory.count
        }
        
        else if collectionView.tag == 4 && self.trinkets != nil {
            return self.trinkets.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishCell", for: indexPath) as! WishCollectionViewCell
        
        if collectionView.tag == 1 {
            
            let image = UIImage.init(data: self.clothing[indexPath.row].wishImage)
            cell.img_wishImage.image = image
            cell.img_wishImage.layer.borderColor = UIColor.white.cgColor
            cell.img_wishImage.layer.borderWidth = 1
            
        }
        
        else if collectionView.tag == 2 {
            
            let image = UIImage.init(data: self.jewewlery[indexPath.row].wishImage)
            cell.img_wishImage.image = image
            cell.img_wishImage.layer.borderColor = UIColor.white.cgColor
            cell.img_wishImage.layer.borderWidth = 1
            
        }
        
        else if collectionView.tag == 3 {
            
            let image = UIImage.init(data: self.armory[indexPath.row].wishImage)
            cell.img_wishImage.image = image
            cell.img_wishImage.layer.borderColor = UIColor.white.cgColor
            cell.img_wishImage.layer.borderWidth = 1
            
        }
        
        if collectionView.tag == 4 {
            
            let image = UIImage.init(data: self.trinkets[indexPath.row].wishImage)
            cell.img_wishImage.image = image
            cell.img_wishImage.layer.borderColor = UIColor.white.cgColor
            cell.img_wishImage.layer.borderWidth = 1
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            performSegue(withIdentifier: "sw_festDetail", sender: self.clothing[indexPath.row])
        }
        else if collectionView.tag == 2 {
            performSegue(withIdentifier: "sw_festDetail", sender: self.jewewlery[indexPath.row])
        }
        else if collectionView.tag == 3 {
            performSegue(withIdentifier: "sw_festDetail", sender: self.armory[indexPath.row])
        }
        else if collectionView.tag == 4 {
            performSegue(withIdentifier: "sw_festDetail", sender: self.trinkets[indexPath.row])
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  40
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    
    @IBAction func segment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            self.collection_clothing.isHidden = false
            self.collection_jewelery.isHidden = true
            self.collection_armory.isHidden = true
            self.collectioin_trinkets.isHidden = true
        }
        else if sender.selectedSegmentIndex == 1 {
            
            self.collection_clothing.isHidden = true
            self.collection_jewelery.isHidden = false
            self.collection_armory.isHidden = true
            self.collectioin_trinkets.isHidden = true
            
        }
        else if sender.selectedSegmentIndex == 2 {
            
            self.collection_clothing.isHidden = true
            self.collection_jewelery.isHidden = true
            self.collection_armory.isHidden = false
            self.collectioin_trinkets.isHidden = true
            
        }
        else if sender.selectedSegmentIndex == 3 {
            
            self.collection_clothing.isHidden = true
            self.collection_jewelery.isHidden = true
            self.collection_armory.isHidden = true
            self.collectioin_trinkets.isHidden = false
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sw_capture" {
            let dest = segue.destination as! CaptureFileViewController
            dest.festival = self.festival
        }
        
        else if segue.identifier == "sw_festDetail" {
            let dest = segue.destination as! FestivalDetailViewController
            dest.wish = sender as? WishData
            
        }
        
    }
    
    
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
