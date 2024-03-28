//
//  TestHovering.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/26/23.
//

import SwiftUI

struct MenuOption: Identifiable {
    let id: Int
}


struct MenuView: View {
    @EnvironmentObject var diskDataManager: DiskDataManager
    @ObservedObject var authModel: AuthenticationViewModel
    @State private var showViews: [Int: Bool] = [1: false, 2: false, 3: false, 4: false]
    @State private var showViewsRev: [Int: Bool] = [1: false, 2: false, 3: false, 4: false]
    @State private var showViewsProc: [Int: Bool] = [1: false, 2: false, 3: false, 4: false]
    @State private var password: String = ""
    @State private var passwordAttempts: Int = 0
    @State private var isPasswordCorrect: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var hoverStates: [Int: Bool] = [1: false, 2: false, 3: false, 4: false]
    @State private var isHovering: Bool = false
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 40), count: 2)
    let buttonTooltips = ["Acquire a Disk Image", "Acquire Selected Files or Folders", "Convert Sparse to DMG", "Calculate Hash Values"]
    let buttonImages = ["img_but1", "img_but2", "img_but3", "img_but4"]
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color(.gray)]),
                                  startPoint: .top,
                                  endPoint: .bottom)
    @State private var showAlert0: Bool = true
    @State private var selectedOption: MenuOption? = nil



    
    var body: some View {
        ZStack {
                VStack (spacing: 0) {
//                    Spacer()
                    LazyVGrid(columns: columns, spacing: 70) {
                        ForEach(1...4, id: \.self) { optionID in
                            ZStack {
                                Button(action: {
                                    selectedOption = MenuOption(id: optionID)
                                }) {
                                    Image("img_but\(optionID)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 175, height: 175)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onHover(perform: { hovering in
//                                    print(buttonTooltips[(optionID-1)])
                                    hoverStates[optionID] = hovering
                                })
                                if hoverStates[optionID] ?? false {
                                    Text(buttonTooltips[(optionID)-1])
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(8)
                                        .transition(.opacity)
                                        .animation(.easeInOut, value: isHovering)
                                        .offset(y: -75.0)
                                
                                }
                            } // ZStack close
                            .sheet(item: $selectedOption) { option in
                                switch option.id {
                                case 1:
                                    Imaging1View(selectedOption: $selectedOption)
                                case 2:
                                    Imaging2View(selectedOption: $selectedOption)
                                case 3:
                                    Imaging3View(selectedOption: $selectedOption)
                                case 4:
                                    Imaging4View(selectedOption: $selectedOption)
                                default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 20)
//                    .frame(minHeight: 610)
                    Button("E x i t")
                    {
                        NSApplication.shared.terminate(nil)
                    }
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(Color("LL_blue"))
                    .frame(width: 170,height: 40)
                    .background(.white)
                    .cornerRadius(10)
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 10)
                    VStack {
                        Text(" e-forensics inc. Copyright 2023-2024. All rights reserved.")
                            .foregroundColor(.white)
                            .frame(maxHeight: 25)
                            .padding(.bottom, 10)
                    }
//                    .padding(.top, 50)
//                    .frame(minWidth: 900)

                }
                .frame(minHeight: 680)
                
//            }
            if showAlert0 {
                CustomAlertView0(onOK: {showAlert0 = false})
            }

        }
//        .frame(minWidth: 900)
        .background(gradient)
        .sheet(item: $selectedOption) { option in
            switch option.id {
            case 1:
                Imaging1View(selectedOption: $selectedOption)
            case 2:
                Imaging2View(selectedOption: $selectedOption)
            case 3:
                Imaging3View(selectedOption: $selectedOption)
            case 4:
                Imaging4View(selectedOption: $selectedOption)
            default:
                EmptyView()
            }
            
        }

    }
        private var buttonsGridView: some View {
            LazyVGrid(columns: columns, spacing: 70) {
                ForEach(1...4, id: \.self) { index in
                    buttonView(for: index)
                }
            }
            .padding(.bottom, 20)
        }
        
        private func buttonView(for index: Int) -> some View {
            Button(action: {
//                print("Button tapped \(index)")
                showViews[index] = true
                showViewsRev[index] = true
            }) {
                VStack {
                    Image(buttonImages[index - 1])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 175, height: 175)
                        .background(.white)
                        .cornerRadius(15)
                        .padding(0)
                        .overlay(tooltipOverlay(for: index))
                }
            }
            .onHover { isHovering in
                hoverStates[index] = isHovering
            }

        }
        
        private func tooltipOverlay(for index: Int) -> some View {
            Group {
                if hoverStates[index] ?? false {
                    Text(buttonTooltips[index - 1])
                    .frame(width: 205, height: 30)
                    .background(Color("LL_orange"))
                    .foregroundColor(.white)
                    .cornerRadius(10.0)
                    .offset(y: -75.0)
                }
            }
        }
        

}

#Preview {
    MenuView(authModel: AuthenticationViewModel())
}

