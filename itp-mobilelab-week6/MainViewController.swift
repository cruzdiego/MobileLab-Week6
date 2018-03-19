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
    @IBOutlet weak var addEmotionButton: UIButton?
    @IBOutlet weak var clearEmotionsButton: UIButton?
    @IBOutlet weak var emotionsLabel: UILabel?
    
    fileprivate var lastEmotion: RecognizedEmotion? {
        didSet {
            didSetLastEmotion()
        }
    }
    fileprivate var emotions = [RecognizedEmotion]() {
        didSet {
            didSetEmotions()
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
    
    @IBAction func addEmotionPressed(sender: UIButton) {
        guard let lastEmotion = lastEmotion else {
            return
        }
        
        emotions.append(lastEmotion)
    }
    
    @IBAction func clearEmotionsPressed(sender: UIButton) {
        emotions.removeAll()
    }
    
    //MARK: Private
    private func configure() {
        func configureCaptureSession() {
            cameraView?.layer.addSublayer(cameraLayer)
            captureSession.startRunning()
        }
        
        func configureAddEmotionButton() {
            let layer = addEmotionButton?.layer
            layer?.shadowOpacity = 0.7
            layer?.shadowRadius = 8.0
            layer?.shadowOffset = CGSize(width: 1, height: 1)
        }
        
        configureCaptureSession()
        configureAddEmotionButton()
    }
    
    //MARK: didSet
    private func didSetLastEmotion() {
        refreshEmotionButton()
    }
    
    private func didSetEmotions() {
        refreshEmotionsLabel()
        refreshClearEmotionsButton()
        lastEmotion = nil
    }
    
    //MARK: UI
    private func refreshEmotionButton() {
        addEmotionButton?.isHidden = lastEmotion == nil
        addEmotionButton?.setTitle(lastEmotion?.emoji, for: .normal)
    }
    
    private func refreshEmotionsLabel() {
        var emotionString = ""
        for (index,emotion) in emotions.enumerated() {
            guard let emoji = emotion.emoji else {
                continue
            }
            
            if index > 0 {
                emotionString += "+"
            }
            emotionString += emoji
        }
        emotionsLabel?.text = emotionString
    }
    
    private func refreshClearEmotionsButton() {
        clearEmotionsButton?.isHidden = emotions.count == 0
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

    }
    
    func mainRecognizerDidRecognize(emotion: RecognizedEmotion?) {
        print(emotion?.name ?? "-")
        lastEmotion = emotion
    }
}
