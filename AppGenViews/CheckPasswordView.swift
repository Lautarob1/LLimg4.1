//
//  CheckPasswordView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/29/23.
//

import SwiftUI

struct CheckPasswordView: View {
    @ObservedObject var authModel: AuthenticationViewModel
    @State private var password: String = ""
    @State private var passwordAttempts: Int = 0
    @State private var showAlert = false
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @FocusState private var isPasswordFieldFocused: Bool
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
                 SecureField("Password", text: $password)
                     .textFieldStyle(RoundedBorderTextFieldStyle())
                     .frame(width: 300, height: 20)
                     .focused($isPasswordFieldFocused)
                     .onSubmit {
                         handlePasswordCheck()
                     }
                     .padding()
                 
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
                     Text("Type:\(authModel.licenseType) SN: \(authModel.licenseSerial)")
                         .frame(width: 170)
                         .padding(.horizontal, 5)
                         .background(.white).opacity(0.7)
                         .cornerRadius(6)
 //                    Spacer()
                     Text("License exp date: \(authModel.licenseExpDate)")
                         .frame(width: 200)
                         .padding(.horizontal, 5)
                         .background(.white).opacity(0.7)
                         .cornerRadius(6)
                 }
                 
                 .padding()
             }
             .frame(width: 550, height: 350)
             .background(gradient)
             .cornerRadius(20)
 //            .padding(50)
         }
        .frame(width: 900, height: 610)
        .background()
        .onAppear() {
            DispatchQueue.main.async {
                self.isPasswordFieldFocused = true
            }
            if !authModel.isLicenseValid {
                showAlert = true
//                print(AuthenticationViewModel.shared.licenseFileFound)
                authModel.licenseMessage = AuthenticationViewModel.shared.licenseFileFound ? "License Expired" : "No License File found"
                alertMessage = "\(authModel.licenseMessage). Access denied. The app will now quit. You should run it again once you have a valid file license on the required path (please check the app Manual)"
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
        print("password in review: \(authModel.isPasswordCorrect)")
        if authModel.isPasswordCorrect {
            print("correct password entered...")
            authModel.rootPassword = password
            print("passw captured: \(authModel.rootPassword)")
            AuthenticationViewModel.shared.rootPassword = password
        } else {
            print("false, check attemps?")
            passwordAttempts += 1
            print("passwordAttempts: \(passwordAttempts)")
//            DispatchQueue.main.async {
                if passwordAttempts >= 3 {
                    alertMessage = "Maximum attempts reached. Access denied. The app will now quit. You should run it again once you have an admin password for this computer"
                    showAlert = true
                    print("showAlert final: \(showAlert)")
                    // Additional logic to handle max attempts reached
                } else {
                    alertMessage = "Incorrect password. Please try again. You have \(String(3 - passwordAttempts)) attempt(s) left"
                    showAlert = true
                    print("showAlert <=3: \(showAlert)")
                }
//            }
        }
    }


    
    
    private func exitApp() {
        // Terminate the app
        exit(0)
    }
}

struct CheckPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CheckPasswordView(authModel: AuthenticationViewModel())
    }
}

//#Preview {
//    let viewModel = AuthenticationViewModel()
//    // Provide the viewModel instance to CheckPasswordView
//    CheckPasswordView(viewModel: viewModel)
//}
