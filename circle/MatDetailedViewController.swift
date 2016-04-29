//
//  MatDetailedView.swift
//  circle
//
//  Created by Animish Gadve on 3/2/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import UIKit
import AVFoundation
import CoreGraphics

class MatDetailedViewController:UIViewController, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let captureSession = AVCaptureSession()
    let captureOutput = AVCaptureStillImageOutput()
    var captureDevice = AVCaptureDevice?()
    
    var detailedInformationArray = Array<UICollectionViewCell>()
    let clarifaiCommunicator = ClarifaiCommunicator()
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    init() {
        super.init(nibName: "MatDetailedViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView?.registerNib(UINib(nibName: "MatDetailedViewImageCell", bundle: nil), forCellWithReuseIdentifier: "imageDisplayCell")
        captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if(captureDevice != nil) {
            beginSession()
        }
    }
    
    //MARK:- Camera Setup
    
    func beginSession() {
        
        do {
        try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        } catch {
            NSLog("Error with camera session")
        }
        
        captureOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        captureSession.addOutput(captureOutput)
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
//        cameraView = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height/2))
//        self.view.addSubview(cameraView)
        
        cameraButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MatDetailedViewController.onCameraButtonPressed)))
        
        
        cameraLayer.frame = cameraView.frame
        cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraView.layer.addSublayer(cameraLayer)
        captureSession.startRunning()
    }
    
    func onCameraButtonPressed(sender:AnyObject) {
//        if(sender.isKindOfClass(UIView)) {
            let connection = captureOutput.connectionWithMediaType(AVMediaTypeVideo)
            captureOutput.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (sampleBuffer, error) in
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.getClarifaiData(image)
//                    let detailedImageView = MatDetailedViewImageCell()
//                    detailedImageView.imageView.image = image
//                    self.detailedInformationArray[0] = detailedImageView as UICollectionViewCell
//                    self.collectionView.reloadData()
                })
//        }
    }
    

    func getClarifaiData(image:UIImage) {
        clarifaiCommunicator.getImageData(image) { (responseData) in
        do {
             let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(responseData, options:.MutableContainers)
             for (itemType, itemName) in anyObj as! NSMutableDictionary {
                 print(itemType, itemName)
             }
        } catch {
             NSLog("Serialization to String failed on reading")
        }
        }
    }
    
    //MARK:- Image selected
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
    }
    
    //MARK:- Collection View
    
    //MARK:- Collection View
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return detailedInformationArray.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numItems = detailedInformationArray.count
        return numItems
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("matDescriptorCell", forIndexPath: indexPath) as! MatItemViewCell
    return cell
    }
    
    
}