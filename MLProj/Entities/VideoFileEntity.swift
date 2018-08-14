//
//  VideoFileEntity.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/13/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation

class VideoFileEntity: FileEntity {
    var length: Double
    
    init(title: String, size: Double, length: Double, fileExtension: String? = nil) {
        self.length = length
        super.init(title: title, size: size, fileExtension: fileExtension)
    }
}
