//
//  VideoCaptureService.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/6/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation
import AVFoundation

class VideoCaptureService: NSObject {
    
    private lazy var cameraSession: AVCaptureSession = {
        let cameraSession = AVCaptureSession()
        cameraSession.sessionPreset = AVCaptureSession.Preset.low
        return cameraSession
    }()
    
    private let fileOutput = AVCaptureMovieFileOutput()
    private var deviceInput: AVCaptureDeviceInput!
    private var videoFilesSource: VideoFilesSource!
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: cameraSession)
        return preview
    }()
    
    var state: VideoCaptureState {
        return VideoCaptureState(isRecording: fileOutput.isRecording, sessionIsRunning: cameraSession.isRunning)
    }
    
    override init() {
        super.init()
    }
    
    func startRecordingToFile(withName name: String? = nil, callback: @escaping (_ error: Error?, _ newFileUrl: URL?) -> ()) {

        if !fileOutput.isRecording && !cameraSession.isRunning {
            videoFilesSource.prepareForWritingToFile(withName: name) { (error, newFileUrl)  in
                //if error == nil {
                    self.cameraSession.startRunning()
                    self.fileOutput.startRecording(to: newFileUrl, recordingDelegate: self)
               // }
                callback(error, newFileUrl)
            }
        } else {
            //
            callback(nil, nil)
        }
    }
    
    func stopRecordingAndSave() {
        fileOutput.stopRecording()
        cameraSession.stopRunning()
    }
    
    func configure(withFilesSource source: VideoFilesSource) throws {
        self.videoFilesSource = source
        deviceInput = try AVCaptureDeviceInput(device: AVCaptureDevice.default(for: AVMediaType.video)!)
        
        cameraSession.beginConfiguration()
        
        if (cameraSession.canAddInput(deviceInput)) {
            cameraSession.addInput(deviceInput)
        }
        
        if (cameraSession.canAddOutput(fileOutput)) {
            cameraSession.addOutput(fileOutput)
        }
        
        cameraSession.commitConfiguration()
    }
    
}

extension VideoCaptureService: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("#didFinishRecordingTo \(outputFileURL) error: \(error)")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("#didStartRecordingTo rec \(fileURL)")
    }
    
    
}
