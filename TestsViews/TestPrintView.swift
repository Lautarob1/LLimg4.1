//
//  TestPrintView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/2/24.
//

import SwiftUI

struct TestPrintView: View {
    @State var testHdiutil: String = ""
    @State var detachedRes: String = ""
    @State var detachedOut: String = ""
    var body: some View {
        VStack {
            Color("LL_blue").opacity(0.3)
                .frame(height: 100)
            Text("T E S T   P R I N T  . . .")
            Text(detachedRes)
                .frame(minWidth: 200, minHeight: 50) // Set the desired size
                .background(Color.blue)
                .foregroundColor(.white)
                .padding(2)
            
            Text(detachedOut)
                .frame(minWidth: 200, minHeight: 50) // Same size as the first Text
                .background(Color.blue)
                .foregroundColor(.white)
                .padding(2)
            Text(testHdiutil)
                .frame(minWidth: 200, minHeight: 50) // Same size as the first Text
                .background(Color.blue)
                .foregroundColor(.white)
                .padding(2)
            HStack {
                Button("extract hiutil info") {
                    // /Volumes/llidata/test_07.sparseimage
                    testHdiutil =        extractDiskIdentifier(sparseMounted: "/Volumes/llidata/test_07.sparseimage")
                    //                let logfilePath="/Volumes/llidata/testinfofile.info"
                    //                print2Log(filePath: logfilePath, text2p: "disk1s1s1")
                    //                print2Log(filePath: logfilePath, text2p: dskinfoTarget(volName: "disk1s1s1"))
                    //                print2Log(filePath: logfilePath, text2p: "before addic header")
                    ////                aqclogH6eader()
                    //                print2Log(filePath: logfilePath, text2p: "after addic header")
                    //                let diskInfoString = dskinfoTarget(volName: "disk1s1s1")
                    //                let extractedData = extractData(from: diskInfoString)
                    //                for (key, value)
                    //                        in diskCapacity(dataRead: extractedData) {
                    //                    print2Log(filePath: logfilePath, text2p: "\(key): \(value)")
                    //                    print("test: \(key): \(value)")
                }

                Button("extract assoc dsk") {
                    let hdutilinfo = loaddhiutilInfo()
                    print(hdutilinfo)
                    let imgPath = "/Volumes/llidata/test_07.sparseimage"
                    detachedRes = extractDiskIdentifier2(from: hdutilinfo, imagePath: imgPath) ?? "notfound"
                    //                detachedRes = detachSparse(diskAssig: testHdiutil)}
                }
            Button("detach") {
                let detachedRes = "/dev/disk3"
                let detachedOut = detachSparse (diskAssig: detachedRes)
                }
            Button("test timer") {
                print(LLTimeManager.getCurrentTimeStringnd())
                print(LLTimeManager.getCurrentTimeString())
                }
            }
            }
        }
    }


#Preview {
    TestPrintView()
}
