//
//  TestPrintLogView.swift
//  LLimg_4
//
//  Created by EFI-Admin on 3/13/24.
//

import SwiftUI

func printCaseNotes () {
    let filePath = "/Volumes/LLtestAPFS/TA_01/AT_test06.info"
    let fileWriter = FileWriter(filePath: filePath)
    if let writer = fileWriter {
        writer.write("        Case Name:      \(CaseInfoData.shared.caseName)\n")
        writer.write("        Evidence Name:  \(CaseInfoData.shared.evidenceName)\n")
        writer.write("        Agent Name:     \(CaseInfoData.shared.agentName)\n")
        writer.write("        Case ID:        \(CaseInfoData.shared.caseID)\n")
//        writer.write("        Case Notes:        \(CaseInfoData.shared.caseNotes)\n")
        let casenoteF = writecaseNotes(CaseInfoData.shared.caseNotes)
//        writer.write("        Case Notes:    \(casenoteF)\n")
        if casenoteF.count > 0 {
            writer.write("\n")
            writer.write("        Case Notes:     \(casenoteF[0])\n")
            for casenote in casenoteF.dropFirst() {
                writer.write("                        \(casenote)\n")
            }
        }
    }
}

struct TestPrintLogView: View {
    var body: some View {
        VStack {
//            CaseInfoView()
            Button ("print notes") {
                printCaseNotes()
            }
            Button ("Extract file Attrib") {
                print("testing extr metadata")
                extractFileMetadata(at: "/Volumes/LLtestAPFS/TA_01/AT_test02.sparseimage")
            }
        }
    }

}

#Preview {
    TestPrintLogView()
}
