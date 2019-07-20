//
//  EventsViewController.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 07/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var view_segment: UISegmentedControl!
    @IBOutlet weak var view_activity: UIActivityIndicatorView!
    @IBOutlet weak var lbl_festivalName: UILabel!
    
    @IBOutlet weak var tbl_eventsTime: UITableView!
    @IBOutlet weak var tbl_eventsStage: UITableView!
    @IBOutlet weak var tbl_eventsArtist: UITableView!
    
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var festival : Festival!
    
    var timeEventsKeys = [String]()
    var timeEvents = [String : [Event] ] ()
    
    var stageEventsKeys = [String]()
    var stageEvents = [String : [Event] ] ()
    
    var artistEventsKeys = [String]()
    var artistEvents = [String : [Event] ] ()
    
    
    var activityCount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view_segment.setEnabled(false, forSegmentAt: 0)
        self.view_segment.selectedSegmentIndex = 1
        self.lbl_festivalName.text = self.festival.FestivalName
        
        
        self.activityCount = 3
        self.fetchEvents(festivalID: "\(self.festival!.FestivalID!)", orderBy: "time")
        self.fetchEvents(festivalID: "\(self.festival!.FestivalID!)", orderBy: "theatre")
        self.fetchEvents(festivalID: "\(self.festival!.FestivalID!)", orderBy: "artist")
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.black
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = header.textLabel?.font.withSize(12)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView.tag == 1 { //time
            return self.timeEvents.count
        }
        else if tableView.tag == 2 {
            return self.stageEvents.count
        }
        else if tableView.tag == 3 {
            return self.artistEvents.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView.tag == 1 {
            return self.timeEventsKeys[section]
        }
        else if tableView.tag == 2 {
            return self.stageEventsKeys[section]
        }
        else if tableView.tag == 3 {
            return self.artistEventsKeys[section]
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            let sectionKey = self.timeEventsKeys[section]
            let eventsList = self.timeEvents[sectionKey]!
            return eventsList.count
        }
        else if tableView.tag == 2 {
            let sectionKey = self.stageEventsKeys[section]
            let eventsList = self.stageEvents[sectionKey]!
            return eventsList.count
        }
        else if tableView.tag == 3 {
            let sectionKey = self.artistEventsKeys[section]
            let eventsList = self.artistEvents[sectionKey]!
            return eventsList.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTimeCell") as! EventsTimeTableViewCell
        
        if tableView.tag ==  1 {  // by time
            
            var firstColumn = ""
            let sectionKey = self.timeEventsKeys[indexPath.section]
            let eventsList = self.timeEvents[sectionKey]!
            
            if eventsList[indexPath.row].ShowName.isEmpty  && eventsList[indexPath.row].ArtistsName.isEmpty {
                firstColumn = "Show"
            }
            else if !eventsList[indexPath.row].ShowName.isEmpty {
                firstColumn = eventsList[indexPath.row].ShowName
            }
            else if !eventsList[indexPath.row].ArtistsName.isEmpty {
                firstColumn = eventsList[indexPath.row].ArtistsName
            }
            
            cell.populateData(eventName: firstColumn, eventStage: eventsList[indexPath.row].TheatreName)
            
        }
            
            
        else if tableView.tag == 2 { // by theater
            
            let sectionKey = self.stageEventsKeys[indexPath.section]
            let eventsList = self.stageEvents[sectionKey]!
            
            var firstColumn = ""
            if eventsList[indexPath.row].ShowName.isEmpty  && eventsList[indexPath.row].ArtistsName.isEmpty {
                firstColumn = "Show"
            }
            else if !eventsList[indexPath.row].ShowName.isEmpty {
                firstColumn = eventsList[indexPath.row].ShowName
            }
            else if !eventsList[indexPath.row].ArtistsName.isEmpty {
                firstColumn = eventsList[indexPath.row].ArtistsName
            }
            
            let startTime = eventsList[indexPath.row].StartTime
            
            cell.populateData(eventName: firstColumn, eventStage: startTime!)
            
        }
            
        else if tableView.tag == 3 {  // bay artist
            
            let sectionKey = self.artistEventsKeys[indexPath.section]
            let eventsList = self.artistEvents[sectionKey]!
            
            var firstColumn = ""
            if eventsList[indexPath.row].ShowName.isEmpty  && eventsList[indexPath.row].ArtistsName.isEmpty {
                firstColumn = "Show"
            }
            else if !eventsList[indexPath.row].ShowName.isEmpty {
                firstColumn = eventsList[indexPath.row].ShowName
            }
            else if !eventsList[indexPath.row].TheatreName.isEmpty {
                firstColumn = eventsList[indexPath.row].TheatreName 
            }
            
            let startTime = eventsList[indexPath.row].StartTime
            cell.populateData(eventName: firstColumn, eventStage: startTime!)
            
        }
        
        return cell
    }
    
    
    func fetchEvents(festivalID : String, orderBy: String) {
        
        let requestURL = self.appDelegate.baseURL + "get_events/d8263a0a1045391cbe5923cc1ba5a589e8f843770a6b5088d3bbf066ef5b4a64"
        
        let param = [
            "festival_id" : festivalID,
            "order_by" : orderBy
        ]
        
        self.tbl_eventsTime.isHidden = true
        
        self.view_activity.startAnimating()
        Alamofire.request(requestURL, method : .get, parameters: param).responseJSON { response in
            
            self.activityCount -= 1
            
            if self.activityCount == 0 {
                self.view_activity.stopAnimating()
            }
            
            
            if response.result.value == nil {
                let alert = UIAlertController(title: "Warning", message: "Unable To Perform Festival Request!", preferredStyle: .alert)
                
                let okAction  = UIAlertAction(title: "OK", style: .default, handler: nil)
                let retry = UIAlertAction(title: "Retry", style: .cancel, handler: { (action) in
                    self.fetchEvents(festivalID: festivalID, orderBy: orderBy)
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
                    
                    self.tbl_eventsTime.isHidden = false
                    let eventsData = response["data"].array!
                    
                    
                    if orderBy == "time" {
                        
                        self.timeEventsKeys.removeAll()
                        self.timeEvents.removeAll()
                        
                        // getting festival list
                        for i in 0 ..< eventsData.count {
                            
                            let festival = Event(param: eventsData[i])
                            let startTime = festival.StartTime!
                            
                            // fill by startTime
                            let keys = Array(self.timeEvents.keys)
                            if keys.contains(startTime) {
                                self.timeEvents[startTime]?.append(festival)
                            }
                            else {
                                self.timeEventsKeys.append(startTime)
                                self.timeEvents[startTime] = [Event]()
                                self.timeEvents[startTime]?.append(festival)
                            }
                            
                            
                        }
                        
                        self.tbl_eventsTime.reloadData()
                    }
                        
                    else if orderBy == "theatre" {
                        
                        self.stageEventsKeys.removeAll()
                        self.stageEvents.removeAll()
                        
                        // getting festival list
                        for i in 0 ..< eventsData.count {
                            
                            let festival = Event(param: eventsData[i])
                            let showName = festival.TheatreName!
                            
                            // fill by showName
                            let keysShow = Array(self.stageEvents.keys)
                            if keysShow.contains(showName) {
                                self.stageEvents[showName]?.append(festival)
                            }
                            else {
                                self.stageEventsKeys.append(showName)
                                self.stageEvents[showName] = [Event]()
                                self.stageEvents[showName]?.append(festival)
                            }
                            
                        }
                        
                        self.tbl_eventsStage.reloadData()
                        
                    }
                        
                    else if orderBy == "artist" {
                        
                        self.artistEventsKeys.removeAll()
                        self.artistEvents.removeAll()
                        
                        
                        // getting festival list
                        for i in 0 ..< eventsData.count {
                            
                            let festival = Event(param: eventsData[i])
                            let artistName = festival.ArtistsName!
                            
                            // fill by artistName
                            let keysArtist = Array(self.artistEvents.keys)
                            if keysArtist.contains(artistName) {
                                self.artistEvents[artistName]?.append(festival)
                            }
                            else {
                                self.artistEventsKeys.append(artistName)
                                self.artistEvents[artistName] = [Event]()
                                self.artistEvents[artistName]?.append(festival)
                            }
                            
                        }
                        
                        self.tbl_eventsArtist.reloadData()
                    }

                    
                }
                
                
                
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36.0
    }
    
    @IBAction func segment_valueChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            self.tbl_eventsTime.isHidden = false
            self.tbl_eventsStage.isHidden = true
            self.tbl_eventsArtist.isHidden = true
            
        }
        else if sender.selectedSegmentIndex == 2 {
            self.tbl_eventsTime.isHidden = true
            self.tbl_eventsStage.isHidden = false
            self.tbl_eventsArtist.isHidden = true
            
        }
        else if sender.selectedSegmentIndex == 3 {
            self.tbl_eventsTime.isHidden = true
            self.tbl_eventsStage.isHidden = true
            self.tbl_eventsArtist.isHidden = false
        }
        
    }
    
    
    
    
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}


class Event {
    
    var ShowID : Int!
    var FestivalID : Int!
    var TheatreID : Int!
    var ArtistsID : Int!
    var ShowName : String!
    var ShowDescription : String!
    var StartTime : String!
    var ShowStartDate : String!
    var ShowEndDate : String!
    var DayID : Int!
    var IsLC : Int!
    var ShowActive : Int!
    var TheatreName : String!
    var latitude : Double!
    var longitude : Double!
    var TheatreActive : Int!
    var ArtistsName : String!
    var ArtistsDescription : String!
    var ArtistsWebsite : String!
    var ArtistsActive : Int!
    
    init(param : JSON) {
        
        self.ShowID = param["ShowID"].intValue
        self.FestivalID = param["FestivalID"].intValue
        self.TheatreID = param["TheatreID"].intValue
        self.ArtistsID = param["ArtistsID"].intValue
        self.ShowName = param["ShowName"].stringValue
        self.ShowDescription = param["ShowDescription"].stringValue
        self.StartTime = param["StartTime"].stringValue
        self.ShowStartDate = param["ShowStartDate"].stringValue
        self.ShowEndDate = param["ShowEndDate"].stringValue
        self.DayID = param["DayID"].intValue
        self.IsLC = param["IsLC"].intValue
        self.ShowActive = param["FestivalWebsite"].intValue
        self.latitude = param["latitude"].doubleValue
        self.longitude = param["longitude"].doubleValue
        self.TheatreActive = param["TheatreActive"].intValue
        self.ArtistsName = param["ArtistsName"].stringValue
        self.ArtistsDescription = param["ArtistsDescription"].stringValue
        self.ArtistsWebsite = param["ArtistsWebsite"].stringValue
        self.ArtistsActive = param["ArtistsActive"].intValue
        self.TheatreName = param["TheatreName"].stringValue
    }
    
    
}


class LeftPaddedLabel: UILabel {
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        return self.bounds.insetBy(dx: CGFloat(15.0), dy: CGFloat(15.0))
    }
    
    override func draw(_ rect: CGRect) {
        super.drawText(in: self.bounds.insetBy(dx: CGFloat(5.0), dy: CGFloat(0)))
    }
    
}
