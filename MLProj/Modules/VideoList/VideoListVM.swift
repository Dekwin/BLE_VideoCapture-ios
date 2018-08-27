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
        reloadVideos()
    }
    
    private func reloadVideos() {
        do {
            videos = try videosSource.getAllVideos()
        } catch {
            print("error \(error)")
        }
    }
    
    func removeVideo(atIndex index: Int, callback: @escaping (Error?) -> ()) {
        
        videosSource.removeVideo(atUrl: videos[index].url) { [weak self] error in
            self?.reloadVideos()
            callback(error)
        }
        
    }
  
}
