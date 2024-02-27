//
//  TestPrintView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/2/24.
//

import SwiftUI

struct TestHashView: View {
    @State private var calcHash: String = "calc hash"
    @State private var pathFile: String = ""
    
   
    var body: some View {
        VStack {
            Color("LL_blue").opacity(0.3)
                .frame(height: 100)
            Text("T E S T   H A S H   C A L C U L A T I O N S  . . .")
            Text(calcHash)
                .frame(minWidth: 400, minHeight: 30) // Set the desired size
                .background(Color.blue)
                .foregroundColor(.white)
                .padding()
            
            Text("file: \(pathFile)")
                .frame(minWidth: 300, minHeight: 30) // Same size as the first Text
                .background(Color.blue)
                .foregroundColor(.white)
                .padding()
            HStack (spacing: 55){
                Button("Calculate MD5") {
                    pathFile = "/Volumes/llidata/test_07.dmg"
                    print("MD5 button")
                    print(LLTimeManager.getCurrentTimeString())
                    if let md5Hash = hashLargeFileMD5(filePath: pathFile) {
                        print("MD5 Hash: \(md5Hash)")
                        calcHash = "MD5 Hash: \(md5Hash)"
                        
                    }
                    print(LLTimeManager.getCurrentTimeString())
//                    if let md5Hash = calculateMD5Hash(for: pathFile) {
//                        print("MD5 Hash: \(md5Hash)")
//                        calcHash = "MD5 Hash: \(md5Hash)"
//                    }
                }
                Button("Calculate SHA1") {
                    print("SHA1 button")
                    pathFile = "/Users/efi-admin/Desktop/llimager.lic"
                    if let sha1Hash = calculateSHA1Hash(for: pathFile) {
                        print("SHA1 Hash: \(sha1Hash)")
                        calcHash = "SHA1 Hash: \(sha1Hash)"
                    }
                }
                Button("Calculate SHA256") {
                    print("SHA256 button")
                    pathFile = "/Volumes/llidata/test01a.info"
                    let sha256Hash = hashLargeFileSHA256(filePath: pathFile)
                        print("SHA256 Hash: \(sha256Hash)")
                        calcHash = "SHA256 Hash: \(sha256Hash)"
                    }
                }
            }
        }
    }


#Preview {
    TestHashView()
}
