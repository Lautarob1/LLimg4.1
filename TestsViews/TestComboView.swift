//
//  TestComboView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/29/24.
//

import SwiftUI

struct TestComboView: View {
    var body: some View {
        
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            ComboBoxView(
                selectedDskOption: Binding(
                    get: { DiskDataManager.shared.selectedDskOption },
                    set: { DiskDataManager.shared.selectedDskOption = $0 }
                ),
                
                isComboDisabled: Binding(
                    get: { DiskDataManager.shared.isComboDisabled },
                    set: { DiskDataManager.shared.isComboDisabled = $0 }
                ),
                pickerLabel: "Select disk ",
                toggleLabel: "Live Image"
            )
            .environmentObject(DiskDataManager.shared)
            Button("testCombo"){
                print(DiskDataManager.shared.selectedDskOption)
                print(extractusedDisk(from: DiskDataManager.shared.selectedDskOption))
            }
        }
        .frame(width: 400, height: 200)
        
    }
}

#Preview {
    TestComboView()
}
