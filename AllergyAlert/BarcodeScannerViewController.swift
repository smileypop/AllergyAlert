//
//  BarcodeReaderViewController.swift
//  AllergyAlert
//
//  Created by Matthew Laird on 12/26/16.
//  Copyright © 2016 Matthew Laird. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var scannedBarcode:String?

    let supportedCodeTypes = [
            AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeEAN13Code]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupCapture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // clear the barcode
        scannedBarcode = nil

        startCapture()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopCapture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupCapture() {

        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Initialize the captureSession object.
            captureSession = AVCaptureSession()

            // Set the input device on the capture session.
            captureSession?.addInput(input)

            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes

            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)

            // Start video capture.
            captureSession?.startRunning()

            // Move the message label and top bar to the front
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topbar)

            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()

            // Show a visual selection of the barcode
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }

        } catch {

            // If any error occurs, simply print it out and don't continue any more.
            print(error)

            // Show an alert
            UIHelper.showErrorAlert(message: "Please allow this app to access your camera and try again.")

            return
        }
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {

        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No barcode is detected"
            return
        }

        // Get the metadata object.
        if let barcodeData = metadataObjects.first {

            // Turn it into machine readable code
            if let readableCode = barcodeData as? AVMetadataMachineReadableCodeObject {

                if supportedCodeTypes.contains(readableCode.type) {
                    // If the found metadata is equal to the barcode metadata then update the status label's text and set the bounds
                    let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: readableCode)
                    qrCodeFrameView?.frame = barCodeObject!.bounds

                    if let barcode = readableCode.stringValue {
                        
                        messageLabel.text = barcode

                        // Prevent a cycle
                        stopCapture()

                        // Use the barcode
                        barcodeDetected(barcode: barcode);
                    }
                }
            }

        }
    }

    func startCapture() {

        // Restart session
        if (captureSession?.isRunning == false) {
            captureSession?.startRunning()
        }
    }

    func stopCapture() {

        // Stop session
        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
        }
    }

    func barcodeDetected(barcode: String) {

        // Vibrate the device to give the user some feedback.
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        // Remove white spaces
        var trimmedBarcode = barcode.trimmingCharacters(in: .whitespacesAndNewlines)

        // Remove first 0 for EAN-13 to UPC-A
        if trimmedBarcode.hasPrefix("0") && trimmedBarcode.characters.count > 12 {
            trimmedBarcode.remove(at: trimmedBarcode.startIndex)
        }

        // Save to controller
        scannedBarcode = trimmedBarcode

        // Close Scanner
        performSegue(withIdentifier: "CloseBarcodeScanner", sender: self)

    }
}
