//
//  MainViewController.swift
//  itp-mobilelab-week6
//
//  Created by Diego Cruz on 3/3/18.
//  Copyright © 2018 Diego Cruz. All rights reserved.
//

import UIKit
import AVKit
import Vision

class MainViewController: UIViewController {
    
    //MARK: - Properties
    public lazy var mainRecognizer: MainRecognizer? = MainRecognizer(delegate: self)
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayLabel: UILabel!
    
    private lazy var cameraLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private lazy var captureSession: AVCaptureSession = {
        //Init
        let session = AVCaptureSession()
        session.sessionPreset = .hd1280x720
        //Prepare Input
        guard
            let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
            let input = try? AVCaptureDeviceInput(device: backCamera)
            else { return session }
        session.addInput(input)
        //Prepare Output
        let  dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInteractive))
        session.addOutput(dataOutput)
        return session
    }()
    
    //MARK: - Methods
    //MARK: Public
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraLayer.frame = view.bounds
    }
    
    //MARK: Private
    private func configure() {
        func configureCaptureSession() {
            view.layer.addSublayer(cameraLayer)
            captureSession.startRunning()
        }
        
        configureCaptureSession()
    }
}

//MARK: - Delegate methods
//MARK: AVCaptureVideoDataOutputSampleBufferDelegate
extension MainViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
        mainRecognizer?.recognize(from: sampleBuffer)
    }
}

//MARK: MainRecognizerDelegate
extension MainViewController: MainRecognizerDelegate {
    func mainRecognizerDidRecognize(face: RecognizedFace?) {
        guard let faceFrame = face?.frame(from: self.view) else {
            overlayView.frame = CGRect.zero
            return
        }
        
        overlayView.frame = faceFrame
    }
    
    func mainRecognizerDidRecognize(emotion: RecognizedEmotion?) {
        guard let emotionEmoji = emotion?.emoji else {
            overlayLabel.text = ""
            return
        }
        
        overlayLabel.text = emotionEmoji
    }
}
