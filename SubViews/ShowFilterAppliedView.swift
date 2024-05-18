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
                if FilterSelection.shared.isSpreadSheetFilterApplied {
                    Image(systemName: "tablecells")
                        .font(.system(size: 30))
                        .frame(width:70, height: 34)
                        .foregroundColor(Color("LL_blue"))
                }
                if FilterSelection.shared.isDocumentFilterApplied {
                    Image(systemName: "doc.richtext")
                        .font(.system(size: 30))
                        .frame(width:70, height: 34)
                        .foregroundColor(Color("LL_blue"))
                }
                if FilterSelection.shared.isMediaFilterApplied {
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .frame(width:70, height: 34)
                        .foregroundColor(Color("LL_blue"))
                }
                if FilterSelection.shared.isCustomFilterApplied {
                    Image(systemName: "doc.questionmark.fill")
                        .font(.system(size: 30))
//                        .frame(width:70, height: 34)
                        .foregroundColor(Color("LL_blue"))
                }
                if FilterSelection.shared.isDateFilterApplied {
                    Image(systemName: "calendar")
                        .font(.system(size: 30))
                        .frame(width:70, height: 34)
                        .foregroundColor(Color("LL_blue"))
                }
                                
            }
            
            Text("Colecting only files with extensions: ")
            Text("\(FilterSelection.shared.selectedAllTypes)")
                .frame(width: 380, alignment: .leading)
                if FilterSelection.shared.isDateFilterApplied {
                    let usedTimeStamps=FilterSelection.shared.whichDateFilterIsApplied
                    let usedStartTime=date2dateString(date: FilterSelection.shared.startDate)
                    let usedEndTime=date2dateString(date: FilterSelection.shared.endDate)
                    Text("and falling within the following \(usedTimeStamps) timestamps: ")
                        .frame(width: 380, alignment: .leading)
                    Text("Start date: \(usedStartTime) --> End Date: \(usedEndTime)")
                        .frame(width: 380, alignment: .leading)
                }
                
        }
        .frame(width: 380)
        }
        .frame(width: 420, height: 100)
    }
}

#Preview {
    ShowFilterAppliedView()
}
