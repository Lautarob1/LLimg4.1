//
//  LLData.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/30/23.
//

import Foundation

class DiskDataManager: ObservableObject {
    static let shared = DiskDataManager()
    @Published var dskData: [(num: String, type: String, name: String, size: String, ident: String, extract: String, mtPt: String)] = []
    @Published var comboInfo: [String] = []
    @Published var selectedDskOrigen: String
    @Published var selectedStorageDestin: String = ""
    @Published var selected2ndStorageDestin: String = ""
    @Published var selectedHashOption: String = "SHA256"
    @Published var isComboDisabled: Bool = true
    
    init() {        //}
        self.selectedDskOrigen = "synthesized disk1s1s1 10.1 GB"// getRootFileSystemDiskID() ?? "/"
        loadDiskData()
    }

    private func loadDiskData() {
        let lines = loadDiskInfo()
        let processedData = processDskInfo(lines)
        self.dskData = processedData.diskInfo
        self.comboInfo = processedData.comboInfo
    // review force unwrap 
        self.selectedDskOrigen = self.comboInfo.first!
    }

    func findMtPtByIdent(ident: String) -> String? {
        // Use 'first(where:)' to find the tuple where 'ident' matches the parameter
        print("in indMtPtByIdent, ident = \(ident)")
        print("dskData.first = \(dskData.first)")
        print("dskData.first \(dskData.first(where: { $0.ident == ident }))")
        if let item = dskData.first(where: { $0.ident == ident }) {
            print("dskData.first inside if = \(dskData.first)")
            // If found, return the 'mtPt' value
            return item.mtPt
        } else {
            // If not found, return nil
            print("mtPt not found, returning root and not nil")
            return "/"
//            return nil
        }
    }
    
    func findSizeByIdent(ident: String) -> String? {
        // Use 'first(where:)' to find the tuple where 'ident' matches the parameter
        print("in fileSizebyIdent, ident = \(ident)")
        print("dskData.first \(dskData.first)")
        print("dskData.first \(dskData.first(where: { $0.ident == ident }))")
        if let item = dskData.first(where: { $0.ident == ident }) {
            // If found, return the 'mtPt' value
            return item.size
        } else {
            // If not found, return nil
            print("size not found, returning 500G and not nil")
            return "500G"
//            return nil
        }
    }

}



class FileWriter {
    private let fileHandle: FileHandle?
    private let filePath: URL

    init?(filePath: String) {
        let fileURL = URL(fileURLWithPath: filePath)
        self.filePath = fileURL

        if FileManager.default.fileExists(atPath: filePath) {
            do {
                fileHandle = try FileHandle(forWritingTo: fileURL)
            } catch {
                print("Failed to open file handle: \(error)")
                return nil
            }
        } else {
            FileManager.default.createFile(atPath: filePath, contents: nil)
            fileHandle = FileHandle(forWritingAtPath: filePath)
        }
    }

    func write(_ content: String) {
        guard let fileHandle = fileHandle, let data = content.data(using: .utf8) else { return }
        
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    }

    deinit {
        fileHandle?.closeFile()
    }
}



class FileWriterWithDelection {
    private var fileHandle: FileHandle?
    private let filePath: URL

    init?(filePath: String) {
        let fileURL = URL(fileURLWithPath: filePath)
        self.filePath = fileURL

        let fileManager = FileManager.default

        // Check if the file exists
        if fileManager.fileExists(atPath: filePath) {
            do {
                // Delete the existing file
                try fileManager.removeItem(at: fileURL)
                
                // Create a new file
                fileManager.createFile(atPath: filePath, contents: nil)
                
                // Open a file handle for writing
                guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
                    print("Failed to open file handle for a new file")
                    return nil
                }
                self.fileHandle = fileHandle
            } catch {
                print("Failed to delete or open file handle: \(error)")
                return nil
            }
        } else {
            // If the file does not exist, create it and open a file handle
            fileManager.createFile(atPath: filePath, contents: nil)
            guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
                print("Failed to open file handle for a new file")
                return nil
            }
            self.fileHandle = fileHandle
        }
    }

    // Make sure to add functions to write data and close the file handle appropriately
    func write(data: Data) {
        fileHandle?.write(data)
    }
    
    func close() {
        fileHandle?.closeFile()
    }
}


class FileDelete {
    static func deleteIfExists(filePath: String) {
        let fileURL = URL(fileURLWithPath: filePath)
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(at: fileURL)
                print("File successfully deleted.")
            } catch {
                print("Failed to delete file: \(error)")
            }
        } else {
            print("File does not exist from FileDelete func (no file to delete).")
        }
    }
}


class FileWriterSF {                // For writting from several views in a sync manner
    private let fileHandle: FileHandle?
    private let filePath: URL
    private let queue = DispatchQueue(label: "fileWriterQueue")

    static let shared = FileWriter(filePath: "path/to/your/file.txt")

    private init?(filePath: String) {
        let fileURL = URL(fileURLWithPath: filePath)
        self.filePath = fileURL

        if FileManager.default.fileExists(atPath: filePath) {
            do {
                fileHandle = try FileHandle(forWritingTo: fileURL)
            } catch {
                print("Failed to open file handle: \(error)")
                return nil
            }
        } else {
            FileManager.default.createFile(atPath: filePath, contents: nil)
            fileHandle = FileHandle(forWritingAtPath: filePath)
        }
    }

    func write(_ content: String) {
        queue.async {
            guard let fileHandle = self.fileHandle, let data = content.data(using: .utf8) else { return }
            
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
        }
    }

    deinit {
        fileHandle?.closeFile()
    }
}

class CaseInfoData: ObservableObject {
    static let shared = CaseInfoData()
    @Published var caseName: String = "Case Name"
    @Published var evidenceName: String = "Evidence"
    @Published var agentName: String = "Agent"
    @Published var caseID: String = "Case ID"
    @Published var caseNotes: String = ""
    @Published var imageName: String = ""
    @Published var imgfilePath: String = ""
    @Published var isdmgdifPath: Bool = true
    @Published var dmgfilePath: String = ""
    @Published var isdmgEnabled: Bool = true

    private init() {}
       }
    
class deviceInfoData: ObservableObject {
    static let shared = deviceInfoData()
    @Published var devSerial: String = ""
    @Published var devName: String = ""
    @Published var devIdent: String = ""
    @Published var devMemory: String = ""
    @Published var devhardUUID: String = ""

    private init() {}

       }
 

class LLTimeManager {
    static func getCurrentTimeStringnd() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium  // You can adjust the style as needed
        return formatter.string(from: Date())
    }
    
    static func getCurrentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // Custom format string
        return formatter.string(from: Date())
    }
}


struct FileItem: Identifiable, Hashable {
    let id = UUID()
    let path: String
    let size: Int64
}

struct FileFolderItem: Identifiable, Hashable {
    let id = UUID()
    let path: String
}


class FileSelectionManager: ObservableObject {
    static let shared =  FileSelectionManager()
    @Published var exceedTimeLimit: Bool = false
    @Published var selectedFiles: [FileItem] = []
    @Published var selectedFiFo: [FileFolderItem] = []
    @Published var stillWorking: Bool = false

    var totalSize: Int64 {
        selectedFiles.reduce(0) { $0 + $1.size }
    }
    
    func addFile(path: String) {
        calculateSizeAsync(for: path) { size in
            let newItem = FileItem(path: path, size: size)
            DispatchQueue.main.async {
                self.selectedFiles.append(newItem)
            }
        }
    }

    func addFileFolder(path: String) {
            let newItem = FileFolderItem(path: path)
                self.selectedFiFo.append(newItem)
            }

    
    func removeFile(at indexSet: IndexSet) {
        selectedFiles.remove(atOffsets: indexSet)
    }
    
    func removeFileFolder(at indexSet: IndexSet) {
        selectedFiFo.remove(atOffsets: indexSet)
    }
    
    func calculateSizeAsync(for path: String, completion: @escaping (Int64) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let size = self.getFileSize(for: path)
            completion(size)
        }
    }
    
    func getFileSize(for path: String) -> Int64 {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false

        guard fileManager.fileExists(atPath: path, isDirectory: &isDir) else {
            print("File does not exist: \(path)")
            return 0
        }

        if isDir.boolValue {
            // Calculate the total size of the directory
            return directorySize(atPath: path)
        } else {
            // It's a file, get its size
            return fileSize(atPath: path)
        }
    }

    func directorySize(atPath path: String) -> Int64 {
        let fileManager = FileManager.default
        var size: Int64 = 0
        let semaphore = DispatchSemaphore(value: 0)
        let timeout: DispatchTime = .now() + 180

//        if exceedTimeLimit no more calculations will be done
        if !exceedTimeLimit {
        DispatchQueue.global(qos: .background).async {
            do {
                let contents = try fileManager.contentsOfDirectory(atPath: path)
                for content in contents {
                    let fullPath = (path as NSString).appendingPathComponent(content)
                    size += self.getFileSize(for: fullPath)  // Recursive call
                }
            } catch {
                print("Error reading directory contents: \(error)")
            }
            semaphore.signal()
        }

            if semaphore.wait(timeout: timeout) == .timedOut {
                print("Calculation timed out for: \(path)")
                exceedTimeLimit = true
                return 0 // Indicate that the calculation could not be completed
            }
        }

        return size
    }

    func fileSize(atPath path: String) -> Int64 {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path)
            return attr[FileAttributeKey.size] as? Int64 ?? 0
        } catch {
            print("Error getting file size: \(error)")
            return 0
        }
    }

}


class ValidationViewModel: ObservableObject {
    @Published var isnameValid: Bool = false
    @Published var ispathValid: Bool = false
    
    // Computed property to determine if both fields are valid
    var areBothFieldsValid: Bool {
        isnameValid && ispathValid
    }
}
