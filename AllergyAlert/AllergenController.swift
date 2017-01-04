//
//  AllergenController.swift
//  AllergyAlert
//
//  Created by Matthew Laird on 12/31/16.
//  Copyright © 2016 Matthew Laird. All rights reserved.
//

import Foundation
import SwiftyJSON

class AllergenController {

    // Check if this product has any allergens
    static func checkFor(allergens: [JSON]) {

        var warningList = [String]()
        var dangerList = [String]()

        // Loop through each allergen
        for allergen in allergens {

            // Get JSON level
            if let level = allergen[Allergen.LEVEL].int {

                // Set Enum level
                if let allergenLevel = Allergen.Level(rawValue: level) {

                    // Get JSON name
                    if let name = allergen[Allergen.NAME].string {

                        // Check the level
                        switch allergenLevel {
                        case .warning:
                            warningList.append(name)
                        case .danger:
                            dangerList.append(name)
                        default:
                            continue
                        }
                    }
                }
            }
            
        }

        // Create a warning message for level 1 allergens
        let warningMessage = AllergenController.createMessage(list: warningList)

        // Create a danger message for level 2 allergens
        if let dangerMessage = AllergenController.createMessage(list: dangerList) {

            // Show DANGER and WARNING if it exists
            UIHelper.showDangerAlert(message: dangerMessage, warningMessage: warningMessage)

        } else if warningMessage != nil {

            // Show WARNING if it exists
            UIHelper.showWarningAlert(message: warningMessage!)

        } else {

            // Show SAFE
            UIHelper.showSafeAlert()
        }

    }

    // Create a message for a specific allergen level (if it exists)
    static func createMessage(list: [String]) -> String? {

        // return if list is empty
        guard list.count > 0 else {

            return nil
        }

        var message = ""

        // add all the allergens to a vertical list
        for item in list {

            message.append(item + "\r")

        }

        return message
    }

}
