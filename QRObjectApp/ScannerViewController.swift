//
//  ScannerViewController.swift
//  QRObjectApp
//
//  Created by Jonas Lundvall on 2019-02-11.
//  Copyright © 2019 Jonas Lundvall. All rights reserved.
//

import UIKit
import AVFoundation

let myNotificationKey = "se.arcare.myNotificationKey"
let ioManager = IOManager()
let arItemsModel = ARItemsModel()

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    
    var alertNoDataFetched = UIAlertController()
    
    var isCoordinatesSet = false
    var setRectX: CGFloat = 0
    var setRectY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAlerts()
        
        // Set listener to notification key
        NotificationCenter.default.addObserver(self, selector:
            #selector(ScannerViewController.NotificationSent), name:
            NSNotification.Name(rawValue: myNotificationKey), object: nil)
        
        // Do any additional setup after loading the view.
        captureDevice = AVCaptureDevice.default(for: .video)
        // Check if captureDevice returns a value and unwrap it
        /*if let captureDevice = captureDevice {
            
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.qr] //AVMetadataObject.ObjectType
                
                captureSession.startRunning()
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                
                let scanRect = CGRect(x: 0, y: 0, width: 100, height: 100)
                let rectOfInterest = videoPreviewLayer!.metadataOutputRectConverted(fromLayerRect: scanRect)
                captureMetadataOutput.rectOfInterest = rectOfInterest
                
                view.layer.addSublayer(videoPreviewLayer!)
            } catch {
                print("Error Device Input")
            }
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            captureSession = AVCaptureSession()
            guard let captureSession = captureSession else { return }
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            captureMetadataOutput.metadataObjectTypes = [.qr] //AVMetadataObject.ObjectType
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            
            let navbarHeight = self.navigationController!.navigationBar.frame.height
            print("navbarHeight: " + navbarHeight.description)
            let rectSize: CGFloat = 200
            
            // Quick-fix thanks to videoPreviewLayer?.frame.size.height being smaller when popped
            // from view stack, no idea why.
            if !isCoordinatesSet {
                setRectX = ((videoPreviewLayer?.frame.size.width)! - rectSize) / 2
                setRectY = ((videoPreviewLayer?.frame.size.height)! - rectSize) / 2 - navbarHeight
                isCoordinatesSet = true
            }
            
            let scanRect = CGRect(x: setRectX, y: setRectY, width: rectSize, height: rectSize)
            
            captureSession.startRunning()
            let rectOfInterest = videoPreviewLayer!.metadataOutputRectConverted(fromLayerRect: scanRect)
            captureMetadataOutput.rectOfInterest = rectOfInterest
            
            view.layer.addSublayer(videoPreviewLayer!)
            
            let codeFrame = UIView()
            codeFrame.layer.borderColor = UIColor.init(white: 1.0, alpha: 0.4).cgColor
            codeFrame.layer.borderWidth = 15
            codeFrame.frame = CGRect.zero
            codeFrame.translatesAutoresizingMaskIntoConstraints = false
            
            codeFrame.frame = scanRect
            
            view.addSubview(codeFrame)
        } catch {
            print("Error Device Input")
        }
    }
    
    /*override func viewWillDisappear(_ animated: Bool) {
        captureSession?.stopRunning()
        videoPreviewLayer = nil
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.green.cgColor
        codeFrame.layer.borderWidth = 2
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()
    
    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            //print("No Input Detected")
            codeFrame.frame = CGRect.zero
            codeLabel.text = "No Data"
            return
        }
        
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        guard let stringCodeValue = metadataObject.stringValue else { return }
        
        view.addSubview(codeFrame)
        
        guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else { return }
        codeFrame.frame = barcodeObject.bounds
        codeLabel.text = stringCodeValue
        
        // Stop capturing and hence stop executing metadataOutput function over and over again
        captureSession?.stopRunning()
        
        // Call the function which performs navigation and pass the code string value we just detected
        displayViewController(scannedCode: stringCodeValue)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func NotificationSent(){
        
        let data = ioManager.getFetchedARItems()
        //print(ioManager.ableToFetchData())
        if ioManager.ableToFetchData() {
            arItemsModel.updateARItemsData(arItems: data)
            ioManager.storeData(arItems: data)
            
            ioManager.setBoolToFetchData(value: false)
            // Run UI Update on main thread
            DispatchQueue.main.async {
                //self.table.reloadData()
                // Make segue to AR
                //print(data.debugDescription)
                //self.performSegue(withIdentifier: "segueToARSCNView", sender: nil)
                self.performSegue(withIdentifier: "segueToTableView2", sender: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.present(self.alertNoDataFetched, animated: true)
            }
        }
    }
    
    func displayViewController(scannedCode: String) {
        /*let viewController = ViewController()
        viewController.scannedCode = scannedCode
        //navigationController?.pushViewController(detailsViewController, animated: true)
        
        present(viewController, animated: true, completion: nil)*/
        
        //ioManager.fetchData(idURL: scannedCode)   <-- Use this later!
        ioManager.fetchData(idURL: "items")
        
        //performSegue(withIdentifier: "segueToARSCNView", sender: nil)
    }
    
    func initAlerts() {
        // Init no data fetched alert
        alertNoDataFetched = UIAlertController(title: "Input error", message: "No items could be fetched. Are you sure you scanned the right QR code?", preferredStyle: .alert)
        alertNoDataFetched.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
}
