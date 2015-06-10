//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Tu Tong on 6/5/15.
//  Copyright (c) 2015 Tu Tong. All rights reserved.
//

import Foundation
import AVFoundation


class RecordAudio: NSObject {
    
    var title: String!
    var filePathURL: NSURL!
    
    init(filePathURL: NSURL) {
        self.filePathURL = filePathURL
        self.title = filePathURL.lastPathComponent
    }
    
    
    
}