//
//  BLERequestCommand.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/23/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation
enum BLERequestCommand {
    
    case startRecording
    case stopRecording
    case unknown
    case error
    
    init(commandRepresentation: Data) {
        let command = commandRepresentation.first!
        switch command {
        case 0:
            self = .stopRecording
        case 1:
            self = .startRecording
        default:
            self = .unknown
        }
    }
}

class BLERequestAction {
    let command: BLERequestCommand
    let isPerformable: Bool
    let date: Date
    
    init(command: BLERequestCommand, videoCaptureState state: VideoCaptureState, date: Date = Date()) {
        self.command = command
        self.date = date
        switch command {
        case .stopRecording where state == .recording:
            isPerformable = true
        case .startRecording where state == .ready:
            isPerformable = true
        default:
            isPerformable = false
            break
        }
    }
}
