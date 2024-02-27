//
//  LLhashcal.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/13/24.
//

import Foundation
import CommonCrypto

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

import CommonCrypto
import Foundation

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



func hashLargeFileSHA256(filePath: String) -> String {
    print("entering in hash 256 lg files func...")
    let bufferSize = 1024 * 1024 // 1 MB
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
