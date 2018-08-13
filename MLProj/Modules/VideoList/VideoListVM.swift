//
//  VideoListVM.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/13/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation

class VideoListVM {
    
    var videos: [FileEntity] = []
    let videoCaptureService: VideoCaptureService
    
    init(videoCaptureService: VideoCaptureService) {
        self.videoCaptureService = videoCaptureService
        configureServices()
        videoCaptureService.startRecordingToFile { (error, url)  in
            
        }
    }
    
    private func configureServices() {
        do {
            try videoCaptureService.configure(withFilesSource: VideoFilesSource(withFilesSourceURL: FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!))
        } catch {
            
        }
    }
  
    
}
