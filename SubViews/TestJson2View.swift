//
//  TestJson2View.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 5/8/24.
//

import SwiftUI
import Foundation


//struct FilterFiles: Codable {
//    var filterCat: String
//    var categDet: [String]
//    
//}

//func saveFilterFiles(to filePath: URL, filterFiles: [FilterFiles]) {
//    do {
//        let encoder = JSONEncoder()
////        encoder.outputFormatting = .prettyPrinted // Makes the JSON output readable
//        let jsonData = try encoder.encode(filterFiles)
//        try jsonData.write(to: filePath, options: .atomic)
//        print("File saved successfully to \(filePath)")
//    } catch {
//        print("Failed to save JSON file: \(error)")
//    }
//}

//func loadFilterFiles(from filePath: URL) -> [FilterFiles]? {
//    do {
//        let jsonData = try Data(contentsOf: filePath)
//        let decoder = JSONDecoder()
//        let filterFiles = try decoder.decode([FilterFiles].self, from: jsonData)
//        return filterFiles
//    } catch {
//        print("Failed to load or decode JSON file: \(error)")
//        return nil
//    }
//}
//
//func createData() {
//    let spreadsheets = FilterFiles(filterCat: "spreadsheets", categDet: [".xls*", ".xlt*", ".numbers", ".csv", ".ods*"])
//    let documents = FilterFiles(filterCat: "documents", categDet: [".doc*", ".dot*", ".pdf", ".ppt*", ".pages", ".rtf", ".txt"])
//    let custom = FilterFiles(filterCat: "custom", categDet: [".ext1", ".ext2", ".ext3", ".ext4", ".ext5"])
//    let dateFilter = FilterFiles(filterCat: "dateFilter", categDet:["20240101", "20240331"])
//    print("spreadS: \(spreadsheets)")
//    print("docs: \(documents)")
//    print("custom: \(custom)")
//    print("dateFilter \(dateFilter)" )
//    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let jsonFile = documentsDirectory.appendingPathComponent("filterFiles2.json")
//
//    // Saving to JSON
//    saveFilterFiles(to: jsonFile, filterFiles: [spreadsheets, documents, custom, dateFilter])
//}
//
//func createJsonFilter(spreadSh: [String], docs: [String], media: [String], custom: [String], date: [String] ) {
//    let spreadsheets = FilterFiles(filterCat: "spreadsheets", categDet: spreadSh)
//    let documents = FilterFiles(filterCat: "documents", categDet: docs)
//    let media = FilterFiles(filterCat: "media", categDet: media)
//    let custom = FilterFiles(filterCat: "custom", categDet: custom)
//    let dateFilter = FilterFiles(filterCat: "dateFilter", categDet:["atime", "20240101", "20240331"])
//
//    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let jsonFile = documentsDirectory.appendingPathComponent("filterFiles3.json")
//
//    // Saving to JSON
//    saveFilterFiles(to: jsonFile, filterFiles: [spreadsheets, documents, media, custom, dateFilter])
//}

//func selectJsonFile() -> URL? {
//    let dialog = NSOpenPanel()
//    dialog.title                   = "Choose a JSON file"
//    dialog.showsResizeIndicator    = true
//    dialog.showsHiddenFiles        = false
//    dialog.canChooseDirectories    = false
//    dialog.canCreateDirectories    = true
//    dialog.allowsMultipleSelection = false
//    dialog.allowedFileTypes        = ["json"]
//
//    if dialog.runModal() == NSApplication.ModalResponse.OK {
//        return dialog.url
//    } else {
//        // User clicked on "Cancel"
//        return nil
//    }
//}



// if let url = selectJsonFile() {
//                    loadBooksFromExternalFile(url: url)
//                } else {
//                    print("File selection was canceled.")
//                }




//struct TestJson2View: View {
//    var body: some View {
//        VStack {
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            Button("WriteJson") {
//                let spreadSh = [".xls*", ".xlt*", ".numbers", ".csv", ".ods*"]
//                let docs = [".doc*", ".dot*", ".pdf", ".ppt*", ".pages", ".rtf", ".txt"]
//                let media = [".mp3", ".wav", ".mp4", ".mov", ".flv", ".3gp", ".mpeg", ".jpg", ".png", ".gif", ".psd", ".bmp",  ".tga", ".tif*", ".heic", ".jpeg"]
//                let custom = [".ext1", ".ext2", ".ext3", ".ext4", ".ext5"]
//                let dateFilter = ["atime", "20240101", "20240331"]
//                createJsonFilter(spreadSh: spreadSh, docs: docs, media: media, custom: custom, date: dateFilter)
//            }
//            Button("Read Json") {
//                let file2Read = URL(fileURLWithPath: "/Users/efi-admin/Documents/filterFiles2.json")
//                print(loadFilterFiles(from: file2Read) ?? "hello")
//                let readFile = loadFilterFiles(from: file2Read)
//                processFilterFiles(readFile!)
//                
//            }
//            Button("Read JsonFile") {
//                let file2Read = URL(fileURLWithPath: "/Users/efi-admin/Documents/filterFiles2.json")
//                let readFile = loadFilterFiles(from: file2Read)
//                processFilterFiles(readFile!)
//                
//            }
//        }
//        .frame(width: 400, height: 300)
//    }
//}

//#Preview {
//    TestJson2View()
//}
