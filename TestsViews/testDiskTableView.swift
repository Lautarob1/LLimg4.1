//
//  testDiskTableView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/21/24.
//

import SwiftUI

struct testTableHeaderView: View {
    var body: some View {
        HStack {
            Text("Num")
                .frame(width: 40)
                .foregroundColor(.white)
                .font(.headline)
            Text("Type")
                .frame(width: 140)
                .foregroundColor(.white)
                .font(.headline)
            Text("Name")
                .frame(width: 150)
                .foregroundColor(.white)
                .font(.headline)
            Text("Size")
                .frame(width: 70)
                .foregroundColor(.white)
                .font(.headline)
            Text("Ident")
                .frame(width: 100)
                .foregroundColor(.white)
                .font(.headline)
            Text("Use")
                .frame(width: 100)
                .foregroundColor(.white)
                .font(.headline)
        }
        .padding(3)
        .background(Color("LL_orange"))
    }
}

struct testTableRowView: View {
    let num: String
    let type: String
    let name: String
    let size: String
    let ident: String
    let extract: String

    var body: some View {
        HStack {
            Text(num)
                .frame(width: 20)
            Text(type)
                .frame(width: 140, alignment: .leading)
            Text(name)
                .frame(width: 150, alignment: .leading)
            Text(size)
                .frame(width: 70, alignment: .trailing)
            Text(ident)
                .frame(width: 100, alignment: .leading)
            Text(extract)
                .frame(width: 120, alignment: .leading)
        }
        .padding(1)
    }
}

struct testDiskTableView: View {
    @EnvironmentObject var diskDataManager: DiskDataManager
    
    var body: some View {
        VStack(spacing: 1) {
            Text("Items in black are those of which an image can be done. Main disk is highlighted in yelow")
                .font(.headline)
                .padding()
            TableHeaderView()
            ScrollView {
                ForEach(diskDataManager.dskData, id: \.num) { row in
                        let conditions = evaluateRowConditions(row)
                    TableRowView(
                        num: row.num,
                        type: row.type,
                        name: row.name,
                        size: row.size,
                        ident: row.ident,
                        extract: row.extract,
                        mtPt: row.mtPt
                        
                    )

//                    .background(isSysDisk ?  .red.opacity(0.3) : .clear)
                    .foregroundColor(conditions.isNoImg ? .blue : .primary)
//                    .foregroundColor(conditions.isRoot ? .black : .red)
                    .background(conditions.isRoot ?  .yellow.opacity(0.5) : .clear)
                }
            }
        }
        .font(.custom("Helvetica Neue", size: 11))
    }
  
    func evaluateRowConditions(_ row: (num: String, type: String, name: String, size: String, ident: String, extract: String, mtPt: String)) -> (isNoImg: Bool, isRoot: Bool, isValVol: Bool) {
//        print("############--- mP=\(row.mtPt)")
        var isNoImg = row.mtPt.contains("Not Mounted")
//        print(isNoImg)
        let isRoot = row.mtPt == "/".trimmingCharacters(in: .whitespacesAndNewlines)

        var isValVol = row.mtPt.hasPrefix("/Volumes")
        if !isValVol { isNoImg = true }
        if row.mtPt.contains("llimager") || row.mtPt.contains("llidata") {
            isNoImg = true
        }
        if isRoot { 
            isNoImg = false
            isValVol = true
            }
//        print("isnoImg \(isNoImg), mtpt=\(row.mtPt), isRoot=\(isRoot) isValVol= \(isValVol)")
        return (isNoImg, isRoot, isValVol)
    }

            
        }

struct DiskData {
    var num: String
    var type: String
    var name: String
    var size: String
    var ident: String
    var extract: String
    var mtPt: String
}

//let testsampleData = [
//     (num: "1", type: "Type1", name: "Name1", size: "Size1", ident: "Ident1", extract: "Extract1"),
//     // Add more rows as needed
// ]



#Preview {
    testDiskTableView()
        .environmentObject(DiskDataManager.shared)
 }
