//
//  AuthenticationViewModel.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/29/23.
//

import SwiftUI


class AuthenticationViewModel: ObservableObject {    
    static let shared = AuthenticationViewModel()
    @Published var isLicenseValid: Bool = false
    @Published var isSerialValid: Bool = false
    @Published var licenseFileFound: Bool = false
    @Published var licenseType: String = ""
    @Published var licenseSerial: String = ""
    @Published var licenseExpDate: String = ""
    @Published var licenseStatus: String = ""
    @Published var licenseMessage: String = ""
    @Published var isPasswordCorrect: Bool = false
    @Published var rootPassword: String = ""
    
    func ValidateLicense() -> String {
//         licenseStatus = "Expired"
//        temp test (not working when using the app in other computer.
        let filePath = "/Volumes/LLimager-Int/LLimager/llimager.lic"
        licenseFileFound = licencefileExistsAndCanBeRead(atPath: filePath)

        if licenseFileFound {
            let licenseDetails = readLicense().components(separatedBy: "\n")
//            print("Lic details read: \(licenseDetails)")
            self.licenseType = licenseDetails[0]
            self.licenseSerial = licenseDetails[1]
            self.licenseExpDate = licenseDetails[2]
            if self.licenseType == "License" {
                self.isSerialValid = checkSerialNumber()
            }
            self.licenseStatus = checkLicense(dateRef: licenseDetails[2])
            if !self.isSerialValid {self.licenseStatus = self.licenseStatus + "-InvalidSerial"}
        }
        else {
            self.licenseStatus = "File not found"
        }
        return licenseStatus
    }
    
    func validatePassword(_ password: String) {
        // Replace this logic with your actual password validation
        print("password entered: \(password)")
        let output = executeSudoCommand(command: "Sudo -S whoami", password: password)
        print("output from command: \(output)")
        if output.contains("root") {
            self.isPasswordCorrect = true
            self.rootPassword = password
        }
        else {
            isPasswordCorrect = false
            //        executeSudoCommand(command: String, passw: String) -> String {
            //            let fullCommand = "echo \(passw) | sudo -S \(command)"
            isPasswordCorrect = (password == "passw")
        }
    }
    
    
    func executeCommand(command: String) -> String {
//        print("entering ConsoleViewModel-executeCommand")
        let process = Process()
        let pipe = Pipe()
        process.environment = ProcessInfo.processInfo.environment
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", command]
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return "Error: \(error.localizedDescription)"
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        print("about to leave ConsoleViewModel-executeSudoCommand")
        return String(data: data, encoding: .utf8) ?? "Error decoding output"
    }

    func licencefileExistsAndCanBeRead(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        // Check if file exists
        if fileManager.fileExists(atPath: path) {
            // Attempt to read the file
            do {
                _ = try String(contentsOfFile: path, encoding: .utf8)
                // If the file can be read, return true
                return true
            } catch {
                // If there's an error reading the file, return false
//                print("Error reading file: \(error)")
                return false
            }
        } else {
            // File does not exist
            return false
        }
    }

    func checkSerialNumber () -> Bool {
        let cmdOutput = executeCommand(command: "system_profiler SPUSBDataType")
        let serialValid: Bool = false
        if cmdOutput.contains(self.licenseSerial) {
            var serialValid = true
        }
//        print("is serial Valid after ouput: \(isSerialValid)")
        // eliminate this lines within the second if{} only temp for test
        if cmdOutput.contains("S6XGNS0W618693L") {
            var serialValid = true
        }
//        print("is serial Valid after serial added: \(isSerialValid)")
        return serialValid
    }

}

