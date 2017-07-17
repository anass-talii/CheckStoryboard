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

let argument = CommandLine.arguments[1]
var filePaths: [String] = []
let suffixStoryBoard = ".storyboard"
if argument.hasSuffix(suffixStoryBoard) {
    filePaths = [argument]
} else {
    print("Invalid path to .storyboard files")
}

let result = bash(command: "ibtool ", arguments: ["--warnings", "--errors", "--notices", filePaths[0]])
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
        print(result2)
        
        
        
        //reading
        do {
            let text2 = try String(contentsOf: path, encoding: String.Encoding.utf8)
            print(text2)
            if let data = text2.data(using: String.Encoding.utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                } catch {
                    print("error : \(error)")
                }
            }
        }
        catch {
            print("error : \(error)")}
        
    }
}
exit(0)

