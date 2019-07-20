//
//  Classes.swift
//  RENNIE
//
//  Created by Yasir Iqbal on 07/11/2018.
//  Copyright © 2018 Owais Iqbal. All rights reserved.
//

import Foundation
import RealmSwift

class Marker : Object {
    
    @objc dynamic var lat : Double = 0.0
    @objc dynamic var long : Double = 0.0
    @objc dynamic var mainTitle : String = ""
    @objc dynamic var subTitle : String = ""
    
    convenience init(lat: Double, long: Double, mainTitle: String, subTitle : String) {
        self.init()
        
        self.lat = lat
        self.long = long
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        
    }
}

class WishData : Object {
    
    @objc dynamic var festivalName : String = ""
    @objc dynamic var stateName : String = ""
    @objc dynamic var storeName : String = ""
    @objc dynamic var categoryName : String = ""
    @objc dynamic var notes : String = ""
    @objc dynamic var startDate : String = ""
    @objc dynamic var endDate : String = ""
    @objc dynamic var stateImage : String = ""
    @objc dynamic var festivalLogo : String = ""
    @objc dynamic var lat = 0.0
    @objc dynamic var lng = 0.0
    @objc dynamic var wishImage : Data!
    
    convenience init(festivalName: String, stateName: String, storeName: String, categoryName: String, notes : String, lat : Double, lng : Double, wishImage : Data, startDate : String, endDate : String, stateImage : String, festivalLogo : String) {
        self.init()
        
        self.festivalName = festivalName
        self.stateName = stateName
        self.storeName = storeName
        self.categoryName = categoryName
        self.notes = notes
        self.startDate = startDate
        self.endDate = endDate
        self.stateImage = stateImage
        self.festivalLogo = festivalLogo
        self.lat = lat
        self.lng = lng
        self.wishImage = wishImage
        
    }
    
    
}
