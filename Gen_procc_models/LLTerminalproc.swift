//
//  TestTerminalConnec.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/8/23.
//

import Foundation
import Combine

class ConsoleViewModel: ObservableObject {
    @Published var output: String = ""
    private var process: Process?
    private var processDMG: Process?
    @Published var isMonitoringActive: Bool = false
    @Published var progress: Float = 0.0
    @Published var progressDMG: Float = 0.0
    var secondStream = false
    
    
    func executeSudoCommand(command: String, passw: String) -> String {
        print("entering ConsoleViewModel-executeSudoCommand")
        let fullCommand = "echo \(passw) | sudo -S \(command)"
        let process = Process()
        let pipe = Pipe()
        process.environment = ProcessInfo.processInfo.environment
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", fullCommand]
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return "Error: \(error.localizedDescription)"
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        print("about to leave ConsoleViewModel-executeSudoCommand")
        return String(data: data, encoding: .utf8) ?? "Error decoding output"
    }
    
    
    
    func executeSudoCommand2(command: String, passw: String)  // -> String
    {
        let fullCommand = "echo \(passw) | sudo -S \(command)"
        let process = Process()
        let pipe = Pipe()
        //            let streamViewModel=StreamViewModel()
        process.environment = ProcessInfo.processInfo.environment
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", fullCommand]
        process.standardOutput = pipe
        process.standardError = pipe
        
        _ = DispatchQueue(label: "outputQueue")
        self.output = ""
        
        pipe.fileHandleForReading.readabilityHandler = { fileHandle in
            let data = fileHandle.availableData
            if let str = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.output += str
//                    self.processStreamText(str)
                    
                }
            }
        }
        
        do {
            try process.run()
        } catch {
            print("Error: \(error.localizedDescription)")
            // Handle the error case appropriately
        }
        
        // Run an event loop to prevent the main thread from exiting
        let runLoop = RunLoop.current
        while process.isRunning {
            runLoop.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
        }
        
        pipe.fileHandleForReading.readabilityHandler = nil
        print("leaving sudoprocc2 (sparse)")
    }
    
    
    func executeSudoCommand3(command: String, passw: String)  // -> String
    {
        print("in sudoCmd3... CMD: \(command)")
        let fullCommand = "echo \(passw) | sudo -S \(command)"
        let process = Process()
        let pipe = Pipe()
        process.environment = ProcessInfo.processInfo.environment
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", fullCommand]
        process.standardOutput = pipe
        process.standardError = pipe
        
        _ = DispatchQueue(label: "outputQueue")
        self.output = ""
        self.isMonitoringActive = true
        
        pipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            guard let self = self, self.isMonitoringActive else { return }
            
            let data = fileHandle.availableData
            if let str = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.output += str
//                    self.progressDMG = Float(self.calcProgressDMG())
//                    print("progress DMG 2 of 2 \(self.progressDMG)")
//                    print("monitoring is active \(self.isMonitoringActive)")
                    
                    
                }
            }
        }
        
        do {
            try process.run()
        } catch {
            print("Error: \(error.localizedDescription)")
            // Handle the error case appropriately
        }
        
        // Run an event loop to prevent the main thread from exiting
        let runLoop = RunLoop.current
        while process.isRunning {
            runLoop.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
        }
        
        pipe.fileHandleForReading.readabilityHandler = nil
        print("leaving sudoprocc3 (dmg)")
//        print2Log(filePath: logfilePathEx, text2p: output)
    }
    
    func calcProgressDMG () -> Double {      
        let sparseRef = FileSizeChecker.shared.fileSizeInGB * 0.8
        print("sparse ref size \(sparseRef)")
        if sparseRef > 0 {
            let dmgSizeProg = 100 * FileSizeChecker2.shared.fileSizeInGB / sparseRef
            print("dmg size in FileSizeChecker2 so far \(FileSizeChecker2.shared.fileSizeInGB)")
            print("dmg size progress \(dmgSizeProg)")
            if dmgSizeProg <= 70 {
                print("return if from calProgressDMG when <= 70 \(dmgSizeProg)")
                return dmgSizeProg
            }
            else {print("return else from calProgressDMG when > 70 \(dmgSizeProg)")
                return max(90,dmgSizeProg)
            }
        }
        return 27
    }
    
    
    func processStreamText(_ text: String) {
        for n in 1...10 {
            let targetString = "\(n)0"
            if text.contains("."){break}
            if text == targetString {
                self.progress += self.secondStream ? 9.0 : 1.0
                print("progress counter \(self.progress)")
                if text == "100" {
                    self.secondStream = true  // Switch to second round after reaching "100"
                    print("switching to second round")
                }
                break
            }
        }
    }
}

    
    
    class StreamViewModel: ObservableObject {
        @Published var progress: Float = 0.0
        var secondStream = false
        
        
        func processStreamText(_ text: String) {
            //        if text.count == 1 || text.count > 3 {
            //            //        print("Text length is either 1 or greater than 3. Exiting function.")
            //            return // Exit the function
            //        }
            for n in 1...10 {
                let targetString = "\(n)0"
                print("tgt: " + targetString)
                print("input text: " + text)
                if text.contains("."){break}
                if text == targetString {
                    self.progress += self.secondStream ? 9.0 : 1.0
                    print("progress counter \(self.progress)")
                    if text == "100" {
                        self.secondStream = true  // Switch to second round after reaching "100"
                        print("switching to second round")
                    }
                    break
                }
            }
        }
        
        
        func calcProgressDMG () -> Double {
            
            let sparseRef = FileSizeChecker.shared.fileSizeInGB * 0.8
            print("sparse ref size \(sparseRef)")
            let dmgSizeProg = 100 * FileSizeChecker2.shared.fileSizeInGB / sparseRef
            print("dmg size so far \(FileSizeChecker2.shared.fileSizeInGB)")
            print("dmg size progress \(dmgSizeProg)")
            if dmgSizeProg <= 70 {
                return dmgSizeProg}
            else {return max(90,dmgSizeProg)
            }
        }
    }
    
    
    
    class FileSizeChecker: ObservableObject {
        static let shared = FileSizeChecker()
        @Published var fileSizeInGB: Double = 0.0
        private var timer: Timer?
        var filePath: String?
        
        func startMonitoring() {
            guard let filePath = filePath else {
                print("File path not set")
                return
            }
            
            timer?.invalidate()  // Stop any existing timer
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
                self?.updateFileSize()
            }
        }
        
        func stopMonitoring() {
            timer?.invalidate()
        }
        
        private func updateFileSize() {
            guard let filePath = filePath else {
                return
            }
            
            let fileManager = FileManager.default
            do {
                let attributes = try fileManager.attributesOfItem(atPath: filePath)
                if let fileSize = attributes[.size] as? Int64 {
                    // Convert file size to GB
                    let fileSizeInGB = Double(fileSize) / 1_000_000_000
                    DispatchQueue.main.async {
                        self.fileSizeInGB = fileSizeInGB
                    }
                }
            } catch {
                print("Error getting file size: \(error)")
            }
        }
    }
    
    class FileSizeChecker2: ObservableObject {
        static let shared = FileSizeChecker2()
        @Published var fileSizeInGB: Double = 0.0
        private var timer: Timer?
        var filePath: String?
        
        func startMonitoring() {
            guard let filePath = filePath else {
                print("File path not set")
                return
            }
            
            timer?.invalidate()  // Stop any existing timer
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
                self?.updateFileSize()
            }
        }
        
        func stopMonitoring() {
            timer?.invalidate()
        }
        
        private func updateFileSize() {
            guard let filePath = filePath else {
                return
            }
            
            let fileManager = FileManager.default
            do {
                let attributes = try fileManager.attributesOfItem(atPath: filePath)
                if let fileSize = attributes[.size] as? Int64 {
                    // Convert file size to GB
                    let fileSizeInGB = Double(fileSize) / 1_000_000_000
                    FileSizeChecker2.shared.fileSizeInGB = fileSizeInGB
                    print("fileSizeinGB within updateFSize: \(fileSizeInGB) just before entering DispatchQueque")
                    DispatchQueue.main.async {
                        self.fileSizeInGB = fileSizeInGB
                        print("in FileSizeChecker2 size DMG \(fileSizeInGB)")
                        FileSizeChecker2.shared.fileSizeInGB = fileSizeInGB
                        print("after copying size in FileSizeChecker2 \(FileSizeChecker2.shared.fileSizeInGB)")
                    }
                }
            } catch {
                print("Error getting file size: \(error)")
            }
        }
    }
 
class FileSizeChecker3: ObservableObject {
    static let shared = FileSizeChecker3()
    @Published var fileSizeInGB: Double = 0.0
    var totalSizeInGB: Double = 0.0
    @Published var pctAdvance: Double = 0.0
    private var timer: Timer?
    var filePath: String?
    
    func startMonitoring() {
        guard let filePath = filePath else {
            print("File path not set")
            // total disk size here to be used in pct advance calcs
            let sourceDisk = "/dev/" + (extractusedDisk(from: DiskDataManager.shared.selectedDskOption) ?? "/")
            if let totalCapacity = getAnyDiskInfo(dskpath: sourceDisk)?.totalCapacity {
                let totalSizeInGB = totalCapacity / 1_000_000_000
                print("Total capacity: \(totalCapacity)")
                print("Total source in GB: \(totalSizeInGB)")
            }
            return
        }
        
        timer?.invalidate()  // Stop any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            self?.updateFileSize()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
    }
    
    
    private func updateFileSize() {
        guard let filePath = filePath else {
            return
        }
        
        let fileManager = FileManager.default
//        print(" in filesizechk3 filepath: \(filePath)")
        do {
            let attributes = try fileManager.attributesOfItem(atPath: filePath)
            if let fileSize = attributes[.size] as? Int64 {
                // Convert file size to GB
                let fileSizeInGB = Double(fileSize) / 1_000_000_000
                let pctAdvanceImgDev = fileSizeInGB / FileSizeChecker3.shared.totalSizeInGB
                print("inside filechk3 totalSizeinGB: \(totalSizeInGB)")
                print("inside filechk3 FileSizeChecker3.shared.totalSizeInGB: \(FileSizeChecker3.shared.totalSizeInGB)")
                print("inside filechk3 percenAdvance: \(pctAdvanceImgDev)")
                DispatchQueue.main.async {
                    self.fileSizeInGB = fileSizeInGB
                    self.pctAdvance = pctAdvanceImgDev
                }
            }
        } catch {
            print("Error getting file size: \(error)")
        }
    }
}


class TimerHash: ObservableObject {
    @Published var timeElapsedFormatted = "00:00:00"
    private var secondsElapsed = 0
    var timer: Timer?

    func start() {
        timer?.invalidate() // Invalidate any existing timer
        secondsElapsed = 0 // Reset the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.secondsElapsed += 1
                self?.timeElapsedFormatted = self?.formatElapsedTime() ?? "00:00:00"
            }
        }
    }

    func stop() {
        timer?.invalidate()
    }

    private func formatElapsedTime() -> String {
        let hours = secondsElapsed / 3600
        let minutes = (secondsElapsed % 3600) / 60
        let seconds = secondsElapsed % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}



    class ElapsedTimeTimer: ObservableObject {
        @Published var elapsedTimeString: String = "00:00:00"
        private var timer: Timer?
        private var startTime: Date?
        
//        timer?.invalidate() // Invalidate any existing timer
//                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//                    DispatchQueue.main.async {
//                        self?.secondsElapsed += 1
        func startTimer() {
            startTime = Date()
            timer?.invalidate()  // Stop any existing timer
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self, let startTime = self.startTime else { return }
                let elapsedTime = Date().timeIntervalSince(startTime)
                self.elapsedTimeString = self.formatElapsedTime(elapsedTime)
            }
        }
        
        func stopTimer() {
            timer?.invalidate()
        }
        
        func resetTimer() {
            timer = nil
            startTime = nil
            elapsedTimeString = "00:00:00"
        }
        
        private func formatElapsedTime(_ seconds: TimeInterval) -> String {
            let hours = Int(seconds) / 3600
            let minutes = Int(seconds) / 60 % 60
            let seconds = Int(seconds) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }

    }
    
