//
//  MainViewController.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 30/10/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import RealmSwift
import Toast_Swift
import MessageUI
import LLSpinner
import StoreKit

protocol SendEmailDelegate {
    func sendEmail(email : String, suggestion : String)
    
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, SendEmailDelegate {
    
    @IBOutlet weak var lbl_stateName: UILabel!
    @IBOutlet weak var view_festivals: UIView!
    @IBOutlet weak var view_states: UIView!
    @IBOutlet weak var tbl_festivals: UITableView!
    @IBOutlet weak var tbl_states: UITableView!
    @IBOutlet weak var tbl_options: UITableView!
    
    @IBOutlet weak var view_activityImage: UIActivityIndicatorView!
    @IBOutlet weak var img_stateBanner: UIImageView!
    
    @IBOutlet weak var const_tableHeight: NSLayoutConstraint!
    @IBOutlet weak var const_optionHeight: NSLayoutConstraint!
    
    
    var menuUpgrade = [ "Upgrade App" , "Suggestions" , "My Wish List"]
    var menuPruchased = [ "Create Marker" , "Clear Marker", "My Wish List", "Suggestions"]
    
    var menu = [ String ]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var locationManager = CLLocationManager()
    let realm = try! Realm()
    
    var festivalList = [Festival]()
    var stateList = [TState]()
    
    var stateName = "Texas"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tbl_options.tableHeaderView = UIView(frame: frame)
        
        self.view_festivals.layer.borderColor = UIColor.white.cgColor
        self.view_festivals.layer.borderWidth = 1
        
        self.tbl_states.layer.borderColor = UIColor.white.cgColor
        self.tbl_states.layer.borderWidth = 1
        
        self.view_states.layer.borderColor = UIColor.white.cgColor
        self.view_states.layer.borderWidth = 1
        
        self.tbl_options.layer.borderColor = UIColor.white.cgColor
        self.tbl_options.layer.borderWidth = 1
        
        self.tbl_festivals.layer.borderColor = UIColor.white.cgColor
        self.tbl_festivals.layer.borderWidth = 1
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
        
        self.fetchFestivals(state: "Texas")
        
        if self.appDelegate.products.count == 0 {
            
            let alertView = UIAlertController(title: "Restore Purchases!", message: "Do you want to restore purhases? ", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { ( action ) in
            }
            let continueAction = UIAlertAction(title: "Continue...", style: .default) { ( action ) in
                self.appDelegate.restorePurchases()
            }
            
            alertView.addAction(continueAction)
            alertView.addAction(cancelAction)
            self.present(alertView, animated: true)
        }
        
        if self.appDelegate.products.count == 0 {
            self.menu = self.menuUpgrade
        }
        else {
            self.menu  = self.menuPruchased
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let first = locations.first?.coordinate
        
        let location = CLLocation(latitude: (first?.latitude)!, longitude: (first?.longitude)! )
        
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let _ = country, error == nil else { return }
            
            if city != self.stateName {
                self.stateName = city
                self.fetchFestivals(state: self.stateName)
            }
        }
    }
    
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    
    func fetchFestivals (state : String) {
        
        let requestURL = self.appDelegate.baseURL + "get_festivals/d8263a0a1045391cbe5923cc1ba5a589e8f843770a6b5088d3bbf066ef5b4a64"
        
        let param = [
            "state" : state
        ]
        
        LLSpinner.spin()
        Alamofire.request(requestURL, method : .get, parameters: param).responseJSON { response in
            LLSpinner.stop()
            
            if response.result.value == nil {
                let alert = UIAlertController(title: "Warning", message: "Unable to perform Festival Request!", preferredStyle: .alert)
                let okAction  = UIAlertAction(title: "OK", style: .default, handler: nil)
                let retryAction  = UIAlertAction(title: "Retry", style: .cancel, handler: { (action) in
                    self.fetchFestivals(state: state)
                })
                
                alert.addAction(okAction)
                alert.addAction(retryAction)
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            else  {
                
                let response = JSON(response.result.value!)
                
                if response["response"].intValue == -1 || response["response"].intValue == 0 {
                    
                    let alert = UIAlertController(title: "Warning", message: response["message"].stringValue, preferredStyle: .alert)
                    let okAction  = UIAlertAction(title: "OK", style: .default, handler: nil)
                    let retryAction = UIAlertAction(title: "Retry", style: .cancel, handler: { (action) in
                        self.fetchFestivals(state: state)
                    })
                    
                    alert.addAction(okAction)
                    alert.addAction(retryAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                    
                else if response["response"].intValue == 1 {
                    
                    let festivalData = response["data"].array!
                    
                    self.festivalList.removeAll()
                    self.stateList.removeAll()
                    
                    // getting festival list
                    for i in 0 ..< (festivalData.count) - 1 {
                        let festival = Festival(param: festivalData[i] )
                        self.festivalList.append(festival)
                    }
                    
                    
                    // getting state list
                    let stateArray = festivalData[festivalData.count - 1]["near_by_states"]
                    
                    for i in 0 ..< stateArray.count {
                        let sateName = TState(param: stateArray[i].array![0])
                        self.stateList.append(sateName)
                    }
                    
                    if self.festivalList.count == 1 {
                        DispatchQueue.main.async {
                            self.const_tableHeight.constant = 94 + 4
                        }
                    }
                    else if self.festivalList.count > 1 {
                        DispatchQueue.main.async {
                            self.const_tableHeight.constant = 94 * 2 + 4
                        }
                    }
                    
                    self.tbl_festivals.reloadData()
                    
                    self.tbl_states.reloadData()
                    self.lbl_stateName.text = self.festivalList[0].StateName
                    self.img_stateBanner.image = nil
                    self.showStateImage(url: self.festivalList[0].state_image!)
                    
                }
            }
        }
    }
    
    
    @IBAction func btn_options(_ sender: UIButton) {
        
        if self.tbl_options.isHidden == true {
            self.tbl_options.isHidden = false
        }
        else {
            self.tbl_options.isHidden = true
        }
        
    }
    
    
    func showStateImage( url : String!) {
        
        let imageURL = self.appDelegate.siteBaseURL + url
        
        if let image = self.appDelegate.imageChache.object(forKey: imageURL as NSString) {
            self.img_stateBanner.image = image
            return
        }
        
        
        self.view_activityImage.startAnimating()
        self.img_stateBanner.image = nil
        
        self.img_stateBanner.image = nil
        Alamofire.request(imageURL).responseData { (response) in
            
            self.view_activityImage.stopAnimating()
            if response.error == nil {
                
                if let data = response.data {
                    
                    let image = UIImage(data: data)
                    self.img_stateBanner.image = image
                    
                    if image != nil {
                        self.appDelegate.imageChache.setObject(image!, forKey: url! as NSString)
                    }
                    
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return self.festivalList.count
        }
        else if tableView.tag == 2 {
            return self.stateList.count - 1
        }
        else if tableView.tag == 3 {
            return self.menu.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "festivalCell", for: indexPath) as! FestivalTableViewCell
            cell.setFestivalData(festival: self.festivalList[indexPath.row])
            
            return cell
        }
        else if tableView.tag == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath) as! StateTableViewCell
            cell.setStateData(state: self.stateList[indexPath.row])
            
            return cell
        }
        else if tableView.tag == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath) as! OptionTableViewCell
            
            cell.lbl_option.text = self.menu[indexPath.row]
            
            return cell
        }
        
        
        return UITableViewCell()
        
    }
    
    
    let suggestionView = LoadSuggestion.instanceFromNib() as! SuggestionView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            
            performSegue(withIdentifier: "sw_festivalDetail", sender: indexPath.row)
            
        }
        else if tableView.tag == 2 {
            
            self.fetchFestivals(state: self.stateList[indexPath.row].stateName)
            
        }
        else if tableView.tag == 3 {
            
            self.tbl_options.isHidden = true
            
            let selectedRow = self.tbl_options.indexPathForSelectedRow
            if selectedRow != nil  {
                self.tbl_options.deselectRow(at: selectedRow!, animated: true)
            }
            
            if self.menu[indexPath.row] == "Create Marker" {
                
                performSegue(withIdentifier: "sw_addMarker", sender: indexPath.row)
                
            }
            else if self.menu[indexPath.row] == "Clear Marker" {
                
                // Realm clear all of the markers!
                let markers = realm.objects(Marker.self)
                
                try! self.realm.write {
                    self.realm.delete(markers)
                }
                
                var style = ToastStyle()
                // this is just one of many style options
                style.messageColor = .black
                style.backgroundColor = .white
                
                // present the toast with the new style
                self.view.makeToast("All Markers Are Deleted From Map!", duration: 3.0, position: .bottom, style: style)
                
            }
                
            else if self.menu[indexPath.row] == "My Wish List" {
                performSegue(withIdentifier: "sw_wishList", sender: nil)
            }
                
            else if self.menu[indexPath.row] == "Suggestions" {
                
                self.suggestionView.frame.size.width = self.view.frame.width * 0.8
                self.suggestionView.frame.size.height = self.view.frame.height * 0.5
                self.suggestionView.translatesAutoresizingMaskIntoConstraints = true
                self.suggestionView.delegate = self
                self.suggestionView.backgroundColor = UIColor.white
                self.view.addSubview(self.suggestionView)
                self.suggestionView.txt_email.becomeFirstResponder()
                
                let position = CGPoint(x: self.view.center.x, y: self.view.center.y - 120)
                self.suggestionView.center = position
                
            }
            
            else if self.menu[indexPath.row] == "Upgrade App" {
                self.purchase(productID: self.appDelegate.productSet[0])
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sw_festivalDetail" {
            let dest = segue.destination as! FestivalViewController
            dest.festival = self.festivalList[sender as! Int]
        }
            
        else if segue.identifier == "sw_addMarker" {
            //let dest = segue.destination as! AddMarkerViewController
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let indexPath = IndexPath(item: 0, section: 0)
        let firstFrame = self.tbl_options.rectForRow(at: indexPath)
        
        if firstFrame != nil {
            self.const_optionHeight.constant = firstFrame.size.height * CGFloat(self.menu.count)
        }
        
    }
    
    
    func sendEmail(email : String, suggestion : String) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody(suggestion, isHTML: false)
            present(mail, animated: true)
            
        } else {
            
            let alert = UIAlertController(title: "Warning", message: "Failure to send email.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true)
            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
        let alert = UIAlertController(title: "Success", message: "Successfully send email.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
        
        self.suggestionView.removeFromSuperview()
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.tbl_options.isHidden = true
    }
    
    
}


class LoadSuggestion: UIView {
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Suggestions", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}


class TState {
    
    var stateName : String!
    
    init(param : JSON) {
        self.stateName = param["StateName"].stringValue
    }
    
}



extension MainViewController {
    
    func fetchProducts() {
        
        let productIDs = Set(self.appDelegate.productSet)
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
        
    }
    
    func purchase(productID: String) {
        
        if let product = self.appDelegate.products[productID] {
            print("Here: ", product.productIdentifier)
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
        
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}


extension MainViewController: SKProductsRequestDelegate {
    
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





class Festival {
    
    var FestivalID : Int!
    var festival_code : Int!
    var StateName : String!
    var StartDate : String!
    var EndDate : String!
    var FestivalName : String!
    var FestivalLocation : String!
    var FestivalLat : Double!
    var FestivalLong : Double!
    var FestivalPhone : String!
    var EstimatedVisitors : Double!
    var FestivalWebsite : String!
    var FestivalEmail : String!
    var FestivalActive : String!
    var FestivalSchedule : String!
    var ContactName : String!
    var ContactTitle : String!
    var ContactPhone : String!
    var ContactEmail : String!
    var ContactNotes : String!
    var PolicyID : Int!
    var PolicyName : String!
    var PolicyText : String!
    var PolicyOrder : String!
    var PolicyIcon : String!
    var PolicyActive : String!
    var files_home : String!
    var file_map : String!
    var files_profile : String!
    var files_info : String!
    var state_image : String!
    
    init(param : JSON) {
        
        self.FestivalID = param["FestivalID"].intValue
        self.festival_code = param["festival_code"].intValue
        self.StateName = param["StateName"].stringValue
        self.StartDate = param["StartDate"].stringValue
        self.EndDate = param["EndDate"].stringValue
        self.FestivalName = param["FestivalName"].stringValue
        self.FestivalLocation = param["FestivalLocation"].stringValue
        self.FestivalLat = param["FestivalLat"].doubleValue
        self.FestivalLong = param["FestivalLong"].doubleValue
        self.FestivalPhone = param["FestivalPhone"].stringValue
        self.EstimatedVisitors = param["EstimatedVisitors"].doubleValue
        self.FestivalWebsite = param["FestivalWebsite"].stringValue
        self.FestivalEmail = param["FestivalEmail"].stringValue
        self.FestivalActive = param["FestivalActive"].stringValue
        self.FestivalSchedule = param["FestivalSchedule"].stringValue
        self.ContactName = param["ContactName"].stringValue
        self.ContactTitle = param["ContactTitle"].stringValue
        self.ContactPhone = param["ContactPhone"].stringValue
        self.ContactEmail = param["ContactEmail"].stringValue
        self.ContactNotes = param["ContactNotes"].stringValue
        self.PolicyID = param["PolicyID"].intValue
        self.PolicyName = param["PolicyName"].stringValue
        self.PolicyText = param["PolicyText"].stringValue
        self.PolicyOrder = param["PolicyOrder"].stringValue
        self.PolicyIcon = param["PolicyIcon"].stringValue
        self.PolicyActive = param["PolicyActive"].stringValue
        self.files_home = param["files_home"].stringValue
        self.file_map = param["file_map"].stringValue
        self.files_profile = param["files_profile"].stringValue
        self.files_info = param["files_info"].stringValue
        self.state_image = param["state_image"].stringValue
        
    }
    
    
}
