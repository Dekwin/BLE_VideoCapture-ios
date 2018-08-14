//
//  Data+Converters.swift
//  MLProj
//
//  Created by ikasianenko_new on 8/14/18.
//  Copyright © 2018 ikasianenko_new. All rights reserved.
//

import Foundation

func sizeof <T> (_ : T.Type) -> Int
{
    return (MemoryLayout<T>.size)
}

func sizeof <T> (_ : T) -> Int
{
    return (MemoryLayout<T>.size)
}

func sizeof <T> (_ value : [T]) -> Int
{
    return (MemoryLayout<T>.size * value.count)
}


extension NSData {
    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            self.getBytes(&number, length: sizeof(UInt8.self))
            return number
        }
    }
}

extension NSData {
    var uint16: UInt16 {
        get {
            var number: UInt16 = 0
            self.getBytes(&number, length: sizeof(UInt16.self))
            return number
        }
    }
}

extension NSData {
    var uint32: UInt32 {
        get {
            var number: UInt32 = 0
            self.getBytes(&number, length: sizeof(UInt32.self))
            return number
        }
    }
    
    var sint32: Int32 {
        get {
            var number: Int32 = 0
            self.getBytes(&number, length: sizeof(Int32.self))
            return number
        }
    }
    
    var sint64: Int64 {
        get {
            var number: Int64 = 0
            self.getBytes(&number, length: sizeof(Int64.self))
            return number
        }
    }
}

extension NSData {
    var uuid: NSUUID? {
        get {
            var bytes = [UInt8](repeating: 0, count: self.length)
            self.getBytes(&bytes, length: self.length * sizeof(UInt8.self))
            return NSUUID(uuidBytes: bytes)
        }
    }
}

extension NSData {
    var stringASCII: String? {
        get {
            return NSString(data: self as Data, encoding: String.Encoding.ascii.rawValue) as String?
        }
    }
}

extension NSData {
    var stringUTF8: String? {
        get {
            return NSString(data: self as Data, encoding: String.Encoding.utf8.rawValue) as String?
        }
    }
}

extension Int {
    var data: NSData {
        var int = self
        return NSData(bytes: &int, length: sizeof(Int.self))
    }
}

extension UInt8 {
    var data: NSData {
        var int = self
        return NSData(bytes: &int, length: sizeof(UInt8.self))
    }
}

extension UInt16 {
    var data: NSData {
        var int = self
        return NSData(bytes: &int, length: sizeof(UInt16.self))
    }
}

extension UInt32 {
    var data: NSData {
        var int = self
        return NSData(bytes: &int, length: sizeof(UInt32.self))
    }
}


