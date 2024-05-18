//
//  TestJson3View.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 5/9/24.
//

import SwiftUI
import Foundation



struct TestJson3View: View {
    let spreadSh = [".xls*", ".xlt*", ".numbers", ".csv", ".ods*", ".gnumeric", ".gsheet"]
    let docs = [".doc*", ".dot*", ".pdf", ".ppt*", ".pages", ".rtf", ".txt", ".odp", ".keynote"]
    let media = [".mp3", ".wav", ".mp4", ".mov", ".flv", ".3gp", ".mpeg", ".jpg", ".png", ".gif", ".psd", ".bmp",  ".tga", ".tif*", ".heic", ".jpeg", ".H264", ".av1"]
    let custom = [".ext1", ".ext2", ".ext3", ".ext4", ".ext5"]
    let dateFilter = ["atime", "20240101", "20240331"]
    let profileName = "filterFilesn.json"
    var body: some View {
        VStack {
            Image(systemName: "doc.richtext")
            Text("JSON tests")
            Button("Write JSON") {
                createJsonFilter(spreadSh: spreadSh, docs: docs, media: media, custom: custom, date: dateFilter, fileName: profileName)
            }
            Button("Read JSON") {
                let file2Read = URL(fileURLWithPath: "/Users/efi-admin/Documents/filterFiles3.json")
                let readFile = loadFilterFiles(from: file2Read)
                processFilterFiles(readFile!)
                
            }
            Button("select JSON") {
                print(selectJsonFile() as Any)
                
            }
        }
        .frame(width: 400, height: 200)
        
    }
}

#Preview {
    TestJson3View()
}
