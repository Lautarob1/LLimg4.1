//
//  main.swift
//  cmdToolTest
//
//  Created by EFI-Admin on 12/19/23.
//

import Foundation

func createSparseImage(at path: String, imageName: String, fileSys: String, maxSize: String) {
    let command = "hdiutil create -size \(maxSize) -fs \(fileSys) -volname \(imageName) -type SPARSE \(path)/\(imageName).sparseimage"
    let output = executeShellCommand(command)
    print(output)
}

func executeASRCommand() -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/sbin/asr")
    // Include necessary arguments for the asr command
    process.arguments =   ["restore", "-source", "/", "-target", "/Volumes/MySparseImage", "-noprompt", "-noverify", "-erase"]
    let outputPipe = Pipe()
    let errorPipe = Pipe()
    process.standardOutput = outputPipe
    process.standardError = errorPipe

    do {
        try process.run()
    } catch {
        print("Error: \(error.localizedDescription)")
    }
    process.waitUntilExit()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: outputData, encoding: .utf8) ?? ""

    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
    let errorOutput = String(data: errorData, encoding: .utf8) ?? ""

    print("Output: \(output)")
    print("Error: \(errorOutput)")

    return output
   
}



func executeShellCommand(_ command: String) -> String {
    let process = Process()
    let pipe = Pipe()

    process.standardOutput = pipe
    process.standardError = pipe
    process.arguments = ["-c", command]
    process.launchPath = "/bin/zsh"
    process.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8) ?? ""
}

func executeSudoCommand(command: String, passw: String) -> String {
    let fullCommand = "echo \(passw) | sudo -S \(command)"
    let process = Process()
    let pipe = Pipe()
    process.environment = ProcessInfo.processInfo.environment
    process.executableURL = URL(fileURLWithPath: "/bin/zsh")
    process.arguments = ["-c", fullCommand]
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        return "Error: \(error.localizedDescription)"
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8) ?? "Error decoding output"
}


func listStorageDevices() {
    let output = executeShellCommand("diskutil list")
    print(output)
}

func listFiles(in directoryPath: String) {
    let fileManager = FileManager.default

    do {
        // Get the directory contents including subdirectories (if needed)
        let fileURLs = try fileManager.contentsOfDirectory(at: URL(fileURLWithPath: directoryPath), includingPropertiesForKeys: nil)

        // Loop through the file URLs and print file names
        for fileURL in fileURLs {
            print(fileURL.lastPathComponent)
        }
    } catch {
        print("Error while enumerating files \(directoryPath): \(error.localizedDescription)")
    }
}

//listFiles(in: "/Users/efi-admin/Desktop/Test_LLimg_Sw/LLimg_01")
print("Hello, World!")
//listStorageDevices()
let pathSparse = "/Users/efi-admin/Desktop/Test_LLimg_Sw/LLimg_01"
//createSparseImage(at: "/Volumes/llidata", imageName: "MySparseImage", fileSys: "APFS", maxSize: "100m")
//let output = executeASRCommand()
//print(output) (Same error as above: Couldn’t set up partitions on target device - operation AddAPFSVolumeToContainer, line #5482 - error 49186
//let output = executeSudoCommand(command: "sudo asr restore --source / --target /Volumes/MySparseImage --erase --noprompt",passw: "Wait4Jesus99")
//print(output)
//print("finish")
