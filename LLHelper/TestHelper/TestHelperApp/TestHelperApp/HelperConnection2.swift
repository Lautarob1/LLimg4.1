//
//  HelperConnection2.swift
//  TestHelperApp
//
//  Created by EFI-Admin on 12/16/23.
//

import CSAuthSampleHelper
import Foundation

class HelperConnection2: CSAuthSampleHelper.HelperConnection, HelperToolProtocol2 {
    func sayHello(authorizationData: Data, message: String, reply: @escaping (String?, Error?) -> ()) {
        if let error = self.checkAuthorization(authorizationData) {
            reply(nil, error)
            return
        }

        let replyMessage = """
            Received message from app: “\(message)”
            Sending reply to app: “Hello app! My UID is \(getuid()) and my GID is \(getgid())!
            """

        reply(replyMessage, nil)
    }
}


