//
//  CheckPasswordView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/29/23.
//

import SwiftUI
import AppKit

struct CheckPasswordView: View {
    @ObservedObject var authModel: AuthenticationViewModel
    @State private var password: String = ""
    @State private var passwordAttempts: Int = 0
    @State private var showAlert = false
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
//    the 2 lines below are changes to make it work in MacOS 11
//    @FocusState private var isPasswordFieldFocused: Bool
    @State var isPasswordFocused11: Bool
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color(.gray)]),
                                  startPoint: .top,
                                  endPoint: .bottom)

//    let darkGray = Color(red: 0.2, green: 0.2, blue: 0.2)

//    let gradient = RadialGradient(
//        gradient: Gradient(colors: [Color.orange, darkGray]),
//        center: .center, // The center point of the gradient
//        startRadius: 0,  // Radius at which to start the gradient colors
//        endRadius: 200   // Radius at which to end the gradient colors
//    )
    var body: some View {
        let darkGray = Color(red: 0.5, green: 0.5, blue: 0.5)
        
        let gradientRad = RadialGradient(
            gradient: Gradient(colors: [Color("LL_orange"), darkGray]),
            center: .center,
            startRadius: 120,
            endRadius: 300
        )
        ZStack {
            gradientRad
         
             VStack {
                 Spacer()
                 Text("An admin password for this computer is required:")
                     .foregroundColor(.white)
                     .font(.title)
                 if #available(macOS 12.0, *) {
                     SecureField("Password", text: $password)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                         .frame(width: 300, height: 20)
//                          .focused($isPasswordFieldFocused)
                         .onSubmit {
                             handlePasswordCheck()
                         }
                         .padding()
                 } else {
                     // Fallback on earlier versions
                     SecureField("Password", text: $password)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                         .frame(width: 300, height: 20)
                 }
                 
                 VStack {
                     Button("Enter")
                     {
                         handlePasswordCheck()
                     }
                     .font(.headline)
                     .padding(.all, 5)
                     .frame(width: 120, height: 30)
                 }
                 Spacer()
                 HStack (spacing: 80){
                     Text("\(authModel.licenseType) SN: \(authModel.licenseSerial)")
                         .frame(width: 220)
                         .padding(.horizontal, 3)
                         .background(Color.white).opacity(0.7)
                         .cornerRadius(6)
 //                    Spacer()
                     Text("License exp date: \(authModel.licenseExpDate)")
                         .frame(width: 200)
                         .padding(.horizontal, 3)
                         .background(Color.white).opacity(0.7)
                         .cornerRadius(6)
                 }
                 .padding(.horizontal, 5)
                 .padding(.vertical, 15)
             }
             .frame(width: 570, height: 420)
             .background(gradient)
             .cornerRadius(20)
//             .padding(15)
         }
        .frame(minHeight: 620)
        .background(Color.clear)
        .onAppear() {
            DispatchQueue.main.async {
                self.isPasswordFocused11 = true
            }
            if !authModel.isLicenseValid {
                showAlert = true
//                print(AuthenticationViewModel.shared.licenseFileFound)
                authModel.licenseMessage = AuthenticationViewModel.shared.licenseFileFound ? "License Expired or Invalid" : "No License File found"
                alertMessage = "\(authModel.licenseMessage). Access denied. The app will now quit. You should run it again once you have a valid file license in the required path (please check the app Manual)"
            }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK"), action: {
                if passwordAttempts >= 3 || !authModel.isLicenseValid {
                          exitApp()
                      }
                  }))
        }

    }


    private func handlePasswordCheck() {
        authModel.validatePassword(password)
//        print("password in review: \(authModel.isPasswordCorrect)")
        if authModel.isPasswordCorrect {
//            print("correct password entered...")
            authModel.rootPassword = password
//            print("passw captured: \(authModel.rootPassword)")
            AuthenticationViewModel.shared.rootPassword = password
        } else {
//            print("false, check attemps?")
            passwordAttempts += 1
//            print("passwordAttempts: \(passwordAttempts)")
//            DispatchQueue.main.async {
                if passwordAttempts >= 3 {
                    alertMessage = "Maximum attempts reached. Access denied. The app will now quit. You should run it again once you have an admin password for this computer"
                    showAlert = true
//                    print("showAlert final: \(showAlert)")
                    // Additional logic to handle max attempts reached
                } else {
                    alertMessage = "Incorrect password. Please try again. You have \(String(3 - passwordAttempts)) attempt(s) left"
                    showAlert = true
//                    print("showAlert <=3: \(showAlert)")
                }
//            }
        }
    }



    struct CustomSecureTextField: NSViewRepresentable {
        class Coordinator: NSObject, NSTextFieldDelegate {
            var parent: CustomSecureTextField

            init(_ textField: CustomSecureTextField) {
                self.parent = textField
            }

            func controlTextDidChange(_ obj: Notification) {
                if let textField = obj.object as? NSSecureTextField {
                    self.parent.text = textField.stringValue
                }
            }
        }

        @Binding var text: String
        var isFirstResponder: Bool = false

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        func makeNSView(context: Context) -> NSSecureTextField {
            let textField = NSSecureTextField()
            textField.delegate = context.coordinator
            return textField
        }

        func updateNSView(_ nsView: NSSecureTextField, context: Context) {
            nsView.stringValue = text
            if isFirstResponder && !context.coordinator.parent.isFirstResponder {
                nsView.becomeFirstResponder()
                context.coordinator.parent.isFirstResponder = true
            }
        }
    }

    
    
    private func exitApp() {
        // Terminate the app
        exit(0)
    }
}

//struct CheckPasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(macOS 12.0, *) {
//            CheckPasswordView(authModel: AuthenticationViewModel())
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}

//#Preview {
//    let viewModel = AuthenticationViewModel()
//    // Provide the viewModel instance to CheckPasswordView
//    CheckPasswordView(viewModel: viewModel)
//}
