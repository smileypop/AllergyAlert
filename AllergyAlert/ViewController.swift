//
//  ViewController.swift
//  AllergyAlert
//
//  Created by Matthew Laird on 12/26/16.
//  Copyright © 2016 Matthew Laird. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Setup Data Service
        DataService.createSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {

        // Are we coming from the Barcode Scanner?
        if let barcodeScannerViewController = segue.source as? BarcodeScannerViewController {

            // Did we successfully scane a barcode?
            if let barcode = barcodeScannerViewController.scannedBarcode {

                DataService.searchForProduct(barcode: barcode)
            }
        }

    }

}

