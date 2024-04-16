//
//  LLimg_sw01App.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/26/23.
//

import SwiftUI

@main
struct LLimg_sw01App: App {
    @ObservedObject private var authModel = AuthenticationViewModel()
    @State private var showingAlert = false
    @State private var checkLicense = false
    var body: some Scene {
        WindowGroup {
            VStack (spacing: 0) {
                HeaderView()
                VStack {
                    if checkLicense {
                        if authModel.isPasswordCorrect {
                            // Show MenuView only if the password is correct and lic not expired
                            MenuView(authModel: AuthenticationViewModel())
                                .frame(minWidth: 900)
                        } else {
                            // Otherwise, show CheckPasswordView
                            CheckPasswordView(authModel: authModel, isPasswordFocused11: true)
                        }
                    } else {
                        // Setting the state to show alert
                        Text("Verifiyng License...")
                            .onAppear {
                                let status = authModel.ValidateLicense()
                                //                            print("result of ValidateLicense: \(status)")
                                if status == "Expired" || status == "File not found" || status.contains("InvalidSerial") {
                                    print("status of license: \(status)")
                                    authModel.isLicenseValid = false
                                } else {
                                    // Activate (to true) for triggering the app verif logic and quit if the license is expiered
                                    authModel.isLicenseValid = true
                                    //                                            showingAlert = true
                                }
                                checkLicense = true
                                // eliminate the line below in production (it makes the license always valid)
//                                authModel.isLicenseValid = true
                            }
                    }
                    
                }
    //           .frame(maxHeight: 1600)
            }
            //            }
            
        }
        
        
    }
    
}
