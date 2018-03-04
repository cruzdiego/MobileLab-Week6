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
        
        return VNCoreMLRequest(model: model, completionHandler: {[unowned self] (request:VNCoreMLRequest, error:Error) in
            self.handleRequest(request)
            } as? VNRequestCompletionHandler)
    }()
    
    private static let model:VNCoreMLModel? = {
        return try? VNCoreMLModel(for: CNNEmotions().model)
    }()
    
    //MARK: - Methods
    init(delegate:EmotionRecognizerDelegate?) {
        self.delegate = delegate
    }
    
    private func handleRequest(_ request: VNCoreMLRequest) {
        guard   let observations = request.results as? [VNClassificationObservation],
                let bestObservation = observations.first else {
                    delegate?.emotionRecognizerDidRecognize(emotion: nil)
                return
        }
        
        let emotion = RecognizedEmotion(name: bestObservation.identifier)
        delegate?.emotionRecognizerDidRecognize(emotion: emotion)
    }
}
