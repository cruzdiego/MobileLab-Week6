//
//  EmotionRecognizer.swift
//  itp-mobilelab-week6
//
//  Created by Diego Cruz on 3/3/18.
//  Copyright © 2018 Diego Cruz. All rights reserved.
//

import UIKit
import Vision
import CoreML

class EmotionRecognizer {
    
    public var recognizedFace: RecognizedFace?
    public var completionClosure: ((_ : RecognizedEmotion?) -> ())?
    
    private static let model:VNCoreMLModel? = {
        return try? VNCoreMLModel(for: CNNEmotions().model)
    }()
    
    private lazy var request:VNCoreMLRequest? = {
        guard let model = EmotionRecognizer.model else {
            return nil
        }
        
        return VNCoreMLRequest(model: model, completionHandler: {[unowned self] (request:VNCoreMLRequest, error:Error) in
            self.handleRequest(request)
        } as? VNRequestCompletionHandler)
    }()
    
    //MARK: - Methods
    public func recognize(from image:CIImage,completion:@escaping (_ : RecognizedEmotion?)->()) {
        guard let request = request else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(ciImage: image)
        try? requestHandler.perform([request])
    }
    
    private func handleRequest(_ request: VNCoreMLRequest) {
        guard   let observations = request.results as? [VNClassificationObservation],
                let bestObservation = observations.first else {
                return
        }
        
        let emotion = RecognizedEmotion(name: bestObservation.identifier)
        completionClosure?(emotion)
    }
}
