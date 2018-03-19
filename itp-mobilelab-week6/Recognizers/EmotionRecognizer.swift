//
//  EmotionRecognizer.swift
//  itp-mobilelab-week6
//
//  Created by Diego Cruz on 3/3/18.
//  Copyright © 2018 Diego Cruz. All rights reserved.
//

import Foundation
import Vision
import CoreML

protocol EmotionRecognizerDelegate: class {
    func emotionRecognizerDidRecognize(emotion: RecognizedEmotion?)
}

class EmotionRecognizer {
    //MARK: - Properties
    public weak var delegate: EmotionRecognizerDelegate?
    public lazy var request:VNCoreMLRequest? = {        
        guard let model = EmotionRecognizer.model else {
            return nil
        }
        
        let coreRequest = VNCoreMLRequest(model: model, completionHandler:self.handleRequest)
        coreRequest.imageCropAndScaleOption = .centerCrop
        return coreRequest
    }()
    private static let model:VNCoreMLModel? = {
        return try? VNCoreMLModel(for: CNNEmotions().model)
    }()
    
    //MARK: - Methods
    init(delegate:EmotionRecognizerDelegate?) {
        self.delegate = delegate
    }
    
    private func handleRequest(request: VNRequest,error: Error?) {
        guard   let observations = request.results as? [VNClassificationObservation],
            let bestObservation = observations.max(by: { (observation1, observation2) -> Bool in
                observation1.confidence > observation2.confidence
            }) else {
                    delegate?.emotionRecognizerDidRecognize(emotion: nil)
                return
        }
        
        let emotion = RecognizedEmotion(name: bestObservation.identifier)
        delegate?.emotionRecognizerDidRecognize(emotion: emotion)
    }
}
