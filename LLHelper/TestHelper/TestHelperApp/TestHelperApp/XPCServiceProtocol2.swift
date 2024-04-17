//
//  XPCServiceProtocol2.swift
//  TestHelperApp
//
//  Created by EFI-Admin on 12/16/23.
//

import Foundation

@objc protocol XPCServiceProtocol2 {
    func sayHello(message: String, reply: @escaping (String?, Error?) -> Void)
}
