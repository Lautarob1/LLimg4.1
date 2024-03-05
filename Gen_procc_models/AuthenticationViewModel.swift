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
        let filePath = "/Volumes/LLimager-int/LLimager/llimager.lic"
        licenseFileFound = licencefileExistsAndCanBeRead(atPath: filePath)
        if licenseFileFound {
            let licenseDetails = readLicense().components(separatedBy: "\n")
            self.licenseType = licenseDetails[0]
            self.licenseSerial = licenseDetails[1]
            self.licenseExpDate = licenseDetails[2]
            self.licenseStatus = checkLicense(dateRef: licenseDetails[2])        }
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


}

