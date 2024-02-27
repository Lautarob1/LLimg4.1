//
//  TestTermView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/7/23.
//

import SwiftUI

struct DiskinfoViewRev: View {
    @State var dskfileInfoDict1: [String: String] = [
        "Device Identifier": "disk1s1",
        "Volume Name": "MyVolume",
        "Mount Point": "Volume",
        "Mounted": "yes",
        "Volume Used Space": "xx space" ,
        "Container Total Space":"xyx space",
        "Container Free Space" : "xxx space",
        "Allocation Block Size" : "alloc Blk size",
        "Volume UUID": "Vol UUID..."]
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
            Text("Disk to be imaged:")
                .font(.headline)
                .padding()
            displayDiskInfo(dskfileInfoDict1)
            Spacer()
            // Display information from the second disk
            Text("image will be stored at:")
                .font(.headline)
                .padding()
            displayDiskInfo(dskfileInfoDict2)
            
            // Additional UI for calculations or other interactions
            // ...
        }
        .frame(width:430)
        .background()
        .onAppear {
//            print("detailed disk info for: \(DiskDataManager.shared.selectedDskOption)")
            let sourceDisk = "/dev/"+(extractusedDisk(from: DiskDataManager.shared.selectedDskOption) ?? "/")
            let destinationDisk = DiskDataManager.shared.selectedStorageOption
            let destDMGDisk = DiskDataManager.shared.selected2ndStorageOption
            dskfileInfoDict1 = diskutilInfo(for: getDiskIDCapacityAvSpace(diskPath: sourceDisk).diskID ?? dskMainData2())
            let destinDisk = DiskDataManager.shared.selectedStorageOption
//            guard dskfileInfoDict2 = diskutilInfo(for: (getDiskIDCapacityAvSpace(diskPath: destinationDisk).diskID!  else {
//                print("File path not set")
//                return
//            }
                           
            dskfileInfoDict2 = diskutilInfo(for: (getDiskIDCapacityAvSpace(diskPath: destinationDisk).diskID ?? "/Volumes/llidata"))
            print("detailed for destin dsk in DiskInfoViewRev: \(dskfileInfoDict2)")
        }
    }
    
    private func displayDiskInfo(_ dict: [String: String]) -> some View {
        VStack {
            ForEach(Array(dict), id: \.key) { key, value in
                HStack {
                    Text("\(key):")
                        .font(.caption)
                        .frame(width: 120, height: 15, alignment: .leading)
                    Text("\(value)")
                        .font(.caption2)
                        .frame(width: 300, height: 15, alignment: .leading)
                }
            }
        }
        
    }
   
}


#Preview {
    DiskinfoViewRev()
}
