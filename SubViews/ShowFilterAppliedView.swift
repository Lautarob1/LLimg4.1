//
//  ShowFilterAppliedView.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 5/7/24.
//

import SwiftUI

struct ShowFilterAppliedView: View {
    @StateObject var filterSelection = FilterSelection()
    @State private var filterSpreadSheet: Bool = true
 
    var body: some View {
        ScrollView {
//            (alignment: .leading)
        VStack  {
            Text("F I L T E R")
           .font(.headline)
           .padding(.vertical, 5)
            Text("Filtered targeted collection Applied")
                .font(.caption)
                .padding(.vertical, 5)
            HStack {
                if FilterSelection.shared.isSpreadsheetFilterApplied {
                    VStack  (spacing: 0){
                        Text("Spreadsheets")
                            .font(.caption2)
                            .padding(.vertical, 0)
                        
                        Image(systemName: "tablecells")
                            .font(.system(size: 30))
                            .padding(.vertical, 0)
                            .frame(width:70, height: 34)
                        .foregroundColor(Color("LL_blue"))
                    }
                }
                if FilterSelection.shared.isDocumentFilterApplied {
                    VStack  (spacing: 0){
                        Text("Documents")
                            .font(.caption2)
                            .padding(.vertical, 0)
                        Image(systemName: "doc.richtext")
                            .font(.system(size: 30))
                            .frame(width:70, height: 34)
                            .foregroundColor(Color("LL_blue"))
                    }
                }
                if FilterSelection.shared.isMediaFilterApplied {
                    VStack  (spacing: 0){
                        Text("Multi-media")
                            .font(.caption2)
                            .padding(.vertical, 0)
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .frame(width:70, height: 34)
                            .foregroundColor(Color("LL_blue"))
                    }
                }
                if FilterSelection.shared.isCustomFilterApplied {
                    VStack  (spacing: 0){
                        Text("Custom")
                            .font(.caption2)
                            .padding(.vertical, 0)
                        Image(systemName: "doc.questionmark.fill")
                            .font(.system(size: 30))
                        //                        .frame(width:70, height: 34)
                            .foregroundColor(Color("LL_blue"))
                    }
                }
                if FilterSelection.shared.isDateFilterApplied {
                    VStack  (spacing: 0){
                        Text("Date Filter")
                            .font(.caption2)
                            .padding(.vertical, 0)
                        Image(systemName: "calendar")
                            .font(.system(size: 30))
                            .frame(width:70, height: 34)
                            .foregroundColor(Color("LL_blue"))
                    }
                }
            }
            
            Text("Collecting only files with extensions: ")
                .frame(width: 380, alignment: .leading)
                .font(.system(size: 11))
            Text("\(FilterSelection.shared.selectedAllTypes)")
                .frame(width: 380, alignment: .leading)
                if FilterSelection.shared.isDateFilterApplied {
                    let usedTimeStamps=FilterSelection.shared.whichDateFilterIsApplied
                    let usedStartTime=date2dateString(date: FilterSelection.shared.startDate)
                    let usedEndTime=date2dateString(date: FilterSelection.shared.endDate)
                    let terminalTime = terminalTimeStamps(typeTime: usedTimeStamps)
                    Text("and within the following \(usedTimeStamps) timestamps(\(terminalTime)): ")
                        .frame(width: 380, alignment: .leading)
//                    print("terminal time used: \(terminalTime)")
                    Text("Start date: \(usedStartTime) --> End Date: \(usedEndTime)")
                        .frame(width: 380, alignment: .leading)
                }
        }
        .frame(width: 380)
        }
        .frame(width: 420, height: 160)
    }
}

#Preview {
    ShowFilterAppliedView()
}
