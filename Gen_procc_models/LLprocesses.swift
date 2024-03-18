//
//  LLprocesses.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import Foundation

func initTgt() {
// initialize values for tgt
    FileSelectionManager.shared.selectedFiFo = []
    DiskDataManager.shared.selectedDskOption = ""
    DiskDataManager.shared.selectedStorageOption = ""
    DiskDataManager.shared.selected2ndStorageOption = ""
    DiskDataManager.shared.selectedHashOption = "SHA256"
    DiskDataManager.shared.isComboDisabled = true
    CaseInfoData.shared.imageName = "TargetedImg01"
}

func initSparse() {
// initialize values for both convert sparse and hash
    FileSelectionManager.shared.selectedFiles = []
    DiskDataManager.shared.selectedDskOption = ""
    DiskDataManager.shared.selectedStorageOption = ""
    DiskDataManager.shared.selected2ndStorageOption = ""
    DiskDataManager.shared.selectedHashOption = "SHA256"
    CaseInfoData.shared.imageName = ""
    
}


func initHash() {
// initialize values for both convert sparse and hash
    FileSelectionManager.shared.selectedFiles = []
    DiskDataManager.shared.selectedDskOption = ""
    DiskDataManager.shared.selectedStorageOption = ""
    DiskDataManager.shared.selected2ndStorageOption = ""
    DiskDataManager.shared.selectedHashOption = "SHA256"
    CaseInfoData.shared.imageName = ""
    
}

func loadDiskInfo() -> [String] {
    // this process reads all storage devices connected to the computer and returned a lines array as per terminal output
    // each line would be one line of the cmd, like
    //  /dev/disk0 (internal, physical):
    //  #:                       TYPE NAME                    SIZE       IDENTIFIER
    //  0:      GUID_partition_scheme                        *500.3 GB   disk0
    //  1:                        EFI EFI                     314.6 MB   disk0s1
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/usr/sbin/diskutil")
    process.arguments = ["list"]
    process.standardOutput = pipe
    
    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        return output.split(separator: "\n").map { String($0) }
        
    } catch {
        print("Error executing diskutil: \(error)")
        return []
    }
    
}

func extractDiskIdentifier(sparseMounted: String) -> String {
//    using the command hdiutil info file loaddhiutilInfo, separate by device (section) and within a section, seeks
//    correspondiing image name and if found extract corresponding disk identifier (like disk3s1, disk4s2 etc). Only IMAGES
    print("executing extDsk with \(sparseMounted)")
    let hdiResults = loaddhiutilInfo()
    print(hdiResults)
    if hdiResults.contains(sparseMounted) {
        let lines = hdiResults.components(separatedBy: "\n")
        for line in lines {
            if line.contains("GUID_partition_scheme") {
                let components = line.components(separatedBy: "\t")
                if let diskIdentifier = components.first {
                    return diskIdentifier
                }
            }
        }
    }
    return "DiskNot found"
}

func extractDiskIdentifier2(from text: String, imagePath: String) -> String? {
//    from the output of
    // Split the text into sections based on "image-path"
    let sections = text.components(separatedBy: "image-path")
    
    for section in sections {
        // Check if the section contains the specified imagePath
        if section.contains(imagePath) {
            // Split the section into lines
            let lines = section.components(separatedBy: "\n")
            
            // Search for the line with "GUID_partition_scheme"
            for line in lines {
                if line.contains("GUID_partition_scheme") {
                    // Extract and return the disk identifier
                    let components = line.components(separatedBy: "\t")
                    return components.first?.trimmingCharacters(in: .whitespaces)
                }
            }
        }
    }
    
    // Return nil if not found
    return nil
}

func loadStorageDevicesInfo() -> String {
//    list all info for each storage device connected to a Mac
    let process = Process()
    let pipe = Pipe()
    process.launchPath = "/usr/bin/diskutil"
    process.arguments = ["info", "-all"]
    process.standardOutput = pipe
    
    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        return output
        
    } catch {
        print("Error executing dhiutil: \(error)")
        return ""
        
    }
    
}

func loaddhiutilInfo() -> String {
//    list all info for the IMAGES files found
//    (only image files)
    
    let process = Process()
    let pipe = Pipe()
    process.launchPath = "/usr/bin/hdiutil"
    process.arguments = ["info"]
    process.standardOutput = pipe
    
    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        return output
        
    } catch {
        print("Error executing dhiutil: \(error)")
        return ""
        
    }
    
}


func getMountPoint(diskIdentifier: String) -> String? {
    let process = Process()
    let pipe = Pipe()
    process.executableURL = URL(fileURLWithPath: "/usr/sbin/diskutil")
    process.arguments = ["info", diskIdentifier]
    process.standardOutput = pipe

    do {
        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
//        print("###################")
//        print("output from cmd info: \(output) using diskId: \(diskIdentifier) ")
        // Parse the output to find the Mount Point
        let lines = output.components(separatedBy: .newlines)
        for line in lines {
//            print("line for ident \(diskIdentifier): \(line)")
            if line.contains("Mount Point:") {
//                print("MountP found in info....")
                let components = line.components(separatedBy: ":")
//                print("grabbed: \(components)")
                if components.count > 1 {
                    return components[1].trimmingCharacters(in: .whitespaces)
                }
                break
            }
        }
    } catch {
        print("Failed to run diskutil: \(error)")
    }

    return nil
}


func getSystemDiskInfo() -> (diskIdentifier: String, totalCapacity: Int64, usedSpace: Int64, availableSpace: Int64)? {
//    Get system disk id (and other values)
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/bin/df")
    process.arguments = ["/"]
    process.standardOutput = pipe

    do {
        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        let lines = output.components(separatedBy: "\n")
        if lines.count > 1 {
            let components = lines[1].split(separator: " ", maxSplits: 7, omittingEmptySubsequences: true)
            if components.count >= 7 {
                let fullDiskIdentifier = String(components[0])
                var diskIdentifier = ""
                if let range = fullDiskIdentifier.range(of: #"disk\d+"#, options: .regularExpression) {
                     diskIdentifier = String(fullDiskIdentifier[range])}
                let totalCapacity = Int64(components[1]) ?? 0
                let usedSpace = Int64(components[2]) ?? 0
                let availableSpace = Int64(components[3]) ?? 0
                return (diskIdentifier, totalCapacity * 512, usedSpace * 512, availableSpace * 512)
            }
        }
    } catch {
        print("Error in func getSystemDiskInfo: \(error)")
        print("Called with no parameter")
    }

    return nil
}


func getAnyDiskInfo(dskpath: String) -> (diskIdentifier: String, totalCapacity: Int64, usedSpace: Int64, availableSpace: Int64)? {
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/bin/df")
    process.arguments = [dskpath]
    process.standardOutput = pipe

    do {
        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        let lines = output.components(separatedBy: "\n")
        if lines.count > 1 {
            let components = lines[1].split(separator: " ", maxSplits: 7, omittingEmptySubsequences: true)
            if components.count >= 7 {
                let fullDiskIdentifier = String(components[0])
                var diskIdentifier = ""
                if let range = fullDiskIdentifier.range(of: #"disk\d+"#, options: .regularExpression) {
                     diskIdentifier = String(fullDiskIdentifier[range])}
                let totalCapacity = Int64(components[1]) ?? 0
                let usedSpace = Int64(components[2]) ?? 0
                let availableSpace = Int64(components[3]) ?? 0
                return (diskIdentifier, totalCapacity * 512, usedSpace * 512, availableSpace * 512)
            }
        }
    } catch {
        print("Error in func getAnyDiskInfo: \(error)")
        print("Called with parameter dskpath = \(dskpath)")
    }

    return nil
}

func isStorageSizeOK (sourceDisk: String, destinationDisk: String, destDMGDisk: String) -> Bool {
//    check if there is capacity to storage both imaged (sparse & DMG)
    var isCapacity = false
    if let totalCapacity = getAnyDiskInfo(dskpath: sourceDisk)?.totalCapacity,
       let availableSpace1 = getAnyDiskInfo(dskpath: destinationDisk)?.availableSpace,
       let availableSpace2 = getAnyDiskInfo(dskpath: destDMGDisk)?.availableSpace,
       2 * totalCapacity < availableSpace1  || (totalCapacity < availableSpace1) && (totalCapacity < availableSpace2) {
        print("required capacity x 2 = \(2 * totalCapacity)")
        print("Available Space = \(availableSpace1 + availableSpace2)")
        print("Available Space 1 = \(availableSpace1)")
        print("Available Space 2 = \(availableSpace2)")
        isCapacity = true
        print(isCapacity)
    }
     else {
        isCapacity = false
         print(isCapacity)
         if let availableSpace2 = getAnyDiskInfo(dskpath: destDMGDisk)?.availableSpace {
             print("availableSpace2: \(availableSpace2)")
         }
    }
    
    return isCapacity
}

func isStorageSizeOK2(sourceDisk: String, destinationDisk: String, destDMGDisk: String) -> Bool {
    if let totalCapacity = getAnyDiskInfo(dskpath: sourceDisk)?.totalCapacity,
       let availableSpace1 = getAnyDiskInfo(dskpath: destinationDisk)?.availableSpace {
        
        let availableSpace2 = getAnyDiskInfo(dskpath: destDMGDisk)?.availableSpace ?? 0
        print("required capacity x 2 = \(2 * totalCapacity)")
        print("Available Space = \(availableSpace1 + availableSpace2)")
        print("Available Space 1 = \(availableSpace1)")
        print("Available Space 2 = \(availableSpace2)")
        
        if 2 * totalCapacity < availableSpace1 ||
            (totalCapacity < availableSpace1 && totalCapacity < availableSpace2) {
            return true
        }
    }
    return false
}
    

//func checkFullDiskAccess() -> Bool {
////    Not working, should be checked manually before start the app
//    let fileManager = FileManager.default
//    let path = NSHomeDirectory() + "/Library/Application Support"
//    
//    do {
//        let _ = try fileManager.contentsOfDirectory(atPath: path)
//        return true // Able to access the directory
//    } catch {
//        return false // Access denied
//    }
//}


func detachSparse (diskAssig: String) -> String {
    // unmount sparse container to process conver to DMG
    let process = Process()
    let pipe = Pipe()
    process.launchPath = "/usr/bin/hdiutil"
    process.arguments = ["detach", diskAssig]
    process.standardOutput = pipe
    
    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        return output
        
  
    } catch {
        print("Error executing dhiutil: \(error)")
        return ""
        
    }
}


func processDskInfo(_ lines: [String]) -> (diskInfo: [(num: String, type: String, name: String, size: String, ident: String, extract: String, mtPt: String)], comboInfo: [String]) {
    // process diskutil list and parses based on position to create the table. Also, prepare combo with only devices that can
    // be imaged
    var dskinfo: [(num: String, type: String, name: String, size: String, ident: String, extract: String, mtPt: String)] = []
    var comboInfo: [String] = []
    let betparen = "\\((.*?)\\)"
    let regex = try! NSRegularExpression(pattern: betparen)
    var extract: String = ""
    var lineCounter: Int = 0

    for line in lines {

        if line.hasPrefix("/dev") {
//            print("line with prefix /dev")
            let range = NSRange(location: 0, length: line.utf16.count)
            if let match = regex.firstMatch(in: line, options: [], range: range),
               let range = Range(match.range(at: 1), in: line) {
               extract = String(line[range])

            }
        } else {
            let newLine = String(line.dropFirst(3))
            
//            print("1st newline: " + String(newLine.prefix(1)))
            if (0...25).contains(where: { newLine.starts(with: "\($0)") }) {
               
                let num = String(newLine.prefix(1))
//                print("num " + num)
                let type = String(newLine[newLine.index(newLine.startIndex, offsetBy: 3)..<newLine.index(newLine.startIndex, offsetBy: 30)])
//                print("type " + type)
                let name = String(newLine[newLine.index(newLine.startIndex, offsetBy: 30)..<newLine.index(newLine.startIndex, offsetBy: 53)])
                let size = String(newLine[newLine.index(newLine.startIndex, offsetBy: 53)..<newLine.index(newLine.startIndex, offsetBy: 63)])
                let ident = String(newLine.dropFirst(64)).trimmingCharacters(in: .whitespacesAndNewlines)

                // Assuming 'extract' is defined and valid here
                let mtPt = getMountPoint(diskIdentifier: ident) ?? "Not Mounted"

                let data = (String(lineCounter), type, name, size, ident, extract, mtPt)

                dskinfo.append(data)
                if listinCombo(mountP: mtPt) {
                    let combo = "\(extract) \(ident) \(size)"
                    comboInfo.append(combo)
                }
                lineCounter = lineCounter + 1
            }
        }
    }
    return (dskinfo, comboInfo)
}

func listinCombo(mountP: String) -> Bool {
    var isinCombo = false
//    if mountP == "Not Mounted" {isinCombo = false }
    if mountP.hasPrefix("/Volumes") && !( mountP.contains("llimager") || mountP.contains("llidata") ) {isinCombo = true } // else { isinCombo = false}
    if mountP.hasPrefix("/Library") {isinCombo = false}
    if mountP == "/" {isinCombo = true}
//    print("mountP: \(mountP), isinCombo: \(isinCombo)")
    return isinCombo
    
}


func dskinfoTarget(volName: String) -> String {
    let process = Process()
    let pipe = Pipe()
    var cmdinfoResponse: String = ""
//    var output: String = ""
    process.launchPath = "/usr/sbin/diskutil"
    process.arguments = ["info", volName]
    
    process.standardOutput = pipe
    do {
//        print("inside do dskinfoTarget")
        try process.run()
        //        print("within Do, just after try")
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        cmdinfoResponse = String(data: data, encoding: .utf8) ?? ""

        return cmdinfoResponse
    } catch {
        print("Error executing diskutil info: \(error)")
        
    }
    return cmdinfoResponse
}

func dskinfofromPath (path: String) -> [(titleh: String, valueh: String)]  {
//  extract fom diskutil info the disk info indicated in array datatype.
    let process = Process()
    let pipe = Pipe()
    let datatype = ["Device Identifier: ", "Device Node: ", "Volume Name: ", "Mount Point: ", "Disk size:", "Volume Total Space: ",
                    "Volume Used Space: ", "Volume Free Space: ", "Container Total Space (ARM): ", "Container Free Space (ARM): "]
    var dskinfo: [(titleh: String, valueh: String)] = []
    
    process.launchPath = "/usr/sbin/diskutil"
    process.arguments = ["info", path]

    process.standardOutput = pipe

    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        let dskLines = output.split(separator: "\n").map { String($0) }

        for daty in datatype  {
            // Find the line starting with the current title

            if let dskline = dskLines.first(where: { line in
                line.trimmingCharacters(in: .whitespaces).hasPrefix(daty)
            }) {
                // Remove the title from the line to get the content

                let content = dskline.replacingOccurrences(of: daty, with: "").trimmingCharacters(in: .whitespaces)
                // Create a tuple with the title and the content
                let tuple = (daty, content)

                // Append the tuple to the result array
                dskinfo.append(tuple)
            }
        }
     return dskinfo
    } catch {
        print("Error executing diskutil info: \(error)")
        return []
    }
    
}



func dskMainData2 () -> String {
    let process = Process()
    let pipe = Pipe()

    process.launchPath = "/bin/bash"
    process.arguments = ["-c", "df -h / | grep '/dev/' | awk '{print $1}' | cut -d'/' -f3"]

    process.standardOutput = pipe
    process.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""

    return output.trimmingCharacters(in: .newlines)

}



func loadHardwareProfile () -> [(typeh: String, valueh: String)]  {
    let process = Process()
    let pipe = Pipe()
    let datatype = ["Model Name: ", "Model Identifier: ", "Memory: ", "Serial Number (system): ", "Hardware UUID: "]
    var hardinfo: [(typeh: String, valueh: String)] = []
    
    process.launchPath = "/usr/sbin/system_profiler"
    process.arguments = ["SPHardwareDataType"]

    process.standardOutput = pipe
//    print("before Do")
    do {
        try process.run()
//        print("within Do, just after try")
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        let hwareLines = output.split(separator: "\n").map { String($0) }

        for title in datatype  {
            // Find the line starting with the current title

            if let hwline = hwareLines.first(where: { line in
                line.trimmingCharacters(in: .whitespaces).hasPrefix(title)
            }) {
                // Remove the title from the line to get the content

                let content = hwline.replacingOccurrences(of: title, with: "").trimmingCharacters(in: .whitespaces)
                // Create a tuple with the title and the content
                let tuple = (title, content)

                // Append the tuple to the result array
                hardinfo.append(tuple)
            }
        }
     return hardinfo
    } catch {
        print("Error executing hardwareProfile: \(error)")
        return []
    }
    
}

func extractusedDisk(from string: String) -> String? {

    let infowords = string.split(separator: " ")
//    print("info count: \(infowords.count)")
    if infowords.count <= 4 {
        return infowords.count >= 3 ? String(infowords[1]) : nil}
    else {
        return infowords.count >= 4 ? String(infowords[2]) : nil}
    }


func doNothing () {
    print("from test functon doNothing")
}



func sysProfiler () -> String {
    let process = Process()
    let pipe = Pipe()

    process.launchPath = "/usr/sbin/system_profiler"
    process.arguments = ["SPHardwareDataType"]

    process.standardOutput = pipe
    process.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    return output.trimmingCharacters(in: .newlines)

}


func diskutilInfo(for disk: String) -> [String: String] {
//  extract for DISK disk, all data produced by diskutil info disk
    let process = Process()
    let pipe = Pipe()
    
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["diskutil", "info", disk]
    process.standardOutput = pipe
    
    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        return parseDiskutilOutput(output)
    } catch {
        print("An error occurred: \(error)")
        return [:]
    }
}

func parseDiskutilOutput(_ output: String) -> [String: String] {
    
//    Receives the output from diskutil list xxxx and parses the data in red below
    var infoDict = [String: String]()
    
    let lines = output.components(separatedBy: "\n")
    for line in lines {
        let components = line.components(separatedBy: ":").map { $0.trimmingCharacters(in: .whitespaces) }
        if components.count == 2 {
            switch components[0] {
                case "Device Identifier",
                     "Volume Name",
                     "Mount Point",
                     "Mounted",
                     "Volume Used Space",
                     "Container Total Space",
                     "Container Free Space",
                     "Volume Free Space",
                     "Volume Total Space",
                     "Allocation Block Size",
                     "Volume UUID":
                    infoDict[components[0]] = components[1]
                default:
                    break
            }
        }
    }
    
    return infoDict
}



func findUserDisk(of focusIdent: String, in combo: [String]) -> Int? {
    for (index, line) in combo.enumerated() {
        if line.contains(focusIdent) {
            // Line number is index + 1 (since line numbers usually start at 1)
            return index + 1
        }
    }
    // Return nil if the ident is not found
    return nil
}

func comboDefaultValue(using diskDataManager: DiskDataManager) -> String {
    let focString = dskMainData2()
    if let comboInIndex = findUserDisk(of: focString, in: diskDataManager.comboInfo) {
        // If the index is found, return the corresponding string from comboInfo
        return diskDataManager.comboInfo[comboInIndex - 1]
    } else {
        // Handle the case where the index isn't found
        // You could return a default string or handle this case differently
        return diskDataManager.comboInfo[0] // Replace with an appropriate default or handling
    }
}

func acqlogHeader(filePath: String) {
    FileDelete.deleteIfExists(filePath: filePath)
    let fileWriter = FileWriter(filePath: filePath)
    if let writer = fileWriter {
        writer.write("██╗     ██╗         ██╗███╗   ███╗ █████╗  ██████╗ ███████╗██████╗     ██╗   ██╗██╗  ██╗\n")
        writer.write("██║     ██║         ██║████╗ ████║██╔══██╗██╔════╝ ██╔════╝██╔══██╗    ██║   ██║██║  ██║\n")
        writer.write("██║     ██║         ██║██╔████╔██║███████║██║  ███╗█████╗  ██████╔╝    ██║   ██║███████║\n")
        writer.write("██║     ██║         ██║██║╚██╔╝██║██╔══██║██║   ██║██╔══╝  ██╔══██╗    ╚██╗ ██╔╝╚════██║\n")
        writer.write("███████╗███████╗    ██║██║ ╚═╝ ██║██║  ██║╚██████╔╝███████╗██║  ██║     ╚████╔╝      ██║\n")
        writer.write("╚══════╝╚══════╝    ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝      ╚═══╝       ╚═╝\n")
        writer.write("\n")
        writer.write(String(repeating: "=", count: 88))
        writer.write("\n")
        writer.write("LLimager V 4.0")
        writer.write(" -  Mac Computers Forensics Imager\n")
        writer.write("\n")
//        writer.write("        A C Q U I S I T I O N    L O G    D E T A I L S \n")
        writer.write("        ╔═╗╔═╗╔═╗ ╦ ╦╦╔═╗╦╔╦╗╦╔═╗╔╗╔  ╦  ╔═╗╔═╗  ╔╦╗╔═╗╔╦╗╔═╗╦╦  ╔═╗\n")
        writer.write("        ╠═╣║  ║═╬╗║ ║║╚═╗║ ║ ║║ ║║║║  ║  ║ ║║ ╦   ║║║╣  ║ ╠═╣║║  ╚═╗\n")
        writer.write("        ╩ ╩╚═╝╚═╝╚╚═╝╩╚═╝╩ ╩ ╩╚═╝╝╚╝  ╩═╝╚═╝╚═╝  ═╩╝╚═╝ ╩ ╩ ╩╩╩═╝╚═╝\n")
        
        writer.write(String(repeating: "-", count: 88))
        writer.write("\n")
//        writer.write("    Case Summary\n")
//        writer.write("    Case Summary\n")
//        writer.write("    Case Summary\n")
        writer.write("    Case Summary\n")
        writer.write("\n")
        writer.write("        Case Name:      \(CaseInfoData.shared.caseName)\n")
        writer.write("        Evidence Name:  \(CaseInfoData.shared.evidenceName)\n")
        writer.write("        Agent Name:     \(CaseInfoData.shared.agentName)\n")
        writer.write("        Case ID:        \(CaseInfoData.shared.caseID)\n")
        let casenoteF = writecaseNotes(CaseInfoData.shared.caseNotes)
//        print("*** case notes count \(String(casenoteF.count))")
        if casenoteF.count > 0 {
            writer.write("\n")
            writer.write("        Case Notes:     \(casenoteF[0])\n")
            for casenote in casenoteF.dropFirst() {
                writer.write("                        \(casenote)\n")
            }
        }
        writer.write("\n")
        writer.write("        Start Time:     \(LLTimeManager.getCurrentTimeString())\n")
        
    } 
        else {
        // Handle error: Failed to initialize FileWriter
        print("Failed to initialize FileWriter")
        return }
    
}

func writecaseNotes(_ caseNotes: String, lineLength: Int = 50) -> [String] {
    var casenotesFormated = [String]()
    if caseNotes.contains("\n") {
        let paragraphs = caseNotes.components(separatedBy: "\n")
        for paragraph in paragraphs {
            // Split paragraph into words
            let words = paragraph.split(separator: " ")
            var currentLine = ""
            for word in words {
                if currentLine.count + word.count + 1 > lineLength {
                    // Append the current line to the result and start a new line
                    casenotesFormated.append(currentLine)
                    currentLine = String(word)
                } else {
                    // Add word to the current line
                    if !currentLine.isEmpty {
                        currentLine += " "
                    }
                    currentLine += word
                }
            }
            
            // Add the last line of the paragraph if it's not empty
            if !currentLine.isEmpty {
                casenotesFormated.append(currentLine)
            }
            
        }
        }
            else {
                let paragraph = caseNotes
                let words = paragraph.split(separator: " ")
                var currentLine = ""
                for word in words {
                    if currentLine.count + word.count + 1 > lineLength {
                        // Append the current line to the result and start a new line
                        casenotesFormated.append(currentLine)
                        currentLine = String(word)
                    } else {
                        // Add word to the current line
                        if !currentLine.isEmpty {
                            currentLine += " "
                        }
                        currentLine += word
                    }
                }
                
                // Add the last line of the paragraph if it's not empty
                if !currentLine.isEmpty {
                    casenotesFormated.append(currentLine)
                }
                
    }
        
        return casenotesFormated
    }

func exclogHeader(filePath: String) {    
    FileDelete.deleteIfExists(filePath: filePath)
    let fileWriter = FileWriter(filePath: filePath)
    if let writer = fileWriter {
        writer.write("\n")
        writer.write(String(repeating: "=", count: 88))
        writer.write("\n")
        writer.write("    LLimager V 4.0\n")
        writer.write("      Mac Computers Forensics Imager\n")
        writer.write("\n")
        writer.write("        E X E C   L O G    D E T A I L S \n")
        writer.write(String(repeating: "-", count: 88))
        writer.write("\n")
        writer.write("    Case Summary\n")
        writer.write("\n")
        writer.write("        Case Name:      \(CaseInfoData.shared.caseName)\n")
        writer.write("        Evidence Name:  \(CaseInfoData.shared.evidenceName)\n")
        writer.write("        Agent Name:     \(CaseInfoData.shared.agentName)\n")
        writer.write("        Case ID:        \(CaseInfoData.shared.caseID)\n")
        let casenoteF = writecaseNotes(CaseInfoData.shared.caseNotes)
        if casenoteF.count > 0 {
            writer.write("\n")
            writer.write("        Case Notes:     \(casenoteF[0])")
            for casenote in casenoteF.dropFirst() {
                writer.write("                        \(casenote)\n")
            }
        }
        writer.write("\n")
        writer.write("        Start Time:     \(LLTimeManager.getCurrentTimeString())\n")
        writer.write(String(repeating: "-", count: 88))
    }
        else {
        // Handle error: Failed to initialize FileWriter
        print("Failed to initialize FileWriter")
        return }
    
}


func acqlogDeviceInfo(filePath: String) {
    let fileWriter = FileWriter(filePath: filePath)
    if let writer = fileWriter {
        writer.write("\n")
        writer.write(String(repeating: "-", count: 88))
        writer.write("\n")
        writer.write("    Hardware information\n")
        writer.write("\n")
        writer.write("        Serial Number:  \(deviceInfoData.shared.devSerial)\n")
        writer.write("        Model Name:     \(deviceInfoData.shared.devName)\n")
        writer.write("        Model Indent.:  \(deviceInfoData.shared.devIdent)\n")
//        writer.write("        Model Number:   \(deviceInfoData.shared.devNumber)\n")
//        writer.write("        Model Chip:     \(deviceInfoData.shared.devChip)\n")
//        writer.write("        Total Cores:    \(deviceInfoData.shared.devCores)\n")
        writer.write("        Memory:         \(deviceInfoData.shared.devMemory)\n")
//        writer.write("        Firmware Vers:  \(deviceInfoData.shared.devFirmware)\n")
//        writer.write("        OS Loader:      \(deviceInfoData.shared.devOSloader)\n")
        writer.write("        Device UUID:    \(deviceInfoData.shared.devhardUUID)\n")
//        writer.write("        Provisng UUID:  \(deviceInfoData.shared.devprovisUUID)\n")
//        writer.write("        Act Lock stat:  \(deviceInfoData.shared.devLockstatus)\n")
        
    }
        else {
        // Handle error: Failed to initialize FileWriter
        print("Failed to initialize FileWriter")
        return }
    
}

func acqlogTitleProcesses (filePath: String) {
    let fileWriter = FileWriter(filePath: filePath)
    if let writer = fileWriter {
    writer.write("       ┌─┐┬─┐┌─┐┌─┐┌─┐┌─┐┌─┐┌─┐┌─┐\n")
    writer.write("       ├─┘├┬┘│ ││  ├┤ └─┐└─┐├┤ └─┐\n")
    writer.write("       ┴  ┴└─└─┘└─┘└─┘└─┘└─┘└─┘└─┘\n")
    }
        else {
        // Handle error: Failed to initialize FileWriter
        print("Failed to initialize FileWriter")
        return }
}

func acqlogDiskInfo(filePath: String) {
    let fileWriter = FileWriter(filePath: filePath)
    if let writer = fileWriter {
        writer.write("\n")
        writer.write(String(repeating: "-", count: 88))
        writer.write("\n")
        writer.write("    Source Disk Information\n")
        
        // here thrown whatever is captured from the command  diskutil info  disk1s1
        
        
        writer.write("\n")
        writer.write(dskinfoTarget(volName: extractusedDisk(from: DiskDataManager.shared.selectedDskOption) ?? dskMainData2()))
        writer.write(String(repeating: "=", count: 88))
        writer.write("\n")
    }
        else {
        // Handle error: Failed to initialize FileWriter
        print("Failed to initialize FileWriter")
        return }
    
}

func acqlogTargetedFF (filePath: String) {
    let fileWriter = FileWriter(filePath: filePath)
    if let writer = fileWriter {
        writer.write("\n")
        writer.write(String(repeating: "-", count: 88))
        writer.write("\n")
        writer.write("    Targeted Files and Folders Information\n")
        
        // here thrown the list of files and folders selected for the logical image
        
        
        writer.write("\n")
        for file in FileSelectionManager.shared.selectedFiFo {
            writer.write(String(file.path)+"\n")
            
        }
        writer.write(String(repeating: "=", count: 88))
    }
        else {
        // Handle error: Failed to initialize FileWriter
        print("Failed to initialize FileWriter")
        return }
    
}

func acqlogConv2Sparse (filePath: String) {
    let fileWriter = FileWriter(filePath: filePath)
    if let writer = fileWriter {
        writer.write("\n")
        writer.write(String(repeating: "-", count: 88))
        writer.write("\n")
        writer.write("    Sparse Information\n")
 
        writer.write("\n")
        for file in FileSelectionManager.shared.selectedFiles {
            writer.write("\(String(file.path)) -> size: \(file.size) \n")
            writer.write("    Sparse Attributes\n")
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: file.path)
//                print("Basic File Attributes:")
                for (key, value) in attributes {
                    writer.write ("     \(key.rawValue): \(value)\n")
                }
            } catch {
                print("Error retrieving file attributes: \(error)")
            }
            
        }
        writer.write(String(repeating: "=", count: 88))
    }
        else {
        // Handle error: Failed to initialize FileWriter
        print("Failed to initialize FileWriter")
        return }
    
}


func formatOutput4Tgt(string: String, number: Int64) -> String {
    let formattedNumber = "\(number / 1000) MB"
    var result = ""
    var startIndex = string.startIndex

    while startIndex < string.endIndex {
        let endIndex = string.index(startIndex, offsetBy: 60, limitedBy: string.endIndex) ?? string.endIndex
        let line = String(string[startIndex..<endIndex])
        
        if endIndex >= string.endIndex {
            result += line.padding(toLength: 60, withPad: " ", startingAt: 0) + "     " + formattedNumber + "\n"
        } else {
            result += line + "\n"
        }

        startIndex = endIndex
    }

    return result
}


func acqSparselog(filePath: String) {
    let fileWriter = FileWriter(filePath: filePath)
    if let writer = fileWriter {
        writer.write("\n")
        writer.write(String(repeating: "-", count: 88))
        writer.write("\n")
        writer.write("    Image Information\n")
        writer.write("        Sparse Image Name:           \(CaseInfoData.shared.imageName)\n")
        writer.write("        Sparse Image Start Time:     \(LLTimeManager.getCurrentTimeString())\n")

        
    }
    
}

func print2Log(filePath: String, text2p: String) {
    let fileWriter = FileWriter(filePath: filePath)
    if let writer = fileWriter {
        writer.write("\n")
        writer.write(text2p)
        
    }
}
    
func extractData(from text: String) -> [String: Int64] {
    let patterns = [
        "Disk Size:.*?(\\d+) Bytes",
        "Container Total Space:.*?(\\d+) Bytes",
        "Container Free Space:.*?(\\d+) Bytes"
    ]

    var results = [String: Int64]()
    print("inside extractData")
    let logfilePath = DiskDataManager.shared.selectedStorageOption + "/\(CaseInfoData.shared.imageName).info"
    print2Log(filePath: logfilePath, text2p: "inside func extracData for log")
    for pattern in patterns {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
//        print("matches: \(matches.count)")
        for match in matches {
            let range = match.range(at: 1) // The first captured group
            if let swiftRange = Range(range, in: text) {
                let matchedString = String(text[swiftRange])
                if let number = Int64(matchedString) {
                    let key = pattern.components(separatedBy: ":")[0]
//                    print("key inside result: \(key)")
                    results[key] = number
                }
            }
        }
    }

    return results
}

import Foundation
import CoreServices

func extractFileMetadata(at path: String) {
    let fileURL = URL(fileURLWithPath: path)

    // Getting basic file attributes using FileManager
    do {
        let attributes = try FileManager.default.attributesOfItem(atPath: path)
        print("Basic File Attributes:")
        for (key, value) in attributes {
            print("\(key.rawValue): \(value)")
        }
    } catch {
        print("Error retrieving file attributes: \(error)")
    }

    // Using MDItem for more extensive metadata
    if let mdItem = MDItemCreate(kCFAllocatorDefault, (fileURL as CFURL as! CFString)) {
        print("\nExtended Metadata:")
        if let attributeNames = MDItemCopyAttributeNames(mdItem) as? [String] {
            for attributeName in attributeNames {
                if let attributeValue = MDItemCopyAttribute(mdItem, attributeName as CFString) {
                    print("\(attributeName): \(attributeValue)")
                }
            }
        }
    } else {
        print("Could not retrieve extended metadata.")
    }
}

// Example usage
//extractFileMetadata(at: "/Volumes/data/filename.name")


func diskCapacity (dataRead: [String: Int64]) -> [String: Int64] {
    var resultsDictionary = [String: Int64]()
//    let extractedData = extractData(from: dataRead)
//    print("in disk capacity")
    if let diskSize = dataRead["Disk Size"] {
        resultsDictionary["Disk Size"] = diskSize
    }
    if let totalSpace = dataRead["Container Total Space"] {
        resultsDictionary["Container Total Space"] = totalSpace
    }
    if let freeSpace = dataRead["Container Free Space"] {
        resultsDictionary["Container Free Space"] = freeSpace
    }
    return resultsDictionary
}
    

func getRootFileSystemDiskID() -> String? {
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/bin/df")
    process.arguments = ["/"]
    process.standardOutput = pipe

    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        return parseDiskID(from: output)
    } catch {
        print("error in func getRootFileSystemDiskID: \(error)")
        print("Called with no parameter")
        return nil
    }
}

func parseDiskID(from output: String?) -> String? {
    guard let output = output else { return nil }

    // Split the output into lines
    let lines = output.components(separatedBy: "\n")
    
    // Skip the first line (header) and process the next line
    if lines.count > 1 {
        let components = lines[1].components(separatedBy: " ")
        let filteredComponents = components.filter { !$0.isEmpty }
        if !filteredComponents.isEmpty {
            return filteredComponents[0] // The first component is the disk identifier
        }
    }

    return nil
}

func convertSizeStringToDouble(_ str: String) -> Double {
    let filteredString = str.filter { "0123456789.".contains($0) }
    return Double(filteredString) ?? 0.0
}

func getRootFileSystemDiskDetails() -> (diskID: String?, capacity: String?, availableSpace: String?) {
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/bin/df")
    process.arguments = ["-H", "/"]  // '-H' uses human-readable format
    process.standardOutput = pipe

    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        return parseDiskDetails(from: output)
    } catch {
        print("error in func getRootFileSystemDiskDetails: \(error)")
        print("Called with no parameter")
        return (nil, nil, nil)
    }
}


func getDiskIDCapacityAvSpace(diskPath: String) -> (diskID: String?, capacity: String?, availableSpace: String?) {
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/bin/df")
    process.arguments = ["-H", diskPath]  // '-H' uses human-readable format
    process.standardOutput = pipe

    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        return parseDiskDetails(from: output)
    } catch {
        print("error in func getDiskIDCapacityAvSpace: \(error)")
        print("Called with parameter diskpath = \(diskPath)")
        return (nil, nil, nil)
    }
}


func parseDiskDetails(from output: String?) -> (diskID: String?, capacity: String?, availableSpace: String?) {
    guard let output = output else { return (nil, nil, nil) }

    let lines = output.components(separatedBy: "\n")
    if lines.count > 1 {
        let components = lines[1].split(whereSeparator: \.isWhitespace).map(String.init)
        if components.count >= 4 {
//            let diskID = components[0]
            let diskID = components[0].replacingOccurrences(of: "/dev/", with: "")
            let capacity = components[1]
            let availableSpace = components[3]
            return (diskID, capacity, availableSpace)
        }
    }

    return (nil, nil, nil)
}


func getVolumeCapacityDetails(volumePath: String) -> (totalCapacity: String?, availableCapacity: String?) {
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/bin/df")
    process.arguments = ["-H", volumePath]  // '-H' for human-readable format
    process.standardOutput = pipe

    do {
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        return parseVolumeCapacity(from: output)
    } catch {
        print("error in func getVolumeCapacityDetails: \(error)")
        print("called with parameter: \(volumePath)")
        return (nil, nil)
    }
}

func parseVolumeCapacity(from output: String?) -> (totalCapacity: String?, availableCapacity: String?) {
    guard let output = output else { return (nil, nil) }

    let lines = output.components(separatedBy: "\n")
    if lines.count > 1 {
        let components = lines[1].split(whereSeparator: \.isWhitespace).map(String.init)
        if components.count >= 4 {
            let totalCapacity = components[1]
            let availableCapacity = components[3]
            return (totalCapacity, availableCapacity)
        }
    }

    return (nil, nil)
}



func copyTargeted2 (srcPaths: [String], destPath: String) {
    print("inside copyTargeted, copying to: \(destPath)")
    print("srcPaths: \(srcPaths)")
    let destinationPath = "/Volumes/test05b"
    
//    if !FileManager.default.fileExists(atPath: destinationPath) {
//        do {
//            try FileManager.default.createDirectory(atPath: destinationPath, withIntermediateDirectories: true)
//        } catch {
//            print("Error creating destination directory: \(error.localizedDescription)")
//            exit(1)
//        }
//    }
    
    for src in srcPaths {
        copyItem(atPath: src, toPath: destinationPath)
        
//        let dst = (destinationPath as NSString).appendingPathComponent((src as NSString).lastPathComponent)
//        if FileManager.default.isReadableFile(atPath: src) {
//            if FileManager.default.fileExists(atPath: src, isDirectory: nil) {
//                copyDirectoryContents(atPath: src, toPath: dst)
//            } else {
//                copyItem(atPath: src, toPath: dst)
//                print("copied: \(src)")
//            }
//        } else {
//            print("No read permission for \(src)")
//        }
//
    }
    
}


// Function to copy a file or directory, including hidden files and preserving extended attributes
func copyItem(atPath srcPath: String, toPath dstPath: String) {
    let process = Process()
    process.launchPath = "/bin/cp"
    process.arguments = ["-a", srcPath, dstPath]
    print("cmd in func copyItem: cp -a \(srcPath) \(dstPath)")
    process.launch()
    process.waitUntilExit()

    let status = process.terminationStatus
    if status == 0 {
        print("Copied \(srcPath) to \(dstPath)")
    } else {
        print("Failed to copy \(srcPath). Exit code: \(status)")
    }
}

let forbiddenCharacters = CharacterSet(charactersIn: "!@#$%^&*/\\|")

func containsForbiddenCharacters(_ text: String) -> Bool {
        let range = NSRange(location: 0, length: text.utf16.count)
        return (text as NSString).rangeOfCharacter(from: forbiddenCharacters, options: [], range: range).location != NSNotFound
    }

func validateInput(name: String) -> Bool {
    if name.isEmpty || containsForbiddenCharacters(name) {
        // Handle validation failure (e.g., show an alert or mark the field)
        return false
    } else {
        // Handle valid input
        return true
    }
}

func validatePath(path: String) -> Bool {
    let fileManager = FileManager.default
        
        // Check if the path exists and is a directory
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        
        if exists && isDirectory.boolValue {
            // The path exists and is a directory, now check if it's writable
            let isWritable = fileManager.isWritableFile(atPath: path)
            return isWritable
        }
        
        return false
}

func isDestinationInRoot(path: String) -> Bool {
    if path.contains("/Volumes")  {
          return false
        }
    else {
        return true
    }
}

func isImageNameAtPath(path: String) -> Bool {
    let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
}
