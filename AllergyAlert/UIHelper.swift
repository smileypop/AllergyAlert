//
//  UIHelper.swift
//  AllergyAlert
//
//  Created by Matthew Laird on 12/30/16.
//  Copyright © 2016 Matthew Laird. All rights reserved.
//

import UIKit
import AudioToolbox

class UIHelper {

    static var shared = UIHelper() // This creates a Singleton

    fileprivate init() {} // This prevents others from using the default '()' initializer for this class.

    static func showSafeAlert() {

        AudioServicesPlaySystemSound(1054)

        _ = SweetAlert().showAlert("SAFE", subTitle: "This product is free from allergens.", style: .success,buttonTitle:"OK", buttonColor: UIColor.colorFromRGB(0x339900))
    }

    static func showWarningAlert(message: String) {

        AudioServicesPlaySystemSound(1052)

        _ = SweetAlert().showAlert("WARNING", subTitle: "This product MAY contain:\r\r" + message, style: .warning,buttonTitle:"OK", buttonColor: UIColor.colorFromRGB(0xFF9900))
    }

    static func showDangerAlert(message: String, warningMessage: String? = nil) {

        AudioServicesPlaySystemSound(1005)

        _ = SweetAlert().showAlert("DANGER", subTitle: "This product contains:\r\r" + message, style: .error,buttonTitle:"OK", buttonColor: UIColor.colorFromRGB(0xCC3333)) { (isOtherButton) in

            if let nextMessage = warningMessage {
                UIHelper.showWarningAlert(message: nextMessage)
            }

        }
    }

    static func showErrorAlert(message: String) {

        AudioServicesPlaySystemSound(1073)

        _ = SweetAlert().showAlert("OOPS", subTitle: message + "\r", style: .customImag(imageFile:"Info"),buttonTitle:"OK", buttonColor: UIColor.colorFromRGB(0x6633CC))
    }

}
