//
//  TestTermView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/7/23.
//

import SwiftUI

struct testProcTerminalView: View {
    @ObservedObject var sviewModel = ConsoleViewModel()
//    @State private var output: String

    var body: some View {
        VStack {
            ScrollView {
                Text(sviewModel.output)
                    .font(.system(size: 10, weight: .bold, design: .default)) // Set font size, weight, and design
                    .italic() // Make the text italic
                    .foregroundColor(.white) // Set the text color
                    .frame(width: 370, height: 250, alignment: .leading)
                    .padding()
                    .background(Color("LL_blue").opacity(0.4)) // Set the background color
                    .cornerRadius(14)
   
            }
            .frame(width: 375, height: 300)
            
            Button("test CMD") {
                sviewModel.output=sviewModel.executeSudoCommand(command: "sudo hdiutil create -size 500g -type SPARSE -fs APFS -volname test6 /Volumes/llidata/test6", passw: "Wait4Jesus99")
            }
            .padding()
        }
    }
}

// test comands
// "asr restore --source / --target /Volumes/llidata --erase"
// "sudo su -S 'Wait4Jesus99'"
// "sudo su -S"
//



struct TermView_Previews2: PreviewProvider {
    static var previews: some View {
        testProcTerminalView()
    }
}
//#Preview {
//    ConsoleView()
//}
