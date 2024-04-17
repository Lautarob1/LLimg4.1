//
//  TestTermView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/7/23.
//

import SwiftUI

struct ConsoleView3: View {
    @ObservedObject var CviewModel = ConsoleViewModel()
     @State private var userInput: String = ""

     var body: some View {
         VStack {
             ScrollView {
                 Text(CviewModel.output)
                     .frame(maxWidth: .infinity, alignment: .leading)
                     .padding()
             }
             TextField("Input", text: $userInput)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()
             Button("Run Command") {
//                CviewModel.executeCommand("sudo -S su")
             }
             Button("Send Input") {
//                CviewModel.sendInput(userInput)
             }
         }
     }
 }
// test comands
// "asr restore --source / --target /Volumes/llidata --erase"
// "sudo su -S 'Wait4Jesus99'"
// "sudo su -S"
//



struct MyView_Previews3: PreviewProvider {
    static var previews: some View {
        ConsoleView3()
    }
}
//#Preview {
//    ConsoleView()
//}
