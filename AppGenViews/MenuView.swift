//
//  TestHovering.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/26/23.
//

import SwiftUI

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
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 40), count: 2)
    let buttonTooltips = ["Acquire a full disk image", "Acquire Selected Files or Folders", "Convert Sparse", "Calculate Hash values"]
    let buttonImages = ["img_but1", "img_but2", "img_but3", "img_but4"]
    let gradient = LinearGradient(gradient: Gradient(colors: [Color("LL_orange"), Color(.gray)]),
                                  startPoint: .top,
                                  endPoint: .bottom)



    
    var body: some View {
        ZStack {

            VStack (spacing: 50){
  
                headerView
                buttonsGridView
            }

        }

//        .background(Color("LL_blue").opacity(0.5))
        .frame(width: 900, height: 620)
        .background(gradient)
        .sheet(isPresented: binding (for: 1)) {
            Imaging1View(onReview: {
                print("Review pressed. Status showViews[1] \(String(describing: showViews[1])), Status showViewsRev[1] set to \(String(describing: showViewsRev[1]))")
                self.showViews[1] = false
                self.showViewsRev[1] = true
            }, onCancel: {
                self.resetToInitialState()
            }
            )
        }
        .sheet(isPresented: binding (for: 2)) {
            Imaging2View(onReview: {
                print("Review pressed. Status showViews[2] \(String(describing: showViews[2])), Status showViewsRev[2] set to \(String(describing: showViewsRev[2]))")
                self.showViews[2] = false
                self.showViewsRev[2] = true
            }, onCancel: {
                self.resetToInitialState()
            }
            )
        }
        .sheet(isPresented: binding (for: 3)) {
            Imaging2View(onReview: {
                print("Review pressed. Status showViews[3] \(String(describing: showViews[3])), Status showViewsRev[3] set to \(String(describing: showViewsRev[3]))")
                self.showViews[3] = false
                self.showViewsRev[3] = true
            }, onCancel: {
                self.resetToInitialState()
            }
            )
        }
        .sheet(isPresented: binding (for: 4)) {
            Imaging2View(onReview: {
                print("Review pressed. Status showViews[4] \(String(describing: showViews[4])), Status showViewsRev[4] set to \(String(describing: showViewsRev[4]))")
                self.showViews[4] = false
                self.showViewsRev[4] = true
            }, onCancel: {
                self.resetToInitialState()
            }
            )
        }
        .sheet(isPresented: bindingRev(for: 1)) {
            Imaging1RevView(onProcess: {
                self.showViewsRev[1] = false
                self.showViewsProc[1] = true
            },
                onModify: {
                self.showViews[1] = true
                self.showViewsRev[1] = false
            },
                onCancel: {
                self.showViews[1] = false
                self.showViewsRev[1] = false
            }
            )
        }
        .sheet(isPresented: bindingRev(for: 2)) {
            Imaging2RevView(onProcess: {
                self.showViewsRev[2] = false
                self.showViewsProc[2] = true
            },
                onModify: {
                self.showViews[2] = true
                self.showViewsRev[2] = false
            },
                onCancel: {
                self.showViews[2] = false
                self.showViewsRev[2] = false
            }
            )
        }
        .sheet(isPresented: bindingRev(for: 3)) {
            Imaging1RevView(onProcess: {
                self.showViewsRev[3] = false
                self.showViewsProc[3] = true
            },
                onModify: {
                self.showViews[3] = true
                self.showViewsRev[3] = false
            },
                onCancel: {
                self.showViews[3] = false
                self.showViewsRev[3] = false
            }
            )
        }
        .sheet(isPresented: bindingRev(for: 4)) {
            Imaging2RevView(onProcess: {
                self.showViewsRev[4] = false
                self.showViewsProc[4] = true
            },
                onModify: {
                self.showViews[4] = true
                self.showViewsRev[4] = false
            },
                onCancel: {
                self.showViews[4] = false
                self.showViewsRev[4] = false
            }
            )
        }

        .sheet(isPresented: bindingProc(for: 1)) {
            Imaging1ProcView(onComplete: {
                self.showViewsProc[1] = false
            })
        }
        .sheet(isPresented: bindingProc(for: 2)) {
            Imaging2ProcView(onComplete: {
                self.showViewsProc[2] = false
            })
        }
        .sheet(isPresented: bindingProc(for: 3)) {
            Imaging1ProcView(onComplete: {
                self.showViewsProc[3] = false
            })
        }
        .sheet(isPresented: bindingProc(for: 4)) {
            Imaging2ProcView(onComplete: {
                self.showViewsProc[4] = false
            })
        }
        
    }
        private var headerView: some View {
            HStack {
//                Text("Choose one of the options below")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                    .foregroundColor(Color("LL_blue")).opacity(0.5)
//                    .padding(.top, 50)
            }
        }
        
        private var buttonsGridView: some View {
            LazyVGrid(columns: columns, spacing: 100) {
                ForEach(1...4, id: \.self) { index in
                    buttonView(for: index)
                }
            }
            .padding(.bottom, 70)
//            .background(Color("LL_blue").opacity(0.5))
        }
        
        private func buttonView(for index: Int) -> some View {
            Button(action: {
                print("Button tapped \(index)")
                showViews[index] = true
                showViewsRev[index] = true
            }) {
                VStack {
                    Image(buttonImages[index - 1])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 125, height: 125)
                        .background(.white)
                        .cornerRadius(15)
//                        .padding(0)
                        .overlay(tooltipOverlay(for: index))
                }
            }
            .onHover { isHovering in
                hoverStates[index] = isHovering
            }
            .sheet(isPresented: binding(for: index)) {
                viewForIndex(index)
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
        
        private func binding(for index: Int) -> Binding<Bool> {
            Binding<Bool>(
                get: { self.showViews[index, default: false] },
                set: { self.showViews[index] = $0 }
            )
        }
        
        private func bindingRev(for index: Int) -> Binding<Bool> {
            Binding<Bool>(
                get: { self.showViewsRev[index, default: false] },
                set: { self.showViewsRev[index] = $0 }
            )
        }
        
        private func bindingProc(for index: Int) -> Binding<Bool> {
            Binding<Bool>(
                get: { self.showViewsProc[index, default: false] },
                set: { self.showViewsProc[index] = $0 }
            )
        }
        
        // Function to return the appropriate view based on the index
    
        private func viewForIndex(_ index: Int) -> some View {
            switch index {
            case 1:
                if showViews[1] ?? false {
                    return AnyView(Imaging1View(onReview: {
                        self.showViews[1] = false
                        self.showViewsRev[1] = true
                    }
                     ,
                       onCancel: {
                       self.resetToInitialState()
                    }
                                               ))
                } else if showViewsRev[1] ?? false {
                    return AnyView(Imaging1RevView(
                        onProcess: {
                            // Add your onProcess closure logic here
                        },
                        onModify: {
                            self.showViews[1] = true
                            self.showViewsRev[1] = false
                        },
                        onCancel: {
                            self.resetToInitialState()
                        }
                    ))
                } else {
                    // Return a default view if neither condition is true
                    return AnyView(Text("No view to display for case 1"))
                }

            case 2:
                if showViews[2] ?? false {
                    return AnyView(Imaging2View(onReview: {
                        self.showViews[2] = false
                        self.showViewsRev[2] = true
                    }
                     ,
                       onCancel: {
                       self.resetToInitialState()
                    }
                                               ))
                } else if showViewsRev[2] ?? false {
                    return AnyView(Imaging2RevView(
                        onProcess: {
                            // Add your onProcess closure logic here
                        },
                        onModify: {
                            self.showViews[2] = true
                            self.showViewsRev[2] = false
                        },
                        onCancel: {
                            self.resetToInitialState()
                        }
                    ))
                } else {
                    // Return a default view if neither condition is true
                    return AnyView(Text("No view to display for case 2"))
                }

            case 3:
                if showViews[3] ?? false {
                    return AnyView(Imaging3View(onReview: {
                        self.showViews[3] = false
                        self.showViewsRev[3] = true
                    }
                     ,
                       onCancel: {
                       self.resetToInitialState()
                    }
                                               ))
                } else if showViewsRev[3] ?? false {
                    return AnyView(Imaging3RevView(
                        onProcess: {
                            // Add your onProcess closure logic here
                        },
                        onModify: {
                            self.showViews[3] = true
                            self.showViewsRev[3] = false
                        },
                        onCancel: {
                            self.resetToInitialState()
                        }
                    ))
                } else {
                    // Return a default view if neither condition is true
                    return AnyView(Text("No view to display for case 3"))
                }

            case 4:
                if showViews[4] ?? false {
                    return AnyView(Imaging4View(onReview: {
                        self.showViews[4] = false
                        self.showViewsRev[4] = true
                    }
                     ,
                       onCancel: {
                       self.resetToInitialState()
                    }
                                               ))
                } else if showViewsRev[4] ?? false {
                    return AnyView(Imaging4RevView(
                        onProcess: {
                            // Add your onProcess closure logic here
                        },
                        onModify: {
                            self.showViews[4] = true
                            self.showViewsRev[4] = false
                        },
                        onCancel: {
                            self.resetToInitialState()
                        }
                    ))
                } else {
                    // Return a default view if neither condition is true
                    return AnyView(Text("No view to display for case 2"))
                }
                
//                return AnyView(Text("Placeholder for case 2"))
//            case 3:
////                Imaging1View(onReview: {
////                    self.showViews[1] = false // This will dismiss Imaging1View
////                    self.showViewsRev[1] = true // This will show Imaging1View
////                })
//            case 4:
////                Imaging1View(onReview: {
////                    self.showViews[1] = false // This will dismiss Imaging1View
////                    self.showViewsRev[1] = true // This will show Imaging1View
////                })
                
                // Add more cases as needed for each index/view
            default:
                return AnyView(Text("Default View for Index \(index)"))
            }
        }
    // Reset function
    private func resetToInitialState() {
        for index in 1...4 {
            showViews[index] = false
            showViewsRev[index] = false
            showViewsProc[index] = false
        }
        // Reset other state variables as necessary
    }

}

#Preview {
    MenuView(authModel: AuthenticationViewModel())
}

