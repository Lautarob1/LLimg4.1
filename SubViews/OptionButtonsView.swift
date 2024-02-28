//
//  OptionButtonsView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/29/23.
//

import SwiftUI

struct OptionButtonsView: View {
    let buttonNames = ["SHA256", "SHA1", "MD5", "NO-HASH"] // Replace with actual button identifiers if needed
//    @State private var selectedHashOption: String?
//    DiskDataManager.shared.selectedHashOption
    @ObservedObject var diskDataManager = DiskDataManager.shared
    var body: some View {
        HStack {
            ForEach(buttonNames, id: \.self) { name in
                Button(action: {
                    self.diskDataManager.selectedHashOption = name
                }) {
                    Circle()
                        .fill(self.diskDataManager.selectedHashOption == name ? Color("LL_orange") : Color.white)
                        .frame(width: 15, height: 20) // Small, circular frame
                    Text(name)
                        .frame(width: 50, height: 20)
                        .font(.caption)
                }
                .padding(3)
            }
        }
    }
}
//import SwiftUI



#Preview {
    OptionButtonsView()
}
