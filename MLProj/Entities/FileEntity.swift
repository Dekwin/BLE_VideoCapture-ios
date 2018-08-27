//
//  VideoEntity.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/13/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation

class FileEntity {
    
    var title: String
    var size: Double
    var fileExtension: String?
    var url: URL
    
    init(title: String, size: Double, fileExtension: String? = nil, url: URL) {
        self.title = title
        self.size = size
        self.fileExtension = fileExtension
        self.url = url
    }
}

