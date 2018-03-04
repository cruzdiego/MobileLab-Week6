//
//  FaceRecognizer.swift
//  itp-mobilelab-week6
//
//  Created by Diego Cruz on 3/3/18.
//  Copyright © 2018 Diego Cruz. All rights reserved.
//

import Foundation
import Vision

protocol FaceRecognizerDelegate:class {
    func faceRecognizerDidRecognize(face: RecognizedFace?)
}

class FaceRecognizer {
    //MARK: - Properties
    public weak var delegate: FaceRecognizerDelegate?
    public lazy var request: VNDetectFaceRectanglesRequest = {
        let request = VNDetectFaceRectanglesRequest(completionHandler: {[unowned self] (request, error) in
            self.handleFacesRequest(request)
            } as! VNRequestCompletionHandler)
        request.maximumObservations = 1
        request.minimumSize = 0.6
        return request
    }()
    
    //MARK: - Methods
    init(delegate:FaceRecognizerDelegate?) {
        self.delegate = delegate
    }
    
    //MARK: Handlers
    private func handleFacesRequest(_ request: VNDetectFaceRectanglesRequest) {
        guard   let observations = request.results as? [VNFaceObservation],
                let observation = observation.first else {
                delegate?.faceRecognizerDidRecognize(face: nil)
                return
        }
        
        let face = RecognizedFace(observation: observation)
        delegate?.faceRecognizerDidRecognize(face: face)
    }
}
