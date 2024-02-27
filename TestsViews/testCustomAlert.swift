//
//  SwiftUIView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/27/23.
//

import SwiftUI


struct CustomAlert: View {
    let title: String
    let message: String
    let imageName: String
    let backgroundColor: Color
    let textColor: Color
    var onDismiss: () -> Void  // Closure to call when dismissing the alert

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundColor(textColor)
            Text(title)
                .font(.title)
                .foregroundColor(textColor)
            Text(message)
                .font(.body)
                .foregroundColor(textColor)
            Button("OK") {
                onDismiss()  // Call the closure to dismiss the alert
            }
            .padding()
            .background(Color.white)
            .foregroundColor(textColor)
            .cornerRadius(10)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}


struct ContentViewtest: View {
    @State private var showAlert = false
    // ... other state properties ...

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                // Content of the first VStack
                Text("First VStack (2/3)")
                    .font(.title)
                Button(action: {
                  showAlert = true
                }, label: {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                })
                .help(/*@START_MENU_TOKEN@*/"Help Content"/*@END_MENU_TOKEN@*/)
            }
            .frame(width: 200, height: 200)
            .background(Color.blue)
            
            VStack {
                // Content of the second VStack
                Text("Second VStack (1/12)")
            }
            .frame(width: 180, height: 150)
            .background(Color.green)
                

            if showAlert {
                CustomAlertView(
                    showAlert: $showAlert,
                    imageName: "externaldrive",
                    title: "Alert",
                    message: "Custom message based on condition",
                    fontSize1: 14,
                    fontSize2: 12,
                    textColor: .white, backgroundColor: .blue
                )
                .transition(.scale)  // Optional animation
            }
        }
        // ... rest of your view ...
    }

    // ... rest of your view logic ...
}




#Preview {
    ContentViewtest()
}
