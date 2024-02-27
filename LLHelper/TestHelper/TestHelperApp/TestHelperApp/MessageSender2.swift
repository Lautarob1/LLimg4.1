//
//  MessageSender2.swift
//  TestHelperApp
//
//  Created by EFI-Admin on 12/16/23.
//

import CSAuthSampleApp
import Foundation

class MessageSender2 {
    static let shared = MessageSender2()

    private var _xpcConnection: NSXPCConnection?
    private var sema = DispatchSemaphore(value: 1)

    private var xpcConnection: NSXPCConnection {
        self.sema.wait()
        defer { self.sema.signal() }

        if let connection = self._xpcConnection {
            return connection
        }
        print("before NSXPCConn")
        let connection = NSXPCConnection(serviceName: Identifiers2.xpcServiceID)
        print("Idenf.appID")
        print(Identifiers2.appID)
        print("Idenf.xpcservID")
        print(Identifiers2.xpcServiceID)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCServiceProtocol2.self)

        connection.invalidationHandler = { [weak connection] in
            self.sema.wait()
            defer { self.sema.signal() }

            connection?.invalidationHandler = nil
            self._xpcConnection = nil
        }

        connection.resume()

        self._xpcConnection = connection
        print("about to return connection")
        return connection
    }

    func sayHello(reply: @escaping (Result<String, Error>) -> Void) {
        let proxy = self.getProxy { reply(.failure($0)) }
        let sandboxWorkaround = SandboxWorkaround()
        print("in function sayHello")
        print(proxy)

        proxy.sayHello(message: "Hello there, helper tool!") {
            sandboxWorkaround.stop()

            if let replyMessage = $0 {
                reply(.success(replyMessage))
            } else {
                reply(.failure($1 ?? CocoaError(.fileReadUnknown)))
            }
        }
    }

    func getProxy(errorHandler: @escaping (Error) -> Void) -> XPCServiceProtocol2 {
        return self.xpcConnection.remoteObjectProxyWithErrorHandler(errorHandler) as! XPCServiceProtocol2
    }
}
