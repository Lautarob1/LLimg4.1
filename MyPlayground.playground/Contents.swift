

import Foundation
import SwiftUI

func printToFile(_ items: Any..., separator: String = " ", terminator: String = "\n", filePath: String = "/Users/efi-admin/Desktop") {
    // Create a file URL
    let fileURL = URL(fileURLWithPath: filePath)
    print("path file: " + filePath)
    // Convert items to a string
    let content = items.map { "\($0)" }.joined(separator: separator) + terminator

    // Open a file handle for writing, create the file if it doesn't exist
    if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
        // Seek to the end of the file to append content
        print("if file exists, here it is")
        fileHandle.seekToEndOfFile()

        // Write to the file
        if let data = content.data(using: .utf8) {
            fileHandle.write(data)
        }

        // Close the file handle
        fileHandle.closeFile()
    } else {
        // Create the file if it doesn't exist and write the content
        print("file doesn't exists, creating...")
        try? content.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}

// Usage
print("testing print to file")
printToFile("This will be written to a file instead of the console", filePath: "/Users/efi-admin/Desktop")

