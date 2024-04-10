//
//  LLhashcal.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/13/24.
//

import Foundation
import CommonCrypto


class HashingViewModel: ObservableObject {
    @Published var hashProgressPct: Double = 0.0
    @Published var hashProgressByt: Double = 0.0
    // Other properties and methods...
}

func calculateMD5Hash(for filePath: String) -> String? {
    guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
        print("Could not read file data")
        return nil
    }

    var md5Digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    fileData.withUnsafeBytes {
        _ = CC_MD5($0.baseAddress, CC_LONG(fileData.count), &md5Digest)
    }

    return md5Digest.map { String(format: "%02hhx", $0) }.joined()
}


func calculateSHA1Hash(for filePath: String) -> String? {
    guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
        print("Could not read file data")
        return nil
    }

    var sha1Digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
    fileData.withUnsafeBytes {
        _ = CC_SHA1($0.baseAddress, CC_LONG(fileData.count), &sha1Digest)
    }

    return sha1Digest.map { String(format: "%02hhx", $0) }.joined()
}



func calculateSHA256Hash(for filePath: String) -> String? {
    guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
        print("Could not read file data")
        return nil
    }

    var sha256Digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    fileData.withUnsafeBytes {
        _ = CC_SHA256($0.baseAddress, CC_LONG(fileData.count), &sha256Digest)
    }

    return sha256Digest.map { String(format: "%02hhx", $0) }.joined()
}

func hashLargeFileMD5(filePath: String) -> String? {
    let bufferSize = 1024 * 1024 // 1 MB
    guard let file = FileHandle(forReadingAtPath: filePath) else { return nil }
    defer { file.closeFile() }

    var context = CC_MD5_CTX()
    CC_MD5_Init(&context)

    while autoreleasepool(invoking: {
        let data = file.readData(ofLength: bufferSize)
        if data.count > 0 {
            data.withUnsafeBytes { buffer in
                _ = CC_MD5_Update(&context, buffer.baseAddress, CC_LONG(data.count))
            }
            return true // Continue
        } else {
            return false // End of file
        }
    }) {}

    var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    digest.withUnsafeMutableBytes { buffer in
        _ = CC_MD5_Final(buffer.bindMemory(to: UInt8.self).baseAddress, &context)
    }

    return digest.map { String(format: "%02hhx", $0) }.joined()
}


func hashLargeFileSHA1(filePath: String) -> String? {
    let bufferSize = 1024 * 1024 // 1 MB
    guard let file = FileHandle(forReadingAtPath: filePath) else { return nil }
    defer { file.closeFile() }

    var context = CC_SHA1_CTX()
    CC_SHA1_Init(&context)

    while autoreleasepool(invoking: {
        let data = file.readData(ofLength: bufferSize)
        if data.count > 0 {
            data.withUnsafeBytes { buffer in
                _ = CC_SHA1_Update(&context, buffer.baseAddress, CC_LONG(data.count))
            }
            return true // Continue
        } else {
            return false // End of file
        }
    }) {}

    var digest = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
    digest.withUnsafeMutableBytes { buffer in
        _ = CC_SHA1_Final(buffer.bindMemory(to: UInt8.self).baseAddress, &context)
    }

    return digest.map { String(format: "%02hhx", $0) }.joined()
}



func hashLargeFileSHA256(filePath: String, viewModel: HashingViewModel) -> String {
    print("entering in hash 256 lg files func...")
    let bufferSize = 1024 * 1024 // 1 MB
    let fileAttributes = try? FileManager.default.attributesOfItem(atPath: filePath)
    let fileSize = fileAttributes?[.size] as? UInt64 ?? 0
    var totalBytesRead: UInt64 = 0
    guard let file = FileHandle(forReadingAtPath: filePath) else { return "no file to process => nulo"}
    defer { file.closeFile() }
    var context = CC_SHA256_CTX()
    CC_SHA256_Init(&context)
    while autoreleasepool(invoking: {
        let data = file.readData(ofLength: bufferSize)
        if data.count > 0 {
            data.withUnsafeBytes { buffer in
                _ = CC_SHA256_Update(&context, buffer.baseAddress, CC_LONG(data.count))
            }
            totalBytesRead += UInt64(data.count)
//            print(Double(totalBytesRead))
            DispatchQueue.main.async {
                viewModel.hashProgressPct = Double(totalBytesRead) / Double(fileSize)
                viewModel.hashProgressByt = Double(totalBytesRead)
            }
            return true // Continue
        } else {
            return false // End of file
        }
    }) {}
    var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
    digest.withUnsafeMutableBytes { buffer in
        _ = CC_SHA256_Final(buffer.bindMemory(to: UInt8.self).baseAddress, &context)
    }
    return digest.map { String(format: "%02hhx", $0) }.joined()
}
import Foundation
import Combine
import CommonCrypto

class HashingViewModel2: ObservableObject {
    @Published var processedBytes: Double = 0
    @Published var elapsedTime: String = "00.00:00"
    @Published var hashResult: String = ""
    @Published var additionalResult: String? = nil // Placeholder for any additional result
    @Published var hashProgressByt: Double = 0
    @Published var hashProgressPct: Double = 0
    @Published var hashProgressNum: Int = 0
    @Published var hashTimeIni: String = "00.00.00"
    @Published var anyprocIsRunning = true
    @Published var showDoneButton = false
    @Published var showProc = false
    @Published var stepIndex = 0
//    var filesinList: Int = FileSelectionManager.shared.selectedFiles.count
//    var filesCounter: Int = 0

    private var hashStartTime: Date?
    private var timer: Timer?
    private var filesCounter: Int = 0
    private var filesinList: Int = FileSelectionManager.shared.selectedFiles.count
    
    func startHashing(filePath: String, hashType: String) {
        hashStartTime = Date()
        hashProgressByt = 0
        hashProgressPct = 0
        elapsedTime = "00.00:00"
        hashResult = ""
        additionalResult = ""
        hashTimeIni = LLTimeManager.getCurrentTimeString()
        
        // Start a timer to update elapsed time
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
        
        self.filesCounter += 1
        
        print("total files before hashlargefile2: \(self.filesinList)")
        print("file count before entering hashlargefile2: \(self.filesCounter)")

        print("hashing entering hashViewModel: \(hashType)")
        switch hashType {
            case "SHA256":
            hashLargeFile2SHA256(filePath: filePath, viewModel: self) { result in
                  DispatchQueue.main.async {
                      self.hashResult = result
                      print("hash result in model: \(self.hashResult)")
                      printHashLog (hashVal: self.hashResult, iniTime: self.hashTimeIni, file: filePath)
                      print("file count inside dispatch: \(self.filesCounter)")
                      print("total files inside dispath: \(self.filesinList)")
                      if self.filesCounter <= self.filesinList {
                          self.anyprocIsRunning = false
                          self.showDoneButton = true
//                          self.stepIndex = 1
                          self.timer?.invalidate()
                          self.timer = nil
                          print("inside proc that set the finals")
                          print("counter >= filesinList")
                      } else
                      {
                          print("counter < filesinList")
                          self.stepIndex = 0
                          self.hashProgressByt = 0
                      }
                      // Optionally update additionalResult or other properties
                      // Invalidate timer as hash process is finished
                  }
              }
            case "SHA1":
            hashLargeFile2SHA1(filePath: filePath, viewModel: self) { result in
                  DispatchQueue.main.async {
                      self.hashResult = result
                      print("hash result in model: \(self.hashResult)")
                      printHashLog (hashVal: self.hashResult, iniTime: self.hashTimeIni, file: filePath)
                      self.anyprocIsRunning = false
                      self.showDoneButton = true
//                      self.stepIndex = 1
                      // Optionally update additionalResult or other properties
                      // Invalidate timer as hash process is finished
                      self.timer?.invalidate()
                      self.timer = nil
                  }
              }
            case "MD5":
            hashLargeFile2MD5(filePath: filePath, viewModel: self) { result in
                  DispatchQueue.main.async {
                      self.hashResult = result
                      print("hash result in model: \(self.hashResult)")
                      printHashLog (hashVal: self.hashResult, iniTime: self.hashTimeIni, file: filePath)
                      self.anyprocIsRunning = false
                      self.showDoneButton = true
//                      self.stepIndex = 1
                      // Optionally update additionalResult or other properties
                      // Invalidate timer as hash process is finished
                      self.timer?.invalidate()
                      self.timer = nil
                  }
              }

            default:
                print("No valid hash designator used")
        }
        

//        print("hash result in return func: \(self.hashResult)")
//        return self.hashResult
    }
    
    private func updateElapsedTime() {
        guard let startTime = hashStartTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        
        // Format elapsed time into a string
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        DispatchQueue.main.async {
            self.elapsedTime = formatter.string(from: elapsed) ?? "00.00:00"
        }
    }
}



func hashLargeFile2SHA256(filePath: String, viewModel: HashingViewModel2, completion: @escaping (String) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
        let bufferSize = 1024 * 1024 // 1 MB
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: filePath)
        let fileSize = fileAttributes?[.size] as? UInt64 ?? 0
//        viewModel.hashProgressByt = 0 this is wrong, must be done inside the main thread
        print("filePath within 256: \(filePath)")
        guard let file = FileHandle(forReadingAtPath: filePath) else {
            DispatchQueue.main.async {
                completion("Failed to open file: \(filePath)")
            }
            viewModel.stepIndex = 2
            return
        }
        
        var context = CC_SHA256_CTX()
        CC_SHA256_Init(&context)
        viewModel.stepIndex = 1
        while autoreleasepool(invoking: {
            let data = file.readData(ofLength: bufferSize)
            if data.count > 0 {
                data.withUnsafeBytes { buffer in
                    _ = CC_SHA256_Update(&context, buffer.baseAddress, CC_LONG(data.count))
                }
                DispatchQueue.main.async {
                    viewModel.hashProgressByt += Double(data.count) / 1000
                    viewModel.hashProgressPct = (viewModel.hashProgressByt * 1000) / Double(fileSize)
                    print("viewModel.hashprogressKB: \(viewModel.hashProgressByt)")
                    print("viewModel.hashprogressPct: \(viewModel.hashProgressPct)")
//                    print("% avance \(viewModel.hashProgressPct)")
//                    print("% time elapsed \(viewModel.elapsedTime)")
                    // Optionally update other ViewModel properties related to progress here
                }
                return true // Continue
            } else {
                return false // End of file
            }
        }) {}
        
        var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        digest.withUnsafeMutableBytes { buffer in
            _ = CC_SHA256_Final(buffer.bindMemory(to: UInt8.self).baseAddress, &context)
        }
        
        let hashString = digest.map { String(format: "%02hhx", $0) }.joined()
        
        DispatchQueue.main.async {
            completion(hashString)
        }
        
        file.closeFile()
    }
}

func hashLargeFile2SHA1(filePath: String, viewModel: HashingViewModel2, completion: @escaping (String) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
        let bufferSize = 1024 * 1024 // 1 MB
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: filePath)
        let fileSize = fileAttributes?[.size] as? UInt64 ?? 0
        print("filePath within SHA1: \(filePath)")
        guard let file = FileHandle(forReadingAtPath: filePath) else {
            DispatchQueue.main.async {
                completion("Failed to open file")
            }
            viewModel.stepIndex = 2
            return
        }
        
        var context = CC_SHA1_CTX()
        CC_SHA1_Init(&context)
        viewModel.stepIndex = 1
        while autoreleasepool(invoking: {
            let data = file.readData(ofLength: bufferSize)
            if data.count > 0 {
                data.withUnsafeBytes { buffer in
                    _ = CC_SHA1_Update(&context, buffer.baseAddress, CC_LONG(data.count))
                }
                DispatchQueue.main.async {
                    viewModel.hashProgressByt += Double(data.count)
                    viewModel.hashProgressPct = viewModel.hashProgressByt / Double(fileSize)
//                    print("% avance \(viewModel.hashProgressPct)")
//                    print("% time elapsed \(viewModel.elapsedTime)")
                    // Optionally update other ViewModel properties related to progress here
                }
                return true // Continue
            } else {
                return false // End of file
            }
        }) {}
        
        var digest = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        digest.withUnsafeMutableBytes { buffer in
            _ = CC_SHA1_Final(buffer.bindMemory(to: UInt8.self).baseAddress, &context)
        }
        
        let hashString = digest.map { String(format: "%02hhx", $0) }.joined()
        
        DispatchQueue.main.async {
            completion(hashString)
        }
        
        file.closeFile()
    }
}

func hashLargeFile2MD5(filePath: String, viewModel: HashingViewModel2, completion: @escaping (String) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
        let bufferSize = 1024 * 1024 // 1 MB
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: filePath)
        let fileSize = fileAttributes?[.size] as? UInt64 ?? 0
        print("filePath: \(filePath)")
        guard let file = FileHandle(forReadingAtPath: filePath) else {
            DispatchQueue.main.async {
                completion("Failed to open file")
            }
            viewModel.stepIndex = 2
            return
        }
        
        var context = CC_MD5_CTX()
        CC_MD5_Init(&context)
        viewModel.stepIndex = 1
        
        while autoreleasepool(invoking: {
            let data = file.readData(ofLength: bufferSize)
            if data.count > 0 {
                data.withUnsafeBytes { buffer in
                    _ = CC_MD5_Update(&context, buffer.baseAddress, CC_LONG(data.count))
                }
                DispatchQueue.main.async {
                    viewModel.hashProgressByt += Double(data.count)
                    viewModel.hashProgressPct = viewModel.hashProgressByt / Double(fileSize)
//                    print("% avance \(viewModel.hashProgressPct)")
//                    print("% time elapsed \(viewModel.elapsedTime)")
                    // Optionally update other ViewModel properties related to progress here
                }
                return true // Continue
            } else {
                return false // End of file
            }
        }) {}
        
        var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        digest.withUnsafeMutableBytes { buffer in
            _ = CC_MD5_Final(buffer.bindMemory(to: UInt8.self).baseAddress, &context)
        }
        
        let hashString = digest.map { String(format: "%02hhx", $0) }.joined()
        
        DispatchQueue.main.async {
            completion(hashString)
        }
        
        file.closeFile()
    }
}

func printHashLog (hashVal: String, iniTime: String, file: String) {
    let logfilePath = DiskDataManager.shared.selectedStorageDestin + "/\(CaseInfoData.shared.imageName).info"
    let file = file
    let hashTimeIni = iniTime
    let hashLength = hashVal.utf8.count
    print("hashLength: \(hashLength)")
    var hashType = ""
    switch hashLength {
        case 64:
            hashType = "SHA256 hash:"
            print("hash type in switch: \(hashType)")
        case 40:
            hashType = "SHA1 hash:  "
        case 32:
            hashType = "MD5 hash:   "
        default:
            print("The string has an unexpected length of \(hashLength) bytes.")
    }
    let hashTimeEnd = LLTimeManager.getCurrentTimeString()
    print2Log(filePath: logfilePath, text2p: "Hashing file:     \(file ?? "check logfile-path")")
    //                print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88)))\n")
    print2Log(filePath: logfilePath, text2p: "Start time:       \(hashTimeIni)")
    print2Log(filePath: logfilePath, text2p: "End time:         \(hashTimeEnd)")
//    print("hash type just above it print line: \(hashType)")
    print2Log(filePath: logfilePath, text2p: "\(hashType)      \(hashVal)")
    print2Log(filePath: logfilePath, text2p: "\(String(repeating: "-", count: 88))\n")
}
