//
//  Allergen.swift
//  AllergyAlert
//
//  Created by Matthew Laird on 12/28/16.
//  Copyright © 2016 Matthew Laird. All rights reserved.
//

import Foundation

struct Allergen {

    static let NAME = "allergen_name"
    static let LEVEL = "allergen_value"

    enum Level: Int {
        case safe = 0
        case warning = 1
        case danger = 2
    }
}
