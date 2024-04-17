//
//  ContentView.swift
//  TestHelperApp
//
//  Created by EFI-Admin on 12/16/23.
//
import Foundation

func mytest() {
    let script = "do shell script \"echo \"Wait4Jesus99\" | \"sudo -S whoami\""
        }
    //

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



func execAppleScript() {
    let script = NSAppleScript(source: "tell application \"System Events\" to display dialog \"Hello World\"")
    var errorDict: NSDictionary? = nil
    let output = script?.executeAndReturnError(&errorDict)
    if let error = errorDict {
        print("AppleScript Error: \(error)")
    } else {
        print("Script executed successfully")
    }
}

func executeAppleScriptCommand() {
    let command = "asr restore -source / -target /Volumes/test4 -noprompt -noverify -erase"
//    let command = "whoami"
    let script = "do shell script \"\(command)\" with administrator privileges"

    let appleScript = NSAppleScript(source: script)
    var errorDict: NSDictionary? = nil

    let output = appleScript?.executeAndReturnError(&errorDict)
    
    if let error = errorDict {
        print("AppleScript Error: \(error)")
    } else {
        print("Command executed successfully. Output: \(String(describing: output))")
    }
}


func execCmdwAdminRights(command: String, arguments: [String]) {
    let script = "do shell script \"\(command) \(arguments.joined(separator: " "))\" with adminstrator privileges"
    let appleScript = NSAppleScript(source: script)
    var errorDict: NSDictionary? = nil
    appleScript?.executeAndReturnError(&errorDict)
    if let error = errorDict {
        print(error)
    } else {
        print("command executed succesfully")
    }
}

func executeASRCommand() -> String {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/hdiutil")
    // Include necessary arguments for the asr command
    process.arguments = ["create", "-size", "500g", "-type", "SPARSE", "-fs", "APFS", "-volname", "test5","/Volumes/llidata/test5"]
//    process.executableURL = URL(fileURLWithPath: "/usr/sbin/asr")
//    // Include necessary arguments for the asr command
//    process.arguments =   ["restore", "-source", "/", "-target", "/Volumes/test3", "-noprompt", "-noverify", "-erase"]
//
//
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



import SwiftUI

struct ContentView: View {
    @State private var command: String = ""
    @State private var password: String = ""
    @State private var output: String = ""

    var body: some View {
        VStack {
//            TextField("Enter Command", text: $command)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            SecureField("Enter Password", text: $password)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()

            Button("Run Command") {
            output=executeSudoCommand(command: "asr restore --source / --target /Volumes/test1 --erase --noprompt", passw: "Wait4Jesus99")
//                execAppleScript()
//                let appleScript = NSAppleScript(source: "do shell script \"open -a Finder\" with administrator privileges")
//                executeAppleScriptCommand()
//                output = executeASRCommand()
//               execCmdwAdminRights(command: "/usr/sbin/asr", arguments: ["restore", "-source", "/", "-target", "/Volumes/test3", "-noprompt", "-noverify", "-erase"])
//                execCmdwAdminRights(command: "/bin/date", arguments: ["0101120020"])
            }
            .padding()

            ScrollView {
                Text(output)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
        }
        .frame(width: 400, height: 300)
        .padding()
    }
}

// commands
//"hdiutil create -size 500g -type SPARSE -fs APFS -volname test1 /Volumes/llidata/test1"
//output=executeSudoCommand(command: "sudo -S whoami", passw: "Wait4Jesus99")

#Preview {
    ContentView()
}
