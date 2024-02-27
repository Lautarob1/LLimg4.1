//
//  XPCService2.swift
//  TestHelperApp
//
//  Created by EFI-Admin on 12/16/23.
//


import CSAuthSampleApp
import Foundation

// This object implements the protocol which we have defined. It provides the actual behavior for the service.
// It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
class XPCService2: NSObject, XPCServiceProtocol2 {
    private static let bundle = Bundle(for: XPCService2.self)
    private static let bundleVersion = XPCService2.bundle.infoDictionary![kCFBundleVersionKey as String] as! String

    func sayHello(message: String, reply: @escaping (String?, Error?) -> Void) {
        self.connectToHelperTool2 {
            switch $0 {
            case .success(let (proxy, authData)):
                proxy.sayHello(authorizationData: authData, message: message, reply: reply)
            case .failure(let error):
                reply(nil, error)
            }
        }
    }

    private func connectToHelperTool2(closure: @escaping (Result<(HelperToolProtocol2, Data), Error>) -> ()) {
        let client: HelperClient
        let authData: Data

        do {
            client = try self.getClient()
            authData = try client.authorizationData()
        } catch {
            closure(.failure(error))
            return
        }

        client.connectToHelperTool(
            helperID: Identifiers2.helperID,
            protocol: HelperToolProtocol2.self,
            expectedVersion: XPCService2.bundleVersion,
            errorHandler: { closure(.failure($0)) },
            connectionHandler: { closure(.success(($0, authData))) }
        )
    }

    private func getClient() throws -> HelperClient {
        try HelperClient(commandSet: exampleCommandSet, bundle: .main, tableName: "Prompts")
    }
}
