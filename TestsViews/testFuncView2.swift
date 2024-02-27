//
//  testFuncView2.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 2/9/24.
//

import SwiftUI

func formatOutput(string: String, number: Double) -> String {
    let formattedNumber = "\(number / 1000) MB"
    var result = ""
    var startIndex = string.startIndex

    while startIndex < string.endIndex {
        let endIndex = string.index(startIndex, offsetBy: 60, limitedBy: string.endIndex) ?? string.endIndex
        let line = String(string[startIndex..<endIndex])
        
        if endIndex >= string.endIndex {
            result += line.padding(toLength: 60, withPad: " ", startingAt: 0) + "     " + formattedNumber
        } else {
            result += line + "\n"
        }

        startIndex = endIndex
    }

    return result
}

// Example usage
//let string1 = "This is a very long test string to demonstrate the formatting in Swift for strings that are longer than sixty characters and need to be broken down into multiple lines with a number appended at the end."
//let number = 123456.0
//print(formatOutput(string: string1, number: number))



struct testFuncView2: View {
    @State var output: String = "Test function for log"
    var body: some View {
        VStack {
            Text(output)
            Button("test print func") {
                let string1 = "This is a very long test string to demonstrate the formatting in Swift for strings that are longer than sixty characters and need to be broken down into multiple lines with a number appended at the end."
                let number = 12345678.0
                print(formatOutput(string: string1, number: number))
         
  
                output = String(string1.count)
//                print(formatOutput(string: string1, number: Int64(123456.0)))
            }
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .fill(
//                    Color(colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1))
                    Color(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1))
                )
                .frame(width: 150, height: 50)
        }
        .frame(width: 400, height: 300)
    }
}

#Preview {
    testFuncView2()
}
