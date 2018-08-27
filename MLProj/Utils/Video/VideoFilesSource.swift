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
    
    func getAllVideos() throws -> [VideoFileEntity] {
        let files = try getAllFileURLs()
            .filter { $0.pathExtension == filesExtension }
            .map { VideoFileEntity(title: $0.deletingPathExtension().lastPathComponent,
                                   size: 0, length: 0,
                                   fileExtension: $0.pathExtension, url: $0) }
        return files
    }
    
    func removeVideo(atUrl url: URL, callback: @escaping (Error?) -> ()) {
        removeFile(at: url, callback: callback)
    }
    
}

extension VideoFilesSource: FilesSource {
    
    var filesExtension: String? { return "mov" }
    
}


protocol FilesSource: class {
    var filesSourceURL: URL { get }
    var filesExtension: String? { get }
    var fileManager: FileManager { get }
}

extension FilesSource {
    
    var fileManager: FileManager { return FileManager.default }
    
    var filesExtension: String? {
        return nil
    }
    
    func getAllFileURLs() throws -> [URL] {
        return try fileManager.contentsOfDirectory(at: filesSourceURL, includingPropertiesForKeys: nil, options: [])
    }
    
    fileprivate func removeFile(at url: URL,  callback: @escaping (_ error: Error?) -> ()) {
        DispatchQueue.global(qos: .default).async {
            do {
                try self.fileManager.removeItem(at: url)
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
    
    private func createDirectoryIfNeeded(atPath path: String) throws {
        var isDir : ObjCBool = false
        if !fileManager.fileExists(atPath: path, isDirectory: &isDir) {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    private func buildNewFileUrl(withFileName fileName: String? = nil) -> URL {
        let recordingDate = Date()
        let ext = filesExtension != nil ? ".\(filesExtension!)" : ""
        let newFileName = fileName ?? "\(UUID().uuidString)-\(recordingDate.timeIntervalSince1970)\(ext)"
        let newFileUrl = filesSourceURL.appendingPathComponent(newFileName)
        return newFileUrl
    }
    
    func prepareForWritingToFile(withName name: String? = nil, callback: @escaping (_ error: Error?, _ newFileUrl: URL) -> ()) {
        let newFileUrl = buildNewFileUrl(withFileName: name)
        do {
            try createDirectoryIfNeeded(atPath: filesSourceURL.path)
            removeFile(at: newFileUrl) { (error) in
                callback(error, newFileUrl)
            }
        } catch {
            callback(error, newFileUrl)
        }
    }
}
