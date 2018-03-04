//
//  MainRecognizer.swift
//  itp-mobilelab-week6
//
//  Created by Diego Cruz on 3/3/18.
//  Copyright © 2018 Diego Cruz. All rights reserved.
//

import Foundation
import AVFoundation
import Vision

protocol MainRecognizerDelegate: class {
    func mainRecognizerDidRecognize(face : RecognizedFace?)
    func mainRecognizerDidRecognize(emotion: RecognizedEmotion?)
}

class MainRecognizer {
    //MARK: - Properties
    public weak var delegate: MainRecognizerDelegate?
    
    private let requestHandler = VNSequenceRequestHandler()
    private lazy var faceRecognizer: FaceRecognizer = {
       return FaceRecognizer(delegate: self)
    }()
    private lazy var emotionRecognizer: EmotionRecognizer = {
       return EmotionRecognizer(delegate: self)
    }()
    private lazy var requests:[VNRequest] = {
        if let emotionRequest = emotionRecognizer.request {
            return [faceRecognizer.request,emotionRequest]
        } else {
            return [faceRecognizer.request]
        }
    }()
    
    //MARK: - Methods
    init(delegate:MainRecognizerDelegate) {
        self.delegate = delegate
    }
    
    public func recognize(from buffer:CMSampleBuffer) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else {
                return
            }
            
            try? self.requestHandler.perform(self.requests, on: pixelBuffer)
        }
    }
}

//MARK: - Delegates
extension MainRecognizer: FaceRecognizerDelegate {
    func faceRecognizerDidRecognize(face: RecognizedFace?) {
        DispatchQueue.main.async {
            self.delegate?.mainRecognizerDidRecognize(face: face)
        }
    }
}

extension MainRecognizer: EmotionRecognizerDelegate {
    func emotionRecognizerDidRecognize(emotion: RecognizedEmotion?) {
        DispatchQueue.main.async {
            self.delegate?.mainRecognizerDidRecognize(emotion: emotion)
        }
    }
}
