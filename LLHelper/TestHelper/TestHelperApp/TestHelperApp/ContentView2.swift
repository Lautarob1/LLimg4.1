//
//  ContentView2.swift
//  TestHelperApp
//
//  Created by EFI-Admin on 12/16/23.
//

import SwiftUI

struct ContentView2: View {
    @State private var response = ""
    @State private var messageSendInProgress = false

    var body: some View {
        VStack {
            Button {
                self.messageSendInProgress = true

                MessageSender2.shared.sayHello {
                    self.messageSendInProgress = false

                    switch $0 {
                    case .success(let reply):
                        self.response = "Received reply from helper:\n\n\(reply)"
                    case .failure(let error):
                        self.response = "Received error from helper:\n\n\(error.localizedDescription)"
                    }
                }
            } label: {
                Text("Say Hello")
            }.padding().disabled(self.messageSendInProgress)
            Text("Response:")
            Text($response.wrappedValue)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.padding().frame(minWidth: 300)
    }
}

#Preview {
    ContentView2()
}
