//
//  TestZStackView.swift
//  LLIMAGER
//
//  Created by EFI-Admin on 5/24/24.
//

import SwiftUI

struct TestZStackView: View {
    @State private var showView3 = false

    var body: some View {
        ZStack {
            VStack {
                
                Toggle("view3", isOn: $showView3)
                View1()
                    .frame(width: 400, height: 200)
                    .background(Color.red) // Temporary background color for debugging
                    .zIndex(1)
                View2()
                    .frame(width: 400, height: 200)
                    .background(Color.green) // Temporary background color for debugging
                    .zIndex(1)
            }
            .overlay(
                Group {
                    if showView3 {
                        View3()
                            .frame(width: 400, height: 400)
                            .background(Color.black)
                            .edgesIgnoringSafeArea(.all)
                    }
                }
                )
            
//            if showView3 {
//                View3()
//                    .frame(width: 400, height: 400)
//                    .background(Color.blue) // Ensure background color is set
//                    .zIndex(2)
//            }
        }
    }
}

struct View1: View {
    var body: some View {
        TextField("Enter text", text: .constant(""))
            .padding()
//            .background(Color.white)
            .cornerRadius(5)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .zIndex(1)
    }
}

struct View2: View {
    var body: some View {
        Color.clear // Example placeholder view
    }
}

struct View3: View {
    var body: some View {
        Color.black // Ensure no transparency
    }
}



#Preview {
    TestZStackView()
}
