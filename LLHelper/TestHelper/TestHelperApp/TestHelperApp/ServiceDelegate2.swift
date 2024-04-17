//
//  ServiceDelegate2.swift
//  TestHelperApp
//
//  Created by EFI-Admin on 12/16/23.
//

import Foundation

class ServiceDelegate2: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection connection: NSXPCConnection) -> Bool {
        // This method is where the NSXPCListener configures, accepts, and resumes a new incoming NSXPCConnection.

        // Configure the connection.
        // First, set the interface that the exported object implements.
        connection.exportedInterface = NSXPCInterface(with: XPCServiceProtocol2.self)

        // Next, set the object that the connection exports. All messages sent on the connection to
        // this service will be sent to the exported object to handle. The connection retains the
        // exported object.
        let exportedObject = XPCService2()
        connection.exportedObject = exportedObject

        // Resuming the connection allows the system to deliver more incoming messages.
        connection.resume()

        // Returning true from this method tells the system that you have accepted this connection.
        // If you want to reject the connection for some reason, call invalidate() on the connection
        // and return false.
        return true
    }
}
