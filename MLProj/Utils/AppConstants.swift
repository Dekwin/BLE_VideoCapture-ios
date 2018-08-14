//
//  AppConstants.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/13/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation
struct AppConstants {
    enum Video: String {
        case folderName = "videos"
        
        static var folderUrl: URL? {
           return FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appendingPathComponent(AppConstants.Video.folderName.rawValue)
        }
    }
    
}
