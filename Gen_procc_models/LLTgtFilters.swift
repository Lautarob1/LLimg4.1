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

    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let jsonFile = documentsDirectory.appendingPathComponent(fileName)

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
    }
        else {
            print("bad profile file at: \(url)")
            FilterSelection.shared.profileFilterUsed = "invalid"
        }
    }
}

func dateString2Date (dateStr: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"  // Set the date format according to the string

    if let date = dateFormatter.date(from: dateStr) {
        return date
    } else {
        return Date()
    }
    
}


func date2dateString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"  // Set the date format to "yyyy-MM-dd"

    let dateString = dateFormatter.string(from: date)
    return dateString
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
