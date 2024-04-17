//
//  CaseInfoView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/3/23.
//


import SwiftUI

struct CaseInfoView: View {
    @State private var caseName: String = CaseInfoData.shared.caseName
    @State private var evidenceName: String = CaseInfoData.shared.evidenceName
    @State private var agentName: String = CaseInfoData.shared.agentName
    @State private var caseID: String = CaseInfoData.shared.caseID
    @State private var caseNotes: String = CaseInfoData.shared.caseNotes

    private let maxWordCount = 200
    
    var body: some View {
        HStack {
            VStack {
                Text("Case Information")
                    .padding(.bottom, 50)
                    .font(.title)
                    .foregroundColor(Color("LL_blue"))
                HStack {
                    Text("Case:")
                        .font(.headline)
                        .frame(width: 70, alignment: .leading)
                    if #available(macOS 11.0, *) {
                        TextField("Enter case name", text: $caseName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(4)
                            .onChange(of: caseName) { newValue in
                                // Update the singleton when the local state changes
                                CaseInfoData.shared.caseName = newValue
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                }
                HStack {
                    Text("Evidence:")
                        .font(.headline)
                        .padding(.leading, 2)
                        .frame(width: 70, alignment: .leading)
                    if #available(macOS 11.0, *) {
                        TextField("Enter Evidence name", text: $evidenceName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(4)
                            .onChange(of: evidenceName) { newValue in
                                // Update the singleton when the local state changes
                                CaseInfoData.shared.evidenceName = newValue
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                }
                    HStack {
                        Text("Agent:")
                            .font(.headline)
                            .padding(.leading, 2)
                            .frame(width: 70, alignment: .leading)
                        if #available(macOS 11.0, *) {
                            TextField("Enter Agent name", text: $agentName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(4)
                                .onChange(of: agentName) { newValue in
                                    // Update the singleton when the local state changes
                                    CaseInfoData.shared.agentName = newValue
                                }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    HStack {
                        Text("Case ID:")
                            .font(.headline)
                            .padding(.leading, 2)
                            .frame(width: 70, alignment: .leading)
                        if #available(macOS 11.0, *) {
                            TextField("Enter ID for case", text: $caseID)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(4)
                                .onChange(of: caseID) { newValue in
                                    // Update the singleton when the local state changes
                                    CaseInfoData.shared.caseID = newValue
                                }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                HStack {
                    Text("Notes:")
                        .font(.headline)
                        .padding(.leading, 3)
                        .frame(width: 70, alignment: .leading)
                    if #available(macOS 11.0, *) {
                        TextEditor(text: $caseNotes)
                            .cornerRadius(10)
                            .onChange(of: caseNotes) { newValue in
                                // Update the singleton when the local state changes
                                CaseInfoData.shared.caseNotes = newValue}
                            .frame(minHeight: 40, maxHeight: 80) // Height adjusts with content
                            .frame(width: 260)
                            .padding(4)
                    } else {
                        // Fallback on earlier versions
                    } // Padding inside the border
                }
                }
                .frame(width: 350, height: 500)
                .padding()
            }
        }
        
    }
    


#Preview {
    CaseInfoView()
}
