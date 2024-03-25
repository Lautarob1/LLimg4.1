//
//  LLlicencecheck.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/11/24.
//

import Foundation
import CommonCrypto

extension Data {
    init?(base64URL base64: String) {
        var base64 = base64
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        self.init(base64Encoded: base64)
    }
}

func decrypt(ciphertext: Data, key: Data, iv: Data) -> Data {
    var decryptor: CCCryptorRef?
    
    defer {
        CCCryptorRelease(decryptor)
    }
    
    var key = Array(key)
    var iv = Array(iv)
    var ciphertext = Array(ciphertext)
    
    CCCryptorCreate(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding), &key, key.count, &iv, &decryptor)
    
    var outputBytes = [UInt8](repeating: 0, count: CCCryptorGetOutputLength(decryptor, ciphertext.count, false))
    CCCryptorUpdate(decryptor, &ciphertext, ciphertext.count, &outputBytes, outputBytes.count, nil)
    
    var movedBytes = 0
    var finalBytes = [UInt8](repeating: 0, count: CCCryptorGetOutputLength(decryptor, 0, true))
    CCCryptorFinal(decryptor, &finalBytes, finalBytes.count, &movedBytes)
    
    return Data(outputBytes + finalBytes[0 ..< movedBytes])
}

func verifyHMAC(_ mac: Data, authenticating data: Data, using key: Data) -> Bool {
    var data = Array(data)
    var key = Array(key)
    var macOut = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), &key, key.count, &data, data.count, &macOut)
    return Array(mac) == macOut
}


func licenseFile()  -> String {
    let filePath = "/Volumes/LLimager-Int/LLimager/llimager.lic"
    var fileContents: String = ""
    do {
        fileContents = try String(contentsOf: URL(fileURLWithPath: filePath), encoding: .utf8)
        AuthenticationViewModel.shared.licenseFileFound = true
//        print("After read file \(AuthenticationViewModel.shared.licenseFileFound)")
        // Now fileContents contains the text of your file
    } catch {
//        print("in catch -no file found- \(AuthenticationViewModel.shared.licenseFileFound)")
        fileContents = "Error reading file: \(error.localizedDescription)"
//        return("Error reading file: \(error)")
    }
//    print("From licenseFile func: \(fileContents)")
    return fileContents
}

func readLicense() -> String {
//let ferneticKey   = Data(base64URL: "3b-Nqg6ry-jrAuDyVjSwEe8wrdyEPQfPuOQNH1q5olE=")!
//let fernetKey   = Data(base64URL: "63hVTY0lqlV6LAUrr1AnFlZ_XVyiDftxmKHKl38YDbE=")!
    let fernetKey   = Data(base64URL: "LYTmnq11p-Qy1YQnYlTlqHaCAZ739G7swyibhyG0kaY=")!
    let signingKey  = fernetKey[0 ..< 16]
    let cryptoKey   = fernetKey[16 ..< fernetKey.count]
    var licenceFileCont: String = ""
//let fernetToken = Data(base64URL: "gAAAAABlnvrxmiOHkhtxI0cFycSbbBp87NSQKfeU885V_Q9pH-hKguYQ1f3DaDCN5i4ify8V42kkRUqhTSxI0b-dDip_3VsiCXxWzm4Fqg85G2LxOonUILIgC7e7u4IffQBmFt4PEFb2XrdgTVelg8CbgTGfXsIaoXHZg1_uONbVt8f9Ou6DE14TkZEghOE2x_GsDGmK9SPotbDGhv8O31y-RUMmnLXHHZ08AbP9b0TLT6472D4DmfcHuh_3uqeWFm9Mv47TGel4pXyixzMj3Rk_9_S3KHrJ0NOr9Kcamj-9kz-TOWTnC2Z777zc2P0hSUw16ZNDtSK1HRG1goW-SgIRpH3n4xRcBgDyNCS6YYMojwgILWNySbUYndnIBg36GnYVvjRihJoTRcl5ST0wRZS5PP8n3TTsi2ll5he5U2__F748yXTO9vw=")!

//let fernetToken = Data(base64URL: "gAAAAABlczTRHJwJHsiDH3-QwuXHXQoTDK8IgEcW96rnnt-t82ZHrWQ1wYgD0J4fjQp5vf-HZGLxvC6hghEPLoCTO3gF-3o5pc5CZcXjzaLoPQwh0bUI4P4_FKNYB236JVJlFBEIgjBaTuNvcm2Mf8u31UUWkBe5oQ==")!
//    print("before call the licenseFile func....")
    licenceFileCont = licenseFile()
    if !licenceFileCont.contains("Error reading file:") {
        //    print("LicenseFileCont as return of func \n \(licenceFileCont)")
        let fernetToken = Data(base64URL: licenceFileCont)!
        //    print("fernettoken: \(fernetToken)")
        //let fernetToken = Data(base64URL: "gAAAAABlczTRHJwJHsiDH3-QwuXHXQoTDK8IgEcW96rnnt-t82ZHrWQ1wYgD0J4fjQp5vf-HZGLxvC6hghEPLoCTO3gF-3o5pc5CZcXjzaLoPQwh0bUI4P4_FKNYB236JVJlFBEIgjBaTuNvcm2Mf8u31UUWkBe5oQ==")!
        
        //    gAAAAABlczTRHJwJHsiDH3-QwuXHXQoTDK8IgEcW96rnnt-t82ZHrWQ1wYgD0J4fjQp5vf-HZGLxvC6hghEPLoCTO3gF-3o5pc5CZcXjzaLoPQwh0bUI4P4_FKNYB236JVJlFBEIgjBaTuNvcm2Mf8u31UUWkBe5oQ==
        
        //    gAAAAABlczTRHJwJHsiDH3-QwuXHXQoTDK8IgEcW96rnnt-t82ZHrWQ1wYgD0J4fjQp5vf-HZGLxvC6hghEPLoCTO3gF-3o5pc5CZcXjzaLoPQwh0bUI4P4_FKNYB236JVJlFBEIgjBaTuNvcm2Mf8u31UUWkBe5oQ==
        
        let version     = Data([fernetToken[0]])
        let timestamp   = fernetToken[1 ..< 9]
        let iv          = fernetToken[9 ..< 25]
        let ciphertext  = fernetToken[25 ..< fernetToken.count - 32]
        let hmac        = fernetToken[fernetToken.count - 32 ..< fernetToken.count]
        
        let plainText = decrypt(ciphertext: ciphertext, key: cryptoKey, iv: iv)
        //    print(plainText, String(data: plainText, encoding: .utf8) ?? "Non utf8")
        //    print(verifyHMAC(hmac, authenticating: version + timestamp + iv + ciphertext, using: signingKey))
        return String(data: plainText, encoding: .utf8) ?? "Non utf8"
    }
    else {
        
        return "No License File found"
    }
}

func checkLicense (dateRef: String) -> String {
    var checkDate: String = ""
    let dateString = "2023-11-16"

    // Create a DateFormatter
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    // Convert the string to a Date object
    if let date = dateFormatter.date(from: dateString) {
        // Compare with the current date
        let currentDate = Date()
        
        if date >= currentDate {
            checkDate = "Valid"
//            print("\(dateString) is not expired.")
        }  else {
            checkDate = "Expired"
//            print("\(dateString) is expired.")
        }
    } else {
        print("Invalid date format")
    }
return checkDate
    
}

