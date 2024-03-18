//
//  CaseInfoView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/3/23.
//

import SwiftUI

public struct CaseInfoViewRev: View {
    
    public var body: some View {

        VStack (alignment: .center, spacing: 7) {
                Text("Case Information Entered")
                .font(.headline)
                    .padding(.vertical, 5)
                HStack {
                    Text("Case:")
                        .font(.headline)
                        .padding(.leading, 3)
                        .frame(width: 120, alignment: .leading)
                    Text(CaseInfoData.shared.caseName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 220, alignment: .leading)
                }
                HStack {
                    Text("Evidence:")
                        .font(.headline)
                        .padding(.leading, 3)
                        .frame(width: 120, alignment: .leading)
                    Text(CaseInfoData.shared.evidenceName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 220, alignment: .leading)

                }
                HStack {
                    Text("Agent:")
                        .font(.headline)
                        .padding(.leading, 3)
                        .frame(width: 120, alignment: .leading)
                    Text(CaseInfoData.shared.agentName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 220, alignment: .leading)
 
                }
                HStack {
                    Text("Case ID:")
                        .font(.headline)
                        .padding(.leading, 3)
                        .frame(width: 120, alignment: .leading)
                    Text(CaseInfoData.shared.caseID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 220, alignment: .leading)

                }
                HStack {
                        Text("Notes:")
                            .font(.headline)
                            .padding(.leading, 3)
                            .frame(width: 120, alignment: .leading)
//                        Spacer()
                    Text(CaseInfoData.shared.caseNotes)
                            .frame(minHeight: 50, maxHeight: 90) // Height adjusts with content
                            .frame(width: 220, alignment: .leading)
                            .cornerRadius(8)
                            .border(Color.white, width: 1) // Border to visualize the text editor
                            .padding(3) // Padding inside the border

    
                    }
                }
                .frame(width: 400)
                .padding(.horizontal, 10)
                .background()

            
        }
        
    }
    


#Preview {
    CaseInfoViewRev()
}
