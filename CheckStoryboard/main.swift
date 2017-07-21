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

var myDict: [String: Any] = [:]
var myDicAllFiles:[Any] = []
var valSuccess = true

let argument = CommandLine.arguments[1]
var filePaths: [String] = []
let suffixStoryBoard = ".storyboard"
if argument.hasSuffix(suffixStoryBoard) {
    filePaths = [argument]
} else if let s = findFile(rootPath: argument, suffix: suffixStoryBoard) {
    filePaths = s
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
            var myDictFile: [String:Any] = [:]
            myDictFile["name"] = filename[filename.count-1]
            myDictFile["data"] = result2
            
            myDicAllFiles.append(myDictFile)
        }
    }
}

myDict["model"] = myDicAllFiles
if let jsonData = try? JSONSerialization.data( withJSONObject: myDict, options: []) {
    let stringValue = String(data: jsonData, encoding: .ascii)
    print(stringValue!)
}

exit(0)

