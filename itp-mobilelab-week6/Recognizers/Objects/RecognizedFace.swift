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
    public var boundingBox: CGRect {
        return observation?.boundingBox ?? CGRect.zero
    }
    
    //MARK: - Methods
    init(observation: VNFaceObservation) {
        self.observation = observation
    }
    
    public func frame(from parentView: UIView) -> CGRect {
        let parentFrame = parentView.frame
        let width = parentFrame.width * boundingBox.width
        let height = parentFrame.height * boundingBox.height
        let x = parentFrame.width - width - parentFrame.width * boundingBox.minX
        let y = parentFrame.height - height - parentFrame.height * boundingBox.minY
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
