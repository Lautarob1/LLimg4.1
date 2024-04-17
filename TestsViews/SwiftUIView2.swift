//
//  SwiftUIView2.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/27/23.
//

import SwiftUI

struct SwiftUIView2: View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack(spacing: 0) {
                    VStack {
                        // Content of the first VStack
                        Text("First VStack (2/3)")
                            .font(.title)
                        Button(action: {
                            
                        }, label: {
                            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                        })
                        .help(/*@START_MENU_TOKEN@*/"Help Content"/*@END_MENU_TOKEN@*/)
                    }
                    .frame(width: 200, height: geometry.size.height * 2/3)
                    .background(Color.blue)
                    
                    VStack {
                        // Content of the second VStack
                        Text("Second VStack (1/12)")
                    }
                    .frame(width: 180, height: geometry.size.height * 1/12)
                    .background(Color.green)
                    
                    VStack {
                        // Content of the third VStack
                        Text("Third VStack (1/4)")
                    }
                    .frame(width: 220, height: geometry.size.height * 1/4)
                    .background(Color.red)
                }
                VStack(spacing: 0) {
                    VStack {
                        // Content of the first VStack
                        Text("First VStack (2/5)")
                            .font(.title)
                    }
                    .frame(width: 200, height: geometry.size.height * 2/5)
                    .background(Color.blue)
                    
                    VStack {
                        // Content of the second VStack
                        Text("Second VStack (1/2)")
                    }
                    .frame(width: 180, height: geometry.size.height * 1/2)
                    .background(Color.green)
                    
                    VStack {
                        // Content of the third VStack
                        Text("Third VStack (1/10)")
                    }
                    .frame(width: 220, height: geometry.size.height * 1/10)
                    .background(Color.red)
                }
            }
        }
    }
}


 


#Preview {
    SwiftUIView2()
}
