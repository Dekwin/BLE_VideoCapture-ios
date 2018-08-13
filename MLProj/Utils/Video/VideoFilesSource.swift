//
//  FileStoreService.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/13/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation

class VideoFilesSource {
    var filesSourceURL: URL
    
    init(withFilesSourceURL url: URL) {
        filesSourceURL = url
    }
    
    func getAllVideos() -> [VideoFileEntity] {
      
//        do {
//            let directoryContents = try getAllFileURLs()
//            // if you want to filter the directory contents you can do like this:
//            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
//            print("mp3 urls:",mp3Files)
//            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
//            print("mp3 list:", mp3FileNames)
//
//        } catch {
//            print(error.localizedDescription)
//        }
        return []
    }
    

    
}

extension VideoFilesSource: FilesSource {
    
    //var filesExtension: String? { return "" }
    
}


protocol FilesSource: class {
    var filesSourceURL: URL { get }
    var filesExtension: String? { get }
}

extension FilesSource {
    
    var filesExtension: String? {
        return nil
    }
    
    func getAllFileURLs() throws -> [URL] {
        return try FileManager.default.contentsOfDirectory(at: filesSourceURL, includingPropertiesForKeys: nil, options: [])
    }
    
    private func removeFile(at url: URL,  callback: @escaping (_ error: Error?) -> ()) {
        DispatchQueue.global(qos: .default).async {
            do {
                try FileManager.default.removeItem(at: url)
                DispatchQueue.main.async {
                    callback(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    callback(error)
                }
            }
        }
    }
    func buildNewFileUrl(withFileName fileName: String? = nil) -> URL {
        let recordingDate = Date()
        let ext = filesExtension != nil ? ".\(filesExtension!)" : ""
        let newFileName = fileName ?? "\(UUID().uuidString)-\(recordingDate.timeIntervalSince1970))\(ext)"
        let newFileUrl = filesSourceURL.appendingPathComponent(newFileName)
        return newFileUrl
    }
    
    func prepareForWritingToFile(withName name: String? = nil, callback: @escaping (_ error: Error?, _ newFileUrl: URL) -> ()) {
        let newFileUrl = buildNewFileUrl(withFileName: name)
        removeFile(at: newFileUrl) { (error) in
            callback(error, newFileUrl)
        }
    }
}
