//
//  StorageDevView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/30/23.
//

import SwiftUI

struct StorageDevView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var diskDataManager: DiskDataManager

    var body: some View {
        VStack {
            DiskTableView()
                .environmentObject(DiskDataManager.shared)// DiskTableView will access the data from DiskDataManager
            Button("OK") {
                isPresented = false
            }
            .padding()
        }
    }
}


#Preview {
    StorageDevView(isPresented: .constant(true))
        .environmentObject(DiskDataManager.shared)
}
