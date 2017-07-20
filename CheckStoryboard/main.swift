//
//  main.swift
//  CheckStoryboard
//
//  Created by anass talii on 17/07/2017.
//  Copyright © 2017 anass talii. All rights reserved.
//

import Foundation


if CommandLine.arguments.count == 1 {
    print("Invalid usage. Missing path to Storyboard files")
    exit(1)
}

var myDict: NSMutableDictionary = [:]
var item = 0

for var cmd in (1..<CommandLine.arguments.count) {
    let argument = CommandLine.arguments[cmd]
    var filePaths: [String] = []
    let suffixStoryBoard = ".storyboard"
    if argument.hasSuffix(suffixStoryBoard) {
        filePaths = [argument]
    } else {
        print("Invalid path to .storyboard files")
    }
    
    for filePath in filePaths {
        let result = bash(command: "ibtool ", arguments: ["--warnings", "--errors", "--notices", filePath])
        if (result.characters.count > 0){
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                var path = dir.appendingPathComponent("file.plist")
                do {
                    try result.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                }
                catch { print("error : \(error)") }
                let result2 = bash(command: "plutil ", arguments: ["-convert", "json",  "-o", "-", path.relativePath])
                path = dir.appendingPathComponent("file.json")
                do {
                    try result2.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                }
                catch { print("error : \(error)") }
                
                let filename = filePath.components(separatedBy: "/")
                myDict.setValue(result2, forKey: filename[filename.count-1])
                item += item
            }
        }
    }
}

if (myDict.count > 0) {
    if let jsonData = try? JSONSerialization.data( withJSONObject: myDict, options: []) {
        let stringValue = String(data: jsonData, encoding: .ascii)
        print(stringValue!)
    }
}

exit(0)

