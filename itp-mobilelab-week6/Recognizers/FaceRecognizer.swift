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
    public lazy var request: VNDetectFaceRectanglesRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFacesRequest)
    
    //MARK: - Methods
    init(delegate:FaceRecognizerDelegate?) {
        self.delegate = delegate
    }
    
    //MARK: Handlers
    private func handleFacesRequest(request: VNRequest,error: Error?) {
        guard   let observations = request.results as? [VNFaceObservation],
                let observation = observations.first else {
                print("Detecting \(request.results?.count ?? 0) faces")
                delegate?.faceRecognizerDidRecognize(face: nil)
                return
        }
        
        print("Face detected at: \(observation.boundingBox.minX),\(observation.boundingBox.minY)")
        let face = RecognizedFace(observation: observation)
        delegate?.faceRecognizerDidRecognize(face: face)
    }
}
