//
//  VideoListVM.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/13/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation

class VideoListVM {
    
    var videos: [VideoFileEntity] = []
    private let videosSource: VideoFilesSource
    
    init(videosSource: VideoFilesSource) {
        self.videosSource = videosSource
        configureServices()
    }
    
    private func configureServices() {
        do {
            videos = try videosSource.getAllVideos()
        } catch {
            print("error \(error)")
        }
    }
  
}
