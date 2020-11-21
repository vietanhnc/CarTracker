//
//  ScanDeviceVC.swift
//  CarTracker
//
//  Created by VietAnh on 11/18/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa
import RealmSwift
class ScanDeviceVC: BaseViewController ,AVCaptureMetadataOutputObjectsDelegate{
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrcode = PublishSubject<String>() //BehaviorRelay<String?>(value:nil)
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        #if targetEnvironment(simulator)
        let value = "{\"brand\":\"SPRD\",\"deviceId\":\"8c9f1ec58f78c95f\",\"host\":\"bsp-04\",\"imei\":\"862523112642812\",\"model\":\"sp9853i_1h10_vmm\",\"sdk\":\"27\",\"versionCode\":\"2\"}"
        self.qrcode.onNext(value)
        #else
        initCamera()
        #endif
    }
    
    func goNext(_ qr:String?){
        guard let qrString = qr else{ return }
//        print(qrString)
//        save to sysParam
        let param = SystemParameter()
        param.type = "QRSCAN"
        param.code = "CODE"
        param.name = qrString
        do{
            let realm = try Realm()
            if let existed = realm.objects(SystemParameter.self).filter("type == 'QRSCAN'").first {
                try! realm.write { realm.delete(existed) }
            }
            try realm.write { realm.add(param) }
        } catch{
        }
        // go select Brand
        self.navigationController?.pushViewController(SelectBrandVC(), animated: true)
    }
    
    func initObserver(){
        qrcode.asObservable().subscribe { event in
            guard let value = event.element else{ return }
            print(event)
            self.goNext(value)
        }.disposed(by: disposeBag)
    }
    
    
    func initCamera(){
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        self.qrcode.onNext(code)
        print("read:\(code)")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//    var captureSession = AVCaptureSession()
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
//    var qrCodeFrameView: UIView?


//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //Camera
//        AVCaptureDevice.requestAccess(for: AVMediaType.metadata) { response in
//            if response {
//                //access granted
//            } else {
//
//            }
//        }
//        // Do any additional setup after loading the view.
//        // Get the back-facing camera for capturing videos
//        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDuoCamera], mediaType: AVMediaType.video, position: .back)
//
//        guard let captureDevice = deviceDiscoverySession.devices.first else {
//            print("Failed to get the camera device")
//            return
//        }
//
//        do {
//            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
//            let input = try AVCaptureDeviceInput(device: captureDevice)
//
//            // Set the input device on the capture session.
//            captureSession.addInput(input)
//
//        } catch {
//            // If any error occurs, simply print it out and don't continue any more.
//            print(error)
//            return
//        }
//
//        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
//        let captureMetadataOutput = AVCaptureMetadataOutput()
//        captureSession.addOutput(captureMetadataOutput)
//        // Set delegate and use the default dispatch queue to execute the call back
//        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        videoPreviewLayer?.frame = view.layer.bounds
//        view.layer.addSublayer(videoPreviewLayer!)
//        // Start video capture.
//        captureSession.startRunning()
//
//        if let qrCodeFrameView = qrCodeFrameView {
//            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
//            qrCodeFrameView.layer.borderWidth = 2
//            view.addSubview(qrCodeFrameView)
//            view.bringSubviewToFront(qrCodeFrameView)
//        }
//
//    }

//extension ScanDeviceVC: AVCaptureMetadataOutputObjectsDelegate {
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        // Check if the metadataObjects array is not nil and it contains at least one object.
//        if metadataObjects.count == 0 {
//            qrCodeFrameView?.frame = CGRect.zero
//            //            messageLabel.text = "No QR code is detected"
//            return
//        }
//
//        // Get the metadata object.
//        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//
//        if metadataObj.type == AVMetadataObject.ObjectType.qr {
//            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
//            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
//            qrCodeFrameView?.frame = barCodeObject!.bounds
//
//            if metadataObj.stringValue != nil {
//                //                messageLabel.text = metadataObj.stringValue
//                print(metadataObj.stringValue)
//            }
//        }
//    }
//}
