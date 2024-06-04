//
//  LLTgtFilters.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 5/13/24.
//

import Foundation
import SwiftUI

struct FilterFiles: Codable {
    var filterCat: String
    var categDet: [String]
    
}

func selectJsonFile() -> URL? {
    let dialog = NSOpenPanel()
    dialog.title                   = "Choose a JSON file"
    dialog.showsResizeIndicator    = true
    dialog.showsHiddenFiles        = false
    dialog.canChooseDirectories    = false
    dialog.canCreateDirectories    = false
    dialog.allowsMultipleSelection = false
    dialog.allowedFileTypes        = ["json"]

    let initialDirectoryURL = URL(fileURLWithPath: "/Volumes/llimager/llimager")
        dialog.directoryURL = initialDirectoryURL

    
    if dialog.runModal() == NSApplication.ModalResponse.OK {
        return dialog.url
    } else {
        // User clicked on "Cancel"
        return nil
    }
}

func saveFilterFiles(to filePath: URL, filterFiles: [FilterFiles]) {
    do {
        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted // Makes the JSON output readable
        let jsonData = try encoder.encode(filterFiles)
        try jsonData.write(to: filePath, options: .atomic)
        print("File saved successfully to \(filePath)")
    } catch {
        print("Failed to save JSON file: \(error)")
    }
}

func processFilterFiles(_ filterFiles: [FilterFiles]) {
    var cont = 0
    for file in filterFiles {
//        print("[\"\(file.filterCat)\", \(file.categDet)]")
        print("\(file.filterCat), \(file.categDet)")
        print(filterFiles[cont])
        print(filterFiles[cont].categDet)
        cont += 1
    }
}

func loadFilterFiles(from filePath: URL) -> [FilterFiles]? {
    do {
        let jsonData = try Data(contentsOf: filePath)
        let decoder = JSONDecoder()
        let filterFiles = try decoder.decode([FilterFiles].self, from: jsonData)
        return filterFiles
    } catch {
        print("Failed to load or decode JSON file: \(error)")
        return nil
    }
}
func createJsonFilter(spreadSh: [String], docs: [String], media: [String], custom: [String], date: [String], fileName: String ) {
    let spreadsheets = FilterFiles(filterCat: "spreadsheets", categDet: spreadSh)
    let documents = FilterFiles(filterCat: "documents", categDet: docs)
    let media = FilterFiles(filterCat: "media", categDet: media)
    let custom = FilterFiles(filterCat: "custom", categDet: custom)
    let dateFilter = FilterFiles(filterCat: "dateFilter", categDet: date)

//    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let jsonFile = documentsDirectory.appendingPathComponent(fileName)
    let volumeDirectory = URL(fileURLWithPath: "/Volumes/llimager/llimager")
    let jsonFile = volumeDirectory.appendingPathComponent(fileName)


    // Saving to JSON
    saveFilterFiles(to: jsonFile, filterFiles: [spreadsheets, documents, media, custom, dateFilter])
}

func saveFilterFiles2(to filePath: URL, filterFiles: [FilterFiles]) {
    do {
        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted // Makes the JSON output readable
        let jsonData = try encoder.encode(filterFiles)
        try jsonData.write(to: filePath, options: .atomic)
        print("File saved successfully to \(filePath)")
    } catch {
        print("Failed to save JSON file: \(error)")
    }
}

func processSelectedJsonFile() {
    guard let url = selectJsonFile() else {
        print("No file was selected or the panel was cancelled.")
        return
    }

    if let filterFiles = loadFilterFiles(from: url) {
        print("Loaded FilterFiles successfully:")
                if filterFiles.count == 5 {
        for filterFile in filterFiles {
            print("\(filterFile.filterCat): \(filterFile.categDet)")
        }
        FilterSelection.shared.selectedSpreadsheetTypes = filterFiles[0].categDet
        FilterSelection.shared.selectedDocumentTypes = filterFiles[1].categDet
        FilterSelection.shared.selectedMediaTypes = filterFiles[2].categDet
        FilterSelection.shared.selectedCustomTypes = filterFiles[3].categDet
        FilterSelection.shared.selectedDateParam = filterFiles[4].categDet
        FilterSelection.shared.profileFilterUsed = url.lastPathComponent
        print(FilterSelection.shared.selectedSpreadsheetTypes)
        print(FilterSelection.shared.selectedCustomTypes)
        print(FilterSelection.shared.selectedDateParam)
//                    if filterFiles[4].categDet.count != 0 {
//                        FilterSelection.shared.isDateFilterApplied = true
//                    }
    }
        else {
            print("bad profile file at: \(url)")
            FilterSelection.shared.profileFilterUsed = "invalid"
        }
    }
}

func dateString2Date (dateStr: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"  // Set the date format according to the string

    if let date = dateFormatter.date(from: dateStr) {
        return date
    } else {
        return Date()
    }
    
}


func date2dateString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"  // Set the date format to "yyyy-MM-dd"
    print("date in date2Str: \(date)")
    let dateString = dateFormatter.string(from: date)
    return dateString
}

//"Accessed": "Last time the file was accessed",
//"Modified": "Last time the content of the file was modified",
//"Inode Δ": "inode  changes: permissions, location or content",
//"Created": "Creation timestamp for the file"]


func terminalTimeStamps(typeTime: String) -> String {
    switch typeTime {
    case "Accessed":
        return "at"
    case "Modified":
        return "mt"
    case "Inode Δ":
        return "ct"
    case "Created":
        return "bt"
    default:
        return "mt"
    }
 
}

func copyFilesWithExtensionsAndTime(sourcePath: String, destinationPath: String, extensions: [String], timeType: String, date1: Date, date2: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmmss"

    let startDate = dateFormatter.string(from: date1)
    let endDate = dateFormatter.string(from: date2)

    var findCommand = "find \(sourcePath) -type f"

    // Add date filters only if date1 is not equal to date2
    if date1 != date2 {
        findCommand += " -timeType +\(startDate) -timeType-\(endDate)"
    }

    // Add extension filters if any
    if !extensions.isEmpty {
        let exts = extensions.map { "-name \($0)" }.joined(separator: " -o ")
        findCommand += " \\( \(exts) \\)"
    }

    findCommand += " -exec cp {} \(destinationPath) \\;"

    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/zsh")
    process.arguments = ["-c", findCommand]

    do {
        try process.run()
        process.waitUntilExit()
        if process.terminationStatus == 0 {
            print("Files successfully copied.")
        } else {
            print("Error occurred during file copying.")
        }
    } catch {
        print("Failed to start process: \(error)")
    }
}

func sanitizeProfileName(in input: String) -> String {
    let charsToReplace = CharacterSet(charactersIn: "!@#$%^&*/\\|")
    let sanitizedName = input.unicodeScalars.map { charsToReplace.contains($0) ? "?" : String($0) }.joined()
    return sanitizedName
}


func copyWithFilterFolder(
    from folderPath: String,
    to destinationPath: String,
    extensions: [String],
    timestampType: String,
    startDate: Date? = nil,
    endDate: Date? = nil
) {
    let fileManager = FileManager.default
    print("in cpWithFilterFolder...")
    
    
    // DateFormatter to format the modification times for the terminal command
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm"
    
    // Date range string
    var dateRangeString = ""
    if let start = startDate {
        dateRangeString += "-newer\(timestampType) '\(dateFormatter.string(from: start))'"
    }
    if let end = endDate {
        if !dateRangeString.isEmpty {
            dateRangeString += " !"
        }
        dateRangeString += "-newer\(timestampType) '\(dateFormatter.string(from: end))'"
    }
    var findCommand = "find \(folderPath) -type f"
    print("early find command \(findCommand)")
    // Extensions pattern
    
    if !extensions.isEmpty {
        findCommand += " \\("
        for (index, ext) in extensions.enumerated() {
            if index > 0 {
                findCommand += " -o"
            }
            findCommand += " -iname \"*\(ext)\""
        }
        findCommand += " \\)"
    }
    let destFolderPath = (destinationPath as NSString).appendingPathComponent(folderPath)
    let today = Date()
    let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: today)!
    print("in cpWithFilterFolder findCommand before check isFiltApp: \(findCommand)")
    if FilterSelection.shared.isDateFilterApplied  {

//        print("in cpWithFilterFolder datesRgtring (no dates): \(dateRangeString)")

    findCommand += " -newer\(timestampType) '\(startDate ?? oneYearAgo)' ! -newer\(timestampType) '\(endDate ?? today)' -print0 | rsync --files-from=- --from0 / \(destinationPath)"
    print("in cpWithFilterFolder findCommand when isFiltApp=true: \(findCommand)")
    }
    else {
        findCommand += " -print0 | rsync --files-from=- --from0 / \(destinationPath)"
        print("in cpWithFilterFolder findCommand when isFiltApp=false: \(findCommand)")
    }
    let process = Process()
    process.launchPath = "/bin/bash"
    process.arguments = ["-c", findCommand]
    
    do {
        try process.run()
        process.waitUntilExit()
        if process.terminationStatus == 0 {
            print("Files copied successfully.")
        } else {
            print("Failed to copy files. Exit status: \(process.terminationStatus)")
        }
    } catch {
        print("Error running the process: \(error)")
    }
}


func copyWithFilterItem(
    filePath: String,
    to destinationPath: String,
    extensions: [String],
    timestampType: String,
    startTime: Date?,
    endTime: Date?
)
{
    let fileManager = FileManager.default
    print("in copyWithFilter... ")
    // Get the file extension
    let fileExtension = (filePath as NSString).pathExtension
    print("extensions allowed to pass: \(extensions)")
    print("fileExt to review: \(fileExtension)")
//    guard extensions.contains(fileExtension) else {
//        print("File extension does not match.")
//        return
//    }
    if !matchesExtension(fileExtension: fileExtension, patterns: extensions) {
        print("File extension does not match.")
        return
    }
    
    // Get the file attributes
    do {
        let attributes = try fileManager.attributesOfItem(atPath: filePath)
        var fileDate: Date?
        
        switch timestampType {
        case "at":
            fileDate = attributes[.creationDate] as? Date // Adjust if 'atime' key is different
        case "mt":
            fileDate = attributes[.modificationDate] as? Date
        case "ct":
            fileDate = attributes[.creationDate] as? Date
        case "bt":
            fileDate = attributes[.creationDate] as? Date // Adjust if 'Btime' key is different
        default:
            print("Invalid timestamp type.")
            return
        }
        
        // Check if file date is within the range
        if let fileDate = fileDate {
            if let startTime = startTime, fileDate < startTime {
                print("File timestamp is before the start time.")
                return
            }
            if let endTime = endTime, fileDate > endTime {
                print("File timestamp is after the end time.")
                return
            }
        } else {
            print("File date not found.")
            return
        }
        
        // Construct the destination file path
//        let fileName = (filePath as NSString).lastPathComponent
        let destFilePath = (destinationPath as NSString).appendingPathComponent(filePath)
        print("destFilePath appendded used by cp cmd: \(destFilePath)")
        print("sourfeFilePath used by cp cmd: \(filePath)")
        // Copy the file
        createDirectoryStructureIfNeeded(sourceFilePath: filePath, destinationBasePath: destinationPath)
        copyItem(atPath:  filePath, toPath:  destFilePath)
        print("after copy item process")
        
    } catch {
        print("Error: \(error)")
    }
}


func createDirectoryStructureIfNeeded(sourceFilePath: String, destinationBasePath: String) {
    let fileManager = FileManager.default
    let sourceURL = URL(fileURLWithPath: sourceFilePath)
    let directoryPath = sourceURL.deletingLastPathComponent().path
    let destinationDirectoryURL = URL(fileURLWithPath: destinationBasePath).appendingPathComponent(directoryPath)

    // Check if the directory already exists
    if !fileManager.fileExists(atPath: destinationDirectoryURL.path) {
        do {
            // Create the necessary directories in the destination path
            try fileManager.createDirectory(at: destinationDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            print("Directory structure created successfully at \(destinationDirectoryURL.path)")
        } catch {
            print("Error creating directory structure: \(error.localizedDescription)")
        }
    } else {
        print("Directory already exists at \(destinationDirectoryURL.path)")
    }
}

// Example usage
//let sourceFilePath = "/Users/userAdmin/Documents/FilterTests/PDF_file11.pdf"
//let destinationBasePath = "/Volumes/Vol12"
//
//createDirectoryStructureIfNeeded(sourceFilePath: sourceFilePath, destinationBasePath: destinationBasePath)

//// Example usage
//let sourceFilePath = "/Users/userAdmin/Documents/FilterTests/PDF_file11.pdf"
//let destinationBasePath = "/Volumes/Vol12"
//
//createDirectoryStructure(sourceFilePath: sourceFilePath, destinationBasePath: destinationBasePath)


// Define the extensions array with wildcard patterns
let extensions = ["xls*", "doc*", "pdf"]

// Define the file extension to check
let fileExtension = "xlsx"

// Function to check if a file extension matches any of the patterns in the extensions array
func matchesExtension(fileExtension: String, patterns: [String]) -> Bool {
    for pattern in patterns {
        // Create a regular expression from the pattern by replacing * with a regex that matches any characters
        let regexPattern = "^" + pattern.replacingOccurrences(of: "*", with: ".*") + "$"
        
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: [])
            let range = NSRange(location: 0, length: fileExtension.utf16.count)
            if regex.firstMatch(in: fileExtension, options: [], range: range) != nil {
                return true
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }
    }
    return false
}

// Check if the file extension matches any of the patterns
//let result = matchesExtension(fileExtension: fileExtension, patterns: extensions)

//print("Does the file extension match any pattern? \(result)")
