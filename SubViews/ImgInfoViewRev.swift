//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct ImgInfoViewRev: View {
//    @EnvironmentObject var diskDataManager: DiskDataManager
    @State private var imageName: String = ""
    @State private var isliveimgChecked: Bool = true
    @State private var isViewPresented = false
    @State private var isDMGChecked: Bool = false
    
    var body: some View {
        VStack (alignment: .center, spacing: 5) {
                Text("Review Image Information")
                .font(.headline)
                .padding(.vertical, 5)
                
                HStack {
                    Text("Image Name:")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(CaseInfoData.shared.imageName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200, alignment: .leading)
                }
                HStack {
                    Text("Image path:")
                        .font(.headline)
                        .padding(.leading, 3)
                        .frame(width: 150, alignment: .leading)
                    Text(DiskDataManager.shared.selectedStorageDestin)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200, alignment: .leading)
                }
                HStack {
                    Text("Live Image:")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(String(DiskDataManager.shared.isComboDisabled)).textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200, alignment: .leading)
                }
                HStack {
                    Text("Device to be imaged:")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text("\(DiskDataManager.shared.selectedDskOrigen)")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200, alignment: .leading)
                }
            HStack {
                Text("DMG to be produced:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                Text(String(    CaseInfoData.shared.isdmgEnabled)).textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200, alignment: .leading)
            }
            HStack {
                Text("Path for DMG:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                Text(CaseInfoData.shared.dmgfilePath)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200, alignment: .leading)
            }
                         
            HStack {
                Text("Selected Hash:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                Text(DiskDataManager.shared.selectedHashOption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200, alignment: .leading)
            }

            }
                .frame(width: 400) //, height: 500)
                .padding(.horizontal, 10)
                .background()
            }
            
        }



#Preview {
    ImgInfoViewRev()
}
