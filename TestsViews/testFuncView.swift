//
//  testFuncView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/11/23.
//

import SwiftUI

struct testFuncView: View {
    let coman2 = "sudo asr restore --source / --target /Volumes/test3 --erase --noprompt"
    let coman1 = "sudo hdiutil create -size 500g -type SPARSE -fs APFS -volname test3 /Volumes/llidata/test3"
    let passwd="Wait4Jesus99"
    @State var output=""
    @State var dskfileInfoDict: [String: String] = [
        "Device Identifier": "disk1s1",
        "Volume Name": "MyVolume",
        "Mount Point": "Volume",
            "Mounted": "yes",
        "Volume Used Space": "xx space" ,
        "Container Total Space":"xyx space",
        "Container Free Space" : "xxx space",
        "Allocation Block Size" : "alloc Blk size",
        "Volume UUID": "Vol UUID..."]
    @State var showAlert: Bool


    
    var body: some View {
        VStack {
            HStack {
                        Text("\(output)")
                    .frame(width: 370, height: 100, alignment: .leading)
                   
                }
            HStack {
                Button("Extract Sys Dsk") {
                  output =  dskMainData2 ()
                }
                Button("disk capacity H read") {
                    let pathforDisk = "/Volumes/LLtestAPFS"
                    let HumanReadableSize = getDiskIDCapacityAvSpace(diskPath: pathforDisk).capacity ?? "No info"
                    output = HumanReadableSize
                }
            }

            }

        HStack {
            Button("show dest Dsk info")
            {
                let destinDisk = "/Volumes/test_HFS/LLtest"
                let dskfileInfoDict2 = diskutilInfo(for: (getDiskIDCapacityAvSpace(diskPath: destinDisk).diskID ?? "/Volumes/llidata"))
                print("Dest Dsk: \(dskfileInfoDict2)")
            }
            Button("alert") {
                showAlert = true}
        }
            
            if showAlert {
                CustomAlertView(
                    showAlert: $showAlert,
                    imageName: "exclamationmark.triangle",
                    title: "Warning",
                    message: "Something went wrong!",
                    fontSize1: 16,
                    fontSize2: 14,
                    textColor: .white,
                    backgroundColor: .blue)
            }
        HStack {
            Button("Verify dsk store cap") {
                 let sourceMP = "/"
                let destinationMP = "/Volumes/llidata"
                let destinationDMG = ""
                  output = String( isStorageSizeOK2 (sourceDisk: sourceMP, destinationDisk: destinationMP, destDMGDisk: destinationDMG))
            }
            
            Button ("Root disk ID") {
                output = getRootFileSystemDiskID()!
            }

            }


            // "/Volumes/llidata"
        Button("Test disk info volname") {
//                output = loadStorageDevicesInfo()
                print(loadStorageDevicesInfo())
            
        }
        Button("Test extract MountPt") {
            let dsk="disk1s1"
            let mounted = getMountPoint(diskIdentifier: dsk) ?? "N/A"
            print(mounted)
        }
        HStack {
            Button("Test fullDsk Access") {
//                output = String(checkFullDiskAccess())
                
            }
            
            Button("Dsk Cap Dets") {
                let volumePath = "/Volumes/llidata"
                let capacityDetails = getVolumeCapacityDetails(volumePath: volumePath)
                if let totalCapacity = capacityDetails.totalCapacity,
                   let availableCapacity = capacityDetails.availableCapacity {
                    print("Total Capacity: \(totalCapacity)")
                    print("Available Capacity: \(availableCapacity)")
                } else {
                    print("Capacity details not found for \(volumePath)")
                }
                let diskDetails = getRootFileSystemDiskDetails()
                if let diskID = diskDetails.diskID,
                   let capacity = diskDetails.capacity,
                   let availableSpace = diskDetails.availableSpace {
                    print("Root File System Disk ID: \(diskID)")
                    print("Disk Capacity: \(capacity)")
                    print("Available Space: \(availableSpace)")
                } else {
                    print("Disk details not found")
                }
            }
        }
//        .frame(width:450, height: 400)
        .onAppear {
        
            //            dskfileInfoDict = diskutilInfo(for: "disk1s1s1")
        }
    }
}

//let diskInfo = diskutilInfo(for: "disk1s1s1")


#Preview {
    
    testFuncView(showAlert: false)
}
