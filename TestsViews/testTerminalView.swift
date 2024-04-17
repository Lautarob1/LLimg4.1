//
//  testTerminalView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/13/23.
//
import Foundation
import SwiftUI

class TerminalViewModel: ObservableObject {
    @Published var output: String = ""
     private var inputPipe = Pipe()
     private var outputPipe = Pipe()

     func executeCommand(_ command: String) {
         let process = Process()
         process.executableURL = URL(fileURLWithPath: "/bin/zsh") // or use /bin/bash
         process.arguments = ["-c", command]

         process.standardOutput = outputPipe
         process.standardInput = inputPipe

         do {
             try process.run()
             readOutput()
             print("Command executed: \(command)")
         } catch {
             print("An error occurred: \(error)")
             output = "Error: \(error.localizedDescription)"
         }
     }

     func sendInput(_ input: String) {
         if let inputData = (input + "\n").data(using: .utf8) {
             inputPipe.fileHandleForWriting.write(inputData)
             print("Input sent: \(input)")
         }
     }

     private func readOutput() {
         let outputHandle = outputPipe.fileHandleForReading
         DispatchQueue.global(qos: .background).async {
             let data = outputHandle.readDataToEndOfFile()
             DispatchQueue.main.async {
                 if let outputStr = String(data: data, encoding: .utf8) {
                     self.output += outputStr
                     print("Output received: \(outputStr)")
                 }
             }
         }
     }
 }

struct testTermView2: View {
    @ObservedObject var sviewModel = TerminalViewModel()

    var body: some View {
        VStack {
            ScrollView {
                Text(sviewModel.output)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
        }
        .onAppear {
            sviewModel.executeCommand("sudo su -S")
        }
    }
}


#Preview {
    testTermView2()
}
