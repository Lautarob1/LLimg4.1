//
//  testLicenseView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/11/24.
//

import SwiftUI

struct testLicenseView: View {
    let licenseDetails = readLicense().components(separatedBy: "\n")
    var body: some View {
        
        VStack {
            HStack {
              Text("Type of Lic \(licenseDetails[0])")
             Text("Serial \(licenseDetails[1])")
            }
            HStack {
              Text("Exp date \(licenseDetails[2])")
             Text("Issue date \(licenseDetails[3])")
            }
            Button("Check License") {
                print(readLicense())
            }
            Text(checkLicense(dateRef: licenseDetails[2]))
        }
        .frame(width: 300, height: 200)
        
    }
}

#Preview {
    testLicenseView()
}
