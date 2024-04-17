//
//  TestTermView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/7/23.
//

import SwiftUI
import AppKit

struct CustomTextEditor: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.backgroundColor = NSColor.blue.withAlphaComponent(0.05) // Set background color with opacity
        textView.textColor = NSColor.white // Set text color
        return textView
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.string = text
    }
}

struct TestTermView: View {
    @State var test1 = "Hello"
    var hprofileArray: [(typeh: String, valueh: String)] // Declare the tuple with named elements

    init() {
        hprofileArray = loadHardwareProfile() // Load the hardware profile in the initializer
    }

    var body: some View {
        VStack {
            CustomTextEditor(text: $test1)
               .foregroundColor(.red)
               .padding(20)  // Add padding around the TextEditor
               .background(Color.blue.opacity(0.5))  // Set the background color to blue with 50% opacity
               .frame(height: 200)  // Set a fixed height for the TextEditor
               .cornerRadius(10)  //
            ForEach(hprofileArray, id: \.self.typeh) { tuple in
                Text("\(tuple.typeh) \(tuple.valueh)")
            }
        }
        .frame(width:370, height: 250)
    }
}

//struct TestTermView: View {
//    var hprofileArray: [(String, String)] = []
//    var body: some View {
//        Text("hola")
//        let hprofileArray = loadHardwareProfile()
//        
//        ForEach(hprofileArray, id: \.self.typeh) { tuple in
//            Text("Type: \(tuple.typeh), Value: \(tuple.valueh)")
//        }
//    }
//    
//}



#Preview {
    TestTermView()
}
