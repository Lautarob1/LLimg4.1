//
//  TestSudoTermView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/14/23.
//
import Foundation

func executeSudoCommand(command: String, password: String) -> String {
    let fullCommand = "echo \(password) | sudo -S \(command)"
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

// Example usage
//let output = executeSudoCommand(command: "your-sudo-command", password: "userPassword")
//print(output)

import SwiftUI

struct TestSudoView: View {
    @State private var command: String = ""
    @State private var password: String = ""
    @State private var output: String = ""

    var body: some View {
        VStack {
            TextField("Enter Command", text: $command)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Enter Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Run Command") {
                output = executeSudoCommand(command: command, password: password)
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


#Preview {
    TestSudoView()
}
