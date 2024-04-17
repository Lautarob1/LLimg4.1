import Foundation
let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
process.arguments = ["your_command"]

let inputPipe = Pipe()
let outputPipe = Pipe()

process.standardInput = inputPipe
process.standardOutput = outputPipe

if let inputData = "inputdata".data(using: .utf8) {
    inputPipe.fileHandleForWriting.write(inputData)
}
let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
if let outputString = String(data: outputData, encoding: .utf8) {
    // Use outputString
}

do {
    try process.run()
    process.waitUntilExit()
} catch {
    // Handle error
}
