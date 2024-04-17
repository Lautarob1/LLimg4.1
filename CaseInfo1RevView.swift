//
//  CaseInfoView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/3/23.
//

import SwiftUI

import SwiftUI

struct CaseInfo1RevView: View {
    @State private var caseName: String = ""
    @State private var evidenceName: String = ""
    @State private var agentName: String = ""
    @State private var caseID: String = ""
    @State private var caseNotes: String = ""
    private let maxWordCount = 200
    
    var body: some View {
//        HeaderView()
        HStack {
            VStack {
                Text("Case Information")
                    .padding()
                HStack {
                    Text("Case:")
                        .font(.headline)
                        .padding(.leading, 3)
                    TextField("Enter case name", text: $caseName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack {
                    Text("Evidence:")
                        .font(.headline)
                        .padding(.leading, 3)
                    TextField("Enter Evidence name", text: $evidenceName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack {
                    Text("Agent:")
                        .font(.headline)
                        .padding(.leading, 3)
                    TextField("Enter Agent name", text: $agentName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack {
                    Text("Case ID:")
                        .font(.headline)
                        .padding(.leading, 3)
                    TextField("Enter ID for case", text: $caseID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack {
                        Text("notes:")
                            .font(.headline)
                            .padding(.leading, 3)
                        TextEditor(text: $caseNotes)
                            .frame(minHeight: 40, maxHeight: 80) // Height adjusts with content
                            .frame(width: 270) // Fixed width
                        //                        .border(Color.white, width: 1) // Border to visualize the text editor
                            .padding(3) // Padding inside the border
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 3) // Border with rounded corners
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 7))
    
    
                    }
                }
                .frame(width: 370, height: 500)
                .padding()
            }
            
        }
        
    }
    


#Preview {
    CaseInfoView()
}
