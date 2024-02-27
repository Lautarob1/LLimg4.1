//
//  HelperToolProtocol2.swift
//  TestHelperApp
//
//  Created by EFI-Admin on 12/17/23.
//

import CSAuthSampleCommon
import Foundation

@objc protocol HelperToolProtocol2: BuiltInCommands {
    func sayHello(authorizationData: Data, message: String, reply: @escaping (String?, Error?) -> Void)
}
