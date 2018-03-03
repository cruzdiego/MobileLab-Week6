//
//  FaceRecognizer.swift
//  itp-mobilelab-week6
//
//  Created by Diego Cruz on 3/3/18.
//  Copyright © 2018 Diego Cruz. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import CoreML

class FaceRecognizer {
    //MARK: - Properties
    public static let shared = FaceRecognizer()
    public var 
    
    private let requestHandler = VNSequenceRequestHandler()
    
    private lazy var request: VNDetectFaceRectanglesRequest = {
        let request = VNDetectFaceRectanglesRequest(completionHandler: {[unowned self] (request, error) in
            self.handleFacesRequest(request)
            } as! VNRequestCompletionHandler)
        request.maximumOvservations = 20
        request.minimumSize = 0.1
        return request
    }()
    
    //MARK: - Methods
    public func recognizeEmotions(from buffer:CMSampleBuffer, completion: @escaping (_:[RecognizedEmotion])->()) {
        guard let pixelBuffer = buffer as? CVPixelBuffer else {
            completion([])
            return
        }
        
        requestHandler.perform([request], on: pixelBuffer)
    }
    
    private func recognizeFaces(from buffer:CMSampleBuffer, completion: @escaping (_ :[RecognizedFace])->()) {
        
    }
    
    //MARK: Handlers
    private func handleFacesRequest(_ request: VNDetectFaceRectanglesRequest) {
        
    }
}
