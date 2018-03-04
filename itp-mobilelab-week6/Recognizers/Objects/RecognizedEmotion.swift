//
//  RecognizedEmotion.swift
//  itp-mobilelab-week6
//
//  Created by Diego Cruz on 3/3/18.
//  Copyright © 2018 Diego Cruz. All rights reserved.
//

import UIKit

class RecognizedEmotion {
    //MARK: - Properties
    public var name: String
    public var emoji: String? {
        return Emotion(rawValue: name)?.emoji
    }
    
    private enum Emotion :String {
        case anger = "Anger"
        case disgust = "Disgust"
        case fear = "Fear"
        case happy = "Happy"
        case neutral = "Neutral"
        case sad = "Sad"
        case surprise = "Surprise"
        
        var emoji: String {
            switch self {
            case .anger:
                return "😡"
            case .disgust:
                return "🤢"
            case .fear:
                return "😱"
            case .happy:
                return "🙂"
            case .neutral:
                return "😐"
            case .sad:
                return "🙁"
            case .surprise:
                return "😮"
            }
        }
    }
    
    //MARK: - Methods
    init(name:String) {
        self.name = name
    }
}
