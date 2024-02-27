//
//  ComboBoxView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/29/23.
//

import SwiftUI

struct ComboBoxView: View {
    @EnvironmentObject var diskDataManager: DiskDataManager
    @Binding var selectedDskOption: String
    @Binding var isComboDisabled: Bool
    let pickerLabel: String
    let toggleLabel: String
    
    var body: some View {
        
        VStack {
            // Left-aligned Toggle in an HStack
            HStack {
                Toggle(toggleLabel, isOn: $isComboDisabled)
                    .onChange(of: isComboDisabled) { newValue in comboToggleFunc(isDisabled: newValue)
 
                    }
                    Spacer()
                    }

                    .padding([.leading, .trailing])
                HStack {
                    // ComboBox (Picker)
                    Picker(pickerLabel, selection: $selectedDskOption) {
                        ForEach(diskDataManager.comboInfo, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .disabled(isComboDisabled) // Disable the combo box based on the toggle state
                    .pickerStyle(MenuPickerStyle()) // Use MenuPickerStyle for a combo box appearance
                }
            }

            .padding()
            .background()
            
        }
        

    func comboToggleFunc(isDisabled: Bool) {
        selectedDskOption = comboDefaultValue(using: diskDataManager)
        print("Toggle changed to: \(isDisabled)")

}
}


struct ComboBoxView_Previews: PreviewProvider {
    @State static var selectedOption = "synthesized disk1s1s1 10.2 GB" // Static State variable
    @State static var isComboDisabled = true

    static var previews: some View {
        let previewdiskDataManager = DiskDataManager.shared
        ComboBoxView(selectedDskOption: $selectedOption, isComboDisabled: $isComboDisabled, pickerLabel: "Choose Option", toggleLabel: "Live Image")
            .environmentObject(previewdiskDataManager)
    }
}



//
//#Preview {
//
//        .environmentObject(previewdiskDataManager)
//}

