//
//  TestTermView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/7/23.
//

import SwiftUI

struct HardinfoViewRev: View {
    var hprofileArray: [(typeh: String, valueh: String)] // Declare the tuple with named elements
    
    init() {
        hprofileArray = loadHardwareProfile() // Load the hardware profile in the initializer
        deviceInfoData.shared.devName = hprofileArray[0].valueh
        deviceInfoData.shared.devIdent = hprofileArray[1].valueh
        deviceInfoData.shared.devMemory = hprofileArray[2].valueh
        deviceInfoData.shared.devSerial = hprofileArray[3].valueh
        deviceInfoData.shared.devhardUUID = hprofileArray[4].valueh
        
    }
    
    var body: some View {
        VStack {
            Text("Mac computer to be imaged")
                .font(.headline)
                .padding(5)
            ForEach(hprofileArray, id: \.self.typeh) { tuple in
                HStack { 
                    Text("\(tuple.typeh)")
                        .font(.headline)
                        .frame(width: 120, height: 20, alignment: .leading)
                    Text("\(tuple.valueh)")
                        .font(.caption)
                        .frame(width: 240, height: 20, alignment: .leading)
                }
            }
        }
        .frame(width:400)
        .padding(.horizontal, 10)
        .background()
    }
}
    
#Preview {
    HardinfoViewRev()
}
