//
//  TestTermView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 12/7/23.
//

import SwiftUI

struct ImgProcTerminalView: View {
    @ObservedObject var sviewModel = ConsoleViewModel()

    var body: some View {
        VStack {
            ScrollView {
                Text(sviewModel.output)
                    .font(.system(size: 11, weight: .bold, design: .default)) // Set font size, weight, and design
                    .italic() // Make the text italic
                    .foregroundColor(.white) // Set the text color
                    .frame(width: 600, height: 160, alignment: .leading)
                    .padding()
                    .background(Color("LL_blue").opacity(0.5)) // Set the background color
                    .cornerRadius(14)

            }
            .frame(width: 620, height: 240)
        }
    }
}


struct TermView_Previews: PreviewProvider {
    static var previews: some View {
        ImgProcTerminalView()
    }
}
//#Preview {
//    ConsoleView()
//}
