//
//  TgtInfoViewRev.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/8/24.
//

import SwiftUI

struct TgtInfoViewRev: View {
    @State var isDiskValid: Bool = true
    @State var dskfileInfoDict2: [String: String] = [
        "Device Identifier": "disk1s1",
        "Volume Name": "MyVolume",
        "Mount Point": "Volume",
        "Mounted": "yes",
        "Volume Used Space": "xx space" ,
        "Container Total Space":"xyx space",
        "Container Free Space" : "xxx space",
        "Allocation Block Size" : "alloc Blk size",
        "Volume UUID": "Vol UUID..."]
    
    
    var body: some View {
        VStack (spacing: 3){
            // Display information from the first disk
            
            // Display information from the second disk
            Text("image will be stored at:")
                .font(.headline)
                .padding()
            if isDiskValid {
                displayDiskInfo(dskfileInfoDict2)
            } else {
                Text("No valid disk was selected for storage")
            }
            
            // Additional UI for calculations or other interactions
            // ...
        }
        .frame(width:430, height: 250)
        .background()
        .onAppear {
            let destinDisk = DiskDataManager.shared.selectedStorageOption
                dskfileInfoDict2 = diskutilInfo(for: (getDiskIDCapacityAvSpace(diskPath: destinDisk).diskID ?? "invalid"))
            if destinDisk == "invalid" {
                isDiskValid = false
            }
        }
    }
    
    private func displayDiskInfo(_ dict: [String: String]) -> some View {
        VStack {
            ForEach(Array(dict), id: \.key) { key, value in
                HStack {
                    Text("\(key):")
                        .font(.caption)
                        .frame(width: 125, height: 15, alignment: .leading)
                    Text("\(value)") // +  "😡")
                        .font(.caption2)
                        .frame(width: 280, alignment: .leading)
                }
            }
        }
        
    }
   
}


#Preview {

    TgtInfoViewRev()
}