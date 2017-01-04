//
//  Network.swift
//  AllergyAlert
//
//  Created by Matthew Laird on 12/26/16.
//  Copyright © 2016 Matthew Laird. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataService {

    static let API_URL = "http://api.foodessentials.com/"
    static let API_KEY = "ywfvehhwn43dk2u2vf222epg"
    static let APP_ID = "demo"

    static var SESSION_ID: String?

    static var shared = DataService() // This creates a Singleton

    fileprivate init() {} // This prevents others from using the default '()' initializer for this class.

    static func createSession() {

        // The URL we will use to get a session ID from Food Essentials API
        let url = "\(DataService.API_URL)createsession?uid=\(DataService.APP_ID)&devid=\(DataService.APP_ID)&appid=\(DataService.APP_ID)&f=json&v=2.00&api_key=\(DataService.API_KEY)"

        print("Create session for url : \(url)")

        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:

                if let resultValue = response.result.value {

                    var json = JSON(resultValue)

                    if let session_id = json["session_id"].string {

                        DataService.SESSION_ID = session_id

                        print("Got session id: \(session_id)")

                    } else {

                        UIHelper.showErrorAlert(message: "There was a problem.\r\rPlease check your internet connection.")
                    }

                } else {
                    UIHelper.showErrorAlert(message: "There was a problem.\r\rPlease check your internet connection.")
                }

            case .failure(let error):
                print(error)
                UIHelper.showErrorAlert(message: "There was a problem.\r\rPlease check your internet connection.")
            }
        }
    }

    static func searchForProduct(barcode: String) {

        // Prevent crash from nil session value
        let session_id = DataService.SESSION_ID ?? ""

        // The URL we will use to get product data from Food Essentials API
                let url = "\(DataService.API_URL)label?u=\(barcode)&sid=\(session_id)&appid=\(DataService.APP_ID)&f=json&api_key=\(DataService.API_KEY)"

        print("Search for product with url \(url)")

        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:

                if let resultValue = response.result.value {

                    var json = JSON(resultValue)

                    if let allergens = json["allergens"].array {

                        AllergenController.checkFor(allergens: allergens)

                    } else {

                        UIHelper.showErrorAlert(message: "This product has no information.")
                    }

                } else {
                    UIHelper.showErrorAlert(message: "There was a problem.\r\rPlease try again.")
                }

            case .failure(let error):
                print(error)
                UIHelper.showErrorAlert(message: "There was a problem.\r\rPlease try again.")
            }
        }

    }
}
