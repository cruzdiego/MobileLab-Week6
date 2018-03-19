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
    @IBOutlet weak var cameraView: UIView?
    @IBOutlet weak var overlayView: UIView?
    @IBOutlet weak var overlayLabel: UILabel?
    @IBOutlet weak var overlayViewTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var overlayViewLeftConstraint: NSLayoutConstraint?
    @IBOutlet weak var overlayViewWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var overlayViewHeightConstraint: NSLayoutConstraint?
    
    fileprivate var lastFace: RecognizedFace? {
        didSet {
            didSetLastFace()
        }
    }
    
    fileprivate var lastEmotion: RecognizedEmotion? {
        didSet {
            didSetLastEmotion()
        }
    }
    
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
            cameraView?.layer.addSublayer(cameraLayer)
            captureSession.startRunning()
        }
        
        configureCaptureSession()
    }
    
    //MARK: didSet
    private func didSetLastFace() {
        refreshOverlayView()
    }
    
    private func didSetLastEmotion() {
        refreshOverlayLabel()
    }
    
    //MARK: UI
    private func refreshOverlayView() {
        guard let faceFrame = lastFace?.frame(from: self.view) else {
            overlayView?.isHidden = true
            return
        }
        
        overlayView?.isHidden = false
        overlayViewTopConstraint?.constant = faceFrame.minY
        overlayViewLeftConstraint?.constant = faceFrame.minX
        overlayViewWidthConstraint?.constant = faceFrame.width
        overlayViewHeightConstraint?.constant = faceFrame.height
        overlayLabel?.font = UIFont.systemFont(ofSize: faceFrame.height)
    }
    
    private func refreshOverlayLabel() {
        overlayLabel?.text = lastEmotion?.emoji
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
        DispatchQueue.main.async {
            self.lastFace = face
        }
    }
    
    func mainRecognizerDidRecognize(emotion: RecognizedEmotion?) {
        DispatchQueue.main.async {
            self.lastEmotion = emotion
        }
    }
}
