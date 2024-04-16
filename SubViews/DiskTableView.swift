//
//  DiskTableView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/30/23.
//


import SwiftUI

struct TableHeaderView: View {
    var body: some View {
        HStack {
            Text("Num")
                .frame(width: 35)
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
                .frame(width: 70)
                .foregroundColor(.white)
                .font(.headline)
            Text("Use")
                .frame(width: 110)
                .foregroundColor(.white)
                .font(.headline)
            Text("Mounted")
                .frame(width: 90)
                .foregroundColor(.white)
                .font(.headline)
            
        }
        .padding(3)
        .background(Color("LL_orange"))
    }
}

struct TableRowView: View {
    let num: String
    let type: String
    let name: String
    let size: String
    let ident: String
    let extract: String
    let mtPt: String

    var body: some View {
        HStack {
            Text(num)
                .frame(width: 35)
            Text(type)
                .frame(width: 140, alignment: .leading)
            Text(name)
                .frame(width: 150, alignment: .leading)
            Text(size)
                .frame(width: 70, alignment: .trailing)
            Text(ident)
                .frame(width: 70, alignment: .leading)
            Text(extract)
                .frame(width: 110, alignment: .leading)
            Text(mtPt)
                .frame(width: 90, alignment: .leading)
        }
        .padding(1)
    }
}

struct DiskTableView: View {
    @EnvironmentObject var diskDataManager: DiskDataManager
    
    var body: some View {
        VStack(spacing: 1) {
            Text("Main synthesized disk is highlighted in yellow")
                .font(.headline)
                .padding()
            TableHeaderView()
            ScrollView {
                ForEach(diskDataManager.dskData, id: \.num) { row in
                        let conditions = evaluateRowConditions(row)
                    if #available(macOS 12.0, *) {
                        TableRowView(
                            num: row.num,
                            type: row.type,
                            name: row.name,
                            size: row.size,
                            ident: row.ident,
                            extract: row.extract,
                            mtPt: row.mtPt
                            
                        )
                        .foregroundColor(conditions.isNoImg ? .blue : .primary)
                        .background(conditions.isRoot ?  .yellow.opacity(0.5) : .clear)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
        .font(.custom("Helvetica Neue", size: 11))
    }
  
    func evaluateRowConditions(_ row: (num: String, type: String, name: String, size: String, ident: String, extract: String, mtPt: String)) -> (isNoImg: Bool, isRoot: Bool, isValVol: Bool) {
        var isNoImg = row.mtPt.contains("Not Mounted")
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
        print("isnoImg \(isNoImg), mtpt=\(row.mtPt), isRoot=\(isRoot) isValVol= \(isValVol)")
        return (isNoImg, isRoot, isValVol)
    }

            
        }

let sampleData = [
    (num: "1", type: "Type1", name: "Name1", size: "Size1", ident: "Ident1", extract: "Extract1", mtPt: "Volumes/test1"),
     // Add more rows as needed
 ]



#Preview {
    DiskTableView()
        .environmentObject(DiskDataManager.shared)
 }
