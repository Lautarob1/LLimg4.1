//
//  TestAnimatedView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 1/12/24.
//

import SwiftUI

struct TestAnimatedView: View {
    @State private var animateArrow = false
    @State private var showControls = true

    var body: some View {
        VStack {
            if showControls {
                HStack(spacing: 20) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20, weight: .bold))

                        .foregroundColor(Color("LL_orange"))
                        .offset(x: animateArrow ? 20 : 0)
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: animateArrow)
                    Button("Click to start process") {
                        showControls = false
                        startProcess()
                    }
                }
                .frame(width: 300, height: 400)
                .onAppear {
                    animateArrow = true
                }
            }
        }
    }

    func startProcess() {
        // Insert the code for the process you want to start here
        print("Process started")
    }
}

//@main
//struct MyApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}


#Preview {
    TestAnimatedView()
}
