//
//  Shell.swift
//  CheckStoryboard
//
//  Created by anass talii on 17/07/2017.
//  Copyright © 2017 anass talii. All rights reserved.
//

import Foundation


func shell(launchPath: String, arguments: [String], input: String? = nil) -> String
{
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    if let input = input, let data = input.data(using: .utf8) {
        let inpipe = Pipe()
        inpipe.fileHandleForWriting.write(data)
        task.standardInput = inpipe
    }
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8)!
    if output.characters.count > 0 {
        let lastIndex = output.index(before: output.endIndex)
        return output[output.startIndex ..< lastIndex]
    }
    return output
}
func bash(command: String, arguments: [String], input: String? = nil) -> String {
    let whichPathForCommand = shell(launchPath: "/bin/bash", arguments: [ "-l", "-c", "which \(command)" ])
    return shell(launchPath: whichPathForCommand, arguments: arguments, input: input)
}
