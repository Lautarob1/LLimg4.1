//
//  Imaging1View.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/28/23.
//

import SwiftUI

struct Imaging3RevView: View {
    @State private var imageName: String = ""
    @State private var isliveimgChecked: Bool = false
    @State private var isViewPresented = false
    @State private var isChecked: Bool = false
    @State private var showAlertSize: Bool = false
//    @State private var destinationDisk: String
    var onProcess: () -> Void
    var onModify: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        
        ZStack {
        HStack {
            
            
            VStack {
                HStack(alignment: .top) {
                    Image("img_but3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .cornerRadius(15)
                        .padding(.leading)
                    Spacer()  // Pushes the image to the left
                }
                
                
                HStack {
                    
                    VStack {
                        CaseInfoViewRev()
                        
//                        ImgInfoViewRev()
//                        HardinfoViewRev()
                    }
                    .padding(.trailing, 25)
                    VStack (spacing: 20){
                        TgtSelectSparseViewRev()
                        TgtInfoViewRev()
                    }
 
                }
                
                HStack {
                    Button(action: {
                        onCancel()
                    }) {
                        Text("Cancel")
                            .font(.custom("Helvetica Neue", size: 14))
                            .frame(width: 100, height: 20)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(3)
                    }
                    
                    Button(action: {
                        onProcess()
                    }) {
                        Text("Create Image")
                            .font(.custom("Helvetica Neue", size: 14))
                            .frame(width: 100, height: 20)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(3)
                    }
                    
                    Button(action: {
                        onModify()
                    }) {
                        Text("Change values")
                            .font(.custom("Helvetica Neue", size: 14))
                            .frame(width: 100, height: 20)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(3)
                    }
                }
                .padding(.vertical, 15)
            }

                }
            }
 
        }
        // show alert here
//            if showAlertSize {
//                CustomAlertView(
//                    showAlert: $showAlertSize,
//                    imageName: "exclamationmark.triangle",
//                    title: "LLIMAGER Alert",
//                    message: "Not enough space in the destination disk for the \(DiskDataManager.shared.selectedDskOption) image",
//                    fontSize1: 14,
//                    fontSize2: 12,
//                    textColor: Color("LL_blue"),
//                    backgroundColor: .white
//                )
//                .frame(width: 300, height: 250)
//                .cornerRadius(15)
//                .shadow(radius: 10)
//                .opacity(showAlertSize ? 1 : 0) // Control visibility
//                .animation(.easeInOut, value: showAlertSize)
//             
//            }
            
    } // here closes ZStack
        
//    }
//
//}

#Preview {
    Imaging3RevView(onProcess: {}, onModify: {}, onCancel: {}
    )
}
