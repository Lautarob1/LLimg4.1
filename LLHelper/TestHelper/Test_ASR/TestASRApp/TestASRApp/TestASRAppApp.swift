//
//  TestASRAppApp.swift
//  TestASRApp
//
//  Created by EFI-Admin on 12/18/23.
//

import SwiftUI

@main
struct TestASRAppApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(macOS 12.0, *) {
                ContentView()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
