//
//  TestTermView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/7/23.
//

import SwiftUI

struct ConsoleView: View {
    @ObservedObject var sviewModel = ConsoleViewModel()

    var body: some View {
        VStack {
            ScrollView {
                Text(sviewModel.output)
                    .font(.system(size: 10, weight: .bold, design: .default)) // Set font size, weight, and design
                    .italic() // Make the text italic
                    .foregroundColor(.white) // Set the text color
                    .frame(width: 400, height: 200, alignment: .leading)
                    .padding()
                    .background(Color("LL_blue")) // Set the background color
                    .cornerRadius(10) // Rounded corners for the background
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Rounded corners for the border
                            .stroke(Color.black, lineWidth: 4) // Set border color and width
                    )            }
            
            
            Button("Run ASR Command") {
                sviewModel.output=""
               sviewModel.executeSudoCommand2(command: "asr restore --source / --target /Volumes/test6 --erase --noprompt", passw: "Wait4Jesus99")
            }.padding()
            
            Button("Run Sudo Test") {
                sviewModel.executeSudoCommand(command: "sudo -S whoami", passw: "Wait4Jesus99")
            }
            .frame(width: 200, height: 60)
            .background(Color.blue)
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .cornerRadius(15)
            Button("Run Hdiutil container") {
                sviewModel.output=sviewModel.executeSudoCommand(command: "sudo hdiutil create -size 500g -type SPARSE -fs APFS -volname test6 /Volumes/llidata/test6", passw: "Wait4Jesus99")
            }

        }
        
        
    }
}




struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleView()
    }
}
//#Preview {
//    ConsoleView()
//}
