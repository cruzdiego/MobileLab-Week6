//
//  RecognizedFace.swift
//  itp-mobilelab-week6
//
//  Created by Diego Cruz on 3/3/18.
//  Copyright © 2018 Diego Cruz. All rights reserved.
//

import UIKit
import Vision

class RecognizedFace {
    //MARK: - Properties
    public var observation: VNFaceObservation?
    public var boundingBox: CGRect? {
        return observation?.boundingBox
    }
    //image
    
    //MARK: - Methods
    init(observation: VNFaceObservation) {
        self.observation = observation
    }
}
