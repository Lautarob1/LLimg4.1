import Foundation

func runShellCommand(_ command: String) -> String {
    let process = Process()
    let pipe = Pipe()

    process.standardOutput = pipe
    process.standardError = pipe
    process.arguments = ["-c", command]
    process.launchPath = "/bin/zsh" // or /bin/bash based on your shell
    process.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8) ?? ""
}

import Combine

class ConsoleViewModel: ObservableObject {
    @Published var output: String = ""

    func executeCommand(_ command: String) {
        DispatchQueue.global(qos: .background).async {
            let result = runShellCommand(command)
            DispatchQueue.main.async {
                self.output += result + "\n"
            }
        }
    }
}

import SwiftUI

struct ConsoleView: View {
    @ObservedObject var viewModel = ConsoleViewModel()

    var body: some View {
        VStack {
            ScrollView {
                Text(viewModel.output)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            Button("Run Command") {
                viewModel.executeCommand("echo Hello, World!")
            }
        }
    }
}


